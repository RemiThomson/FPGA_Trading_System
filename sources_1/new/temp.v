`timescale 1ns / 1ps

module temp(
    input packet_ready,
    input [7:0] seq_num,
    input [7:0] ack_num,
    input [7:0] flags,
    input [2:0] payload_len,
    input [31:0] payload_data,
    input CLK,
    input RESET,
    input IP_READY,
    output reg READY,
    output reg IP_LED
    );
    
    
    reg [25:0] ready_timer;
    
    always @(posedge CLK) begin
        if (RESET) begin
            READY <= 0;
            ready_timer <= 0;
            IP_LED <= 0;
        end else begin
            // Timer-based READY LED
            if (packet_ready) begin
                READY <= 1;
                ready_timer <= 26'd50_000_000; // 0.5s at 100 MHz
            end else if (ready_timer > 0) begin
                ready_timer <= ready_timer - 1;
                READY <= 1;
            end else begin
                READY <= 0;
            end
    
            // Instant IP LED
            if (IP_READY)
                IP_LED <= 1;
            else
                IP_LED <= 0;
        end
    end
endmodule

      