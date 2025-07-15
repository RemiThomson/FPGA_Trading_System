`timescale 1ns / 1ps

module uart_transmitter(
    input CLK,
    input RESET,
    input [7:0] RxData,
    input Transmit,
    output reg Tx
);

    reg [3:0] bit_counter;
    reg [13:0] baudrate_counter;
    reg [9:0] shiftright_register;
    reg state, next_state;
    reg shift;
    reg load;
    reg clear;

    // REGISTER TO HOLD Tx VALUE TO AVOID MULTIPLE DRIVERS
    reg tx_next;

    always @(posedge CLK) begin
        if (RESET) begin
            state <= 0;
            bit_counter <= 0;
            baudrate_counter <= 0;
            Tx <= 1;  // Line idles high
            shiftright_register <= 10'h3FF;
        end else begin
            baudrate_counter <= baudrate_counter + 1;
            if (baudrate_counter == 10415) begin
                state <= next_state;
                baudrate_counter <= 0;
                Tx <= tx_next;  // SET Tx IN ONE PLACE ONLY

                if (load)
                    shiftright_register <= {1'b1, RxData, 1'b0};

                if (clear)
                    bit_counter <= 0;

                if (shift) begin
                    shiftright_register <= {1'b1, shiftright_register[9:1]};
                    bit_counter <= bit_counter + 1;
                end
            end
        end
    end

    // Mealy FSM
    always @(posedge CLK) begin
        load <= 0;
        shift <= 0;
        clear <= 0;
        tx_next <= 1;  // Default to idle line (HIGH)

        case (state)
            0: begin
                if (Transmit) begin
                    next_state <= 1;
                    load <= 1;
                end else begin
                    next_state <= 0;
                    tx_next <= 1;
                end
            end

            1: begin
                if (bit_counter == 10) begin
                    next_state <= 0;
                    clear <= 1;
                end else begin
                    next_state <= 1;
                    tx_next <= shiftright_register[0];  
                    shift <= 1;
                end
            end

            default: begin
                next_state <= 0;
                tx_next <= 1;
            end
        endcase
    end

endmodule
