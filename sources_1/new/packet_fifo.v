`timescale 1ns / 1ps


module packet_fifo (
    input CLK,
    input RESET,
    input PACKET_READY,      
    input wire [31:0] PAYLOAD_DATA,
    output wire FIFO_EMPTY,
    output reg [31:0] PAYLOAD_DATA_OUT,
    output reg PACKET_READY_OUT
);
    parameter DEPTH = 8;
    parameter A = 3;  // since 2^3 = 8

    reg [31:0] mem [0:DEPTH-1];
    reg [A:0] wptr, rptr;      

    assign FIFO_EMPTY = (wptr == rptr);

    //Write
    always @(posedge CLK) begin
        if (!RESET && PACKET_READY && ( (wptr[A]^rptr[A]) == 1'b0 || wptr[A-1:0]!=rptr[A-1:0] )) begin
            mem[wptr[A-1:0]] <= PAYLOAD_DATA;
            wptr             <= wptr + 1;
        end
    end

    //Read
    always @(posedge CLK) begin
        if (RESET) begin
            rptr              <= 0;
            PACKET_READY_OUT  <= 1'b0;
        end else begin
            PACKET_READY_OUT <= 1'b0;
            if (!FIFO_EMPTY) begin
                PAYLOAD_DATA_OUT <= mem[rptr[A-1:0]];
                PACKET_READY_OUT <= 1'b1;
                rptr             <= rptr + 1;
            end
        end
    end
endmodule
