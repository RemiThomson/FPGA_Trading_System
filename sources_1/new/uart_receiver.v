`timescale 1ns / 1ps

module ip_tcp_parser(
    input CLK,
    input RESET,
    input Rx,
    output reg packet_ready, //1-cycle pulse when packet is available
    output reg IP_READY,
    output reg [7:0] RxData,
    output reg [7:0] seq_num,
    output reg [7:0] ack_num,
    output reg [7:0] flags,
    output reg [2:0] payload_len,
    output reg [31:0] payload_data,
    output reg reset_byte_count_pulse
    );
    
    //Implementing a Receiver to simulate a TCP connection without optional headers over UART.
    
    //For the sake of this project a simplified TCP structure is used because the basys 3 board I have 
    //does not have an ethernet port.
    
    //Byte 0 : 0xAA (start byte)
    //Byte 1 : SEQ number (1 byte)
    //Byte 2 : ACK number (1 byte)
    //Byte 3 : FLAGS (bitmask: SYN=0x01, ACK=0x02)
    //Byte 4 : LEN (length of payload, max 5)
    //Byte 5-9 : Payload (e.g., ASCII '4''2' ? number 42)
    
    reg shift;
    reg state, nextstate;
    reg [3:0] bit_counter;
    reg [1:0] sample_counter;
    reg [13:0] baudrate_counter;
    reg [9:0] rxshift_reg;
    reg clear_bitcounter, inc_bitcounter, inc_samplecounter, clear_samplecounter;
    reg RxData_valid;
    
    parameter clk_freq = 100_000_000;
    parameter baud_rate = 9_600;
    parameter div_sample = 4;
    parameter div_counter = clk_freq/(baud_rate*div_sample);
    parameter mid_sample = (div_sample/2);
    parameter div_bit = 10;
    
    reg [7:0] received_protocol;
    reg [31:0] received_dest_ip;
    reg [7:0] DEST_IP [3:0];
    reg [3:0] byte_count;
    reg ip_valid;
    reg reset_byte_count;
    reg reset_byte_count_pulse;
    reg pulse_request;
    
    initial begin
        DEST_IP[0] = 8'd49; //1
        DEST_IP[1] = 8'd50; //2
        DEST_IP[2] = 8'd51; //3
        DEST_IP[3] = 8'd52; //4
    end
    
    always @ (posedge CLK) begin
        if (RESET || reset_byte_count_pulse) begin
            state <= 0;
            bit_counter <= 0;
            baudrate_counter <= 0;
            sample_counter <= 0;
            rxshift_reg [8:1] <= 0;
            RxData_valid <= 0;
            RxData <= 0;
            byte_count <= 0;
            IP_READY <= 0;
        end else begin
            RxData_valid <= 0;
            baudrate_counter <= baudrate_counter + 1;
            if (baudrate_counter >= div_counter - 1) begin
                baudrate_counter <= 0;
                state <= nextstate;
                if (shift) rxshift_reg <= {Rx, rxshift_reg[9:1]};
                if (clear_samplecounter) sample_counter <= 0;
                if (inc_samplecounter) sample_counter <= sample_counter + 1;
                if (clear_bitcounter) bit_counter <= 0;
                if (inc_bitcounter) bit_counter <= bit_counter + 1;
                
                if (bit_counter == div_bit - 1 && sample_counter == div_sample - 1) begin
                    RxData <= rxshift_reg[8:1]; //Extract 8 data bits
                    RxData_valid <= 1; //Signal a byte was received
                    
                    case (byte_count)
                        0: if (rxshift_reg[8:1] == 8'h70) byte_count <= byte_count + 1; //p
                        1: begin received_dest_ip[31:24] <= rxshift_reg[8:1]; byte_count <= byte_count + 1; end
                        2: begin received_dest_ip[23:16] <= rxshift_reg[8:1]; byte_count <= byte_count + 1; end
                        3: begin received_dest_ip[15:8] <= rxshift_reg[8:1]; byte_count <= byte_count + 1; end
                        4: begin
                            received_dest_ip[7:0] <= rxshift_reg[8:1];
                            if({received_dest_ip[31:8], rxshift_reg[8:1]} == {DEST_IP[0], DEST_IP[1], DEST_IP[2], DEST_IP[3]})
                                ip_valid <= 1;
                            else
                                ip_valid <= 0;
                            byte_count <= byte_count + 1;
                        end
                        5: begin
                            received_protocol <= rxshift_reg[8:1];
                            if (rxshift_reg[8:1] == 8'h74 && ip_valid) begin //t
                                byte_count <= byte_count + 1;
                                IP_READY <= 1;
                            end
                            else
                                byte_count <= 0;
                        end
                        default: byte_count <= byte_count + 1;
                    endcase
                end
            end
        end
    end
     
    // UART FSM logic
    always @ (posedge CLK) begin
        shift <= 0;
        clear_samplecounter <= 0;
        inc_samplecounter <= 0;
        clear_bitcounter <= 0;
        inc_bitcounter <= 0;
        nextstate <= 0;
        case (state)
            0: begin
                if (Rx)
                    nextstate <= 0;
                else begin
                    nextstate <= 1;
                    clear_bitcounter <= 1;
                    clear_samplecounter <= 1;
                end
            end
            1: begin
                nextstate <= 1;
                if (sample_counter == mid_sample - 1) shift <= 1;
                if (sample_counter == div_sample - 1) begin
                    if (bit_counter == div_bit - 1) 
                        nextstate <= 0;
                    inc_bitcounter <= 1;
                    clear_samplecounter <= 1;
                end else inc_samplecounter <= 1;
            end
            default: nextstate <= 0;
        endcase
    end
    
    //TCP parser FSM
    
    parameter P_IDLE = 3'd0;
    parameter P_SEQ = 3'd1;
    parameter P_ACK = 3'd2;
    parameter P_FLAGS = 3'd3;
    parameter P_LEN = 3'd4;
    parameter P_PAYL = 3'd5;
    
    reg [2:0] p_state;
    reg [2:0] payl_idx;
    
    
    always @(posedge CLK) begin
        if (RESET || reset_byte_count_pulse) begin
            p_state <= P_IDLE;
            packet_ready <= 1'b0;
            payload_data <= 40'd0;
            seq_num <= 8'd0;
            ack_num <= 8'd0;
            flags <= 8'd0;
            payload_len <= 3'd0;
            payl_idx <= 3'd0;
            pulse_request <= 0;
            
        end else begin
            packet_ready <= 1'b0;
            if (RxData_valid && byte_count > 5) begin //parse TCP if IP is valid and passed
                case (p_state)
                    P_IDLE: begin
                        if (RxData == 8'h71) begin //q on keyboard
                            p_state <= P_SEQ;
                        end
                    end
                    P_SEQ: begin
                        seq_num <= RxData;
                        p_state <= P_ACK;
                    end
                    P_ACK: begin
                        ack_num <= RxData;
                        p_state <= P_FLAGS;
                    end
                    P_FLAGS: begin
                        flags <= RxData;
                        p_state <= P_LEN;
                    end
                    P_LEN: begin
                    payload_len <= 3'd3; //takes in 4 payload bytes
                    payl_idx <= 0;
                    payload_data <= 40'd0;
                        if (RxData == 0) begin
                            packet_ready <= 1'b1;
                            p_state <= P_IDLE;
                        end else begin
                            p_state <= P_PAYL;
                        end
                    end
                    P_PAYL: begin
                        payload_data <= {payload_data[31:0], RxData};
                        payl_idx <= payl_idx + 1;
                        if (payl_idx == payload_len) begin
                            packet_ready <= 1'b1;
                            p_state <= P_IDLE;
                            pulse_request <= 1'b1; 
                        end
                    end
                endcase
            end
        end
    end 
    
    always @(posedge CLK) begin
        reset_byte_count_pulse <= pulse_request;
    end
    
endmodule