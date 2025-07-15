`timescale 1ns / 1ps

module risk_management(

    input CLK,
    input RESET,

    input TRADE_VALID,
    input wire [7:0] TRADE_PRICE,
    input wire [7:0] TRADE_QTY,
    input wire [7:0] BUY_ID,
    input wire [7:0] SELL_ID,

    output reg TRADE_APPROVED,
    output reg [7:0] APPR_PRICE,
    output reg [7:0] APPR_QTY,
    output reg [7:0] APPR_BUY_ID,
    output reg [7:0] APPR_SELL_ID
);
    
    parameter signed MAX_POSITION = 100;
    parameter signed MAX_EXPOSURE = 5000;
    
    reg signed [31:0] current_position;
    reg signed [31:0] current_exposure;

    reg signed [31:0] next_pos;
    reg signed [31:0] next_exp;
    
    always @(posedge CLK) begin
        if (RESET) begin
            current_position <= 0;
            current_exposure <= 0;
            TRADE_APPROVED   <= 1'b0;
        end else begin
            TRADE_APPROVED <= 1'b0;
    
            if (TRADE_VALID) begin
                next_pos = current_position + TRADE_QTY;
                next_exp = current_exposure + TRADE_QTY * TRADE_PRICE;
    
                if ( (next_pos <=  MAX_POSITION) &&
                     (next_pos >= -MAX_POSITION) &&
                     (next_exp <=  MAX_EXPOSURE) &&
                     (next_exp >= -MAX_EXPOSURE) ) begin
    
                    current_position <= next_pos;
                    current_exposure <= next_exp;
    
                    TRADE_APPROVED   <= 1'b1;
                    APPR_PRICE       <= TRADE_PRICE;
                    APPR_QTY         <= TRADE_QTY;
                    APPR_BUY_ID      <= BUY_ID;
                    APPR_SELL_ID     <= SELL_ID;
                end
            end
        end
    end

endmodule
