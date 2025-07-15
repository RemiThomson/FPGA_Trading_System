`timescale 1ns / 1ps

module tcp_state_machine(
    input CLK,
    input RESET,
    input PACKET_READY,
    input wire [31:0] PAYLOAD_DATA,
    output reg PACKET_READY_OUT,
    output reg [31:0] PAYLOAD_DATA_OUT
);

    wire [7:0] TCP_FLAGS = PAYLOAD_DATA[31:24];
    wire SYN = TCP_FLAGS[0];
    wire ACK = TCP_FLAGS[1];

    // TCP States
    localparam ST_LISTEN   = 2'd0;
    localparam ST_SYN_RCVD = 2'd1;
    localparam ST_EST      = 2'd2;

    reg [1:0] tcp_state;
    
    always @(posedge CLK) begin
        if (RESET) begin
            tcp_state        <= ST_LISTEN;
            PACKET_READY_OUT <= 1'b0;
        end else begin
            PACKET_READY_OUT <= 1'b0;

            if (PACKET_READY) begin
                case (tcp_state)
                    ST_LISTEN   : if (SYN & ~ACK) tcp_state <= ST_SYN_RCVD;
                    ST_SYN_RCVD : if (SYN &  ACK) tcp_state <= ST_EST;
                    ST_EST     : begin
                        //Forward packet 
                        PAYLOAD_DATA_OUT <= PAYLOAD_DATA;
                        PACKET_READY_OUT <= 1'b1;
                      end
                endcase
            end
        end
    end
endmodule
