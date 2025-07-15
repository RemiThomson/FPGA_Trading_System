`timescale 1ns / 1ps

module Wrapper(
    input CLK,              
    input RESET,              
    input Rx,
    input BTNR,              
    output [7:0] LED,
    output Tx,
    output Tx_debug,
    output Transmit_debug,
    output BTNR_debug,
    output CLK_debug,
    output READY,
    output IP_LED
);
    
    wire [7:0] RxData;
    wire [7:0] seq_num;
    wire [7:0] ack_num;
    wire [7:0] flags;
    wire [2:0] payload_len;
    wire [31:0] payload_data;
    wire [7:0] trade_price;
    wire [7:0] trade_qty;
    wire [7:0] buy_id;
    wire [7:0] sell_id;

    wire fifo_empty;
    wire [31:0] fifo_data;
    wire fifo_ready;
    
    wire [31:0] tcp_data;
    wire tcp_ready;
    
    wire risk_ok;
    wire [7:0] APPR_PRICE, APPR_QTY, APPR_BUY, APPR_SELL;
    
    assign LED = RxData;
    assign Tx_debug = Tx;
    assign Transmit_debug = Transmit;
    assign BTNR_debug = BTNR;
    assign CLK_debug = CLK;
    
    ip_tcp_parser IP_AND_TCP_PARSER(
        .CLK(CLK),
        .RESET(RESET),
        .Rx(Rx),
        .RxData(RxData),
        .packet_ready(packet_ready),
        .seq_num(seq_num),
        .ack_num(ack_num),
        .flags(flags),
        .payload_len(payload_len),
        .payload_data(payload_data),
        .reset_byte_count_pulse(reset_byte_count_pulse),
        .IP_READY(IP_READY)
    );
    
    temp TEMP(
        .RESET(RESET),
        .CLK(CLK),
        .packet_ready(packet_ready),
        .IP_READY(IP_READY),
        .seq_num(seq_num),
        .ack_num(ack_num),
        .flags(flags),
        .payload_len(payload_len),
        .payload_data(payload_data),
        .READY(READY),
        .IP_LED(IP_LED)
    );
    
    order_matching_engine ORDER_MATCHING_ENGINE(
        .CLK(CLK),
        .RESET(RESET),
        .packet_ready(packet_ready),
        .reset_byte_count_pulse(reset_byte_count_pulse),
        .payload_data(payload_data),
        .trade_valid(trade_valid),
        .trade_price(trade_price),
        .trade_qty(trade_qty),
        .buy_id(buy_id),
        .sell_id(sell_id)
    );
    
    packet_fifo FIFO (
        .CLK(CLK), 
        .RESET(RESET),
        .PACKET_READY(packet_ready),
        .PAYLOAD_DATA(payload_data),
        .FIFO_EMPTY(fifo_empty),
        .PAYLOAD_DATA_OUT(fifo_data),
        .PACKET_READY_OUT(fifo_ready)
    );
    
    tcp_state_machine TCP (
        .CLK(CLK), 
        .RESET(RESET),
        .PACKET_READY(fifo_ready),
        .PAYLOAD_DATA(fifo_data),
        .PACKET_READY_OUT(tcp_ready),
        .PAYLOAD_DATA_OUT(tcp_data)
    );
    
    risk_management RISK (
        .CLK(CLK), 
        .RESET(RESET),
        .TRADE_VALID(trade_valid),
        .TRADE_PRICE(trade_price),
        .TRADE_QTY(trade_qty),
        .BUY_ID(buy_id),
        .SELL_ID(sell_id),
        .TRADE_APPROVED(risk_ok),
        .APPR_PRICE(APPR_PRICE), 
        .APPR_QTY(APPR_QTY), 
        .APPR_BUY_ID(APPR_BUY), 
        .APPR_SELL_ID(APPR_SELL)
    );
        
    uart_transmitter UART_TRANSMITTER(
        .CLK(CLK),
        .RESET(RESET),  
        .RxData(RxData),
        .Transmit(BTNR),
        .Tx(Tx)
    );

    debouncer DEBOUNCE_SIGNALS(
        .CLK(CLK),
        .BTNR(BTNR),
        .Transmit(Transmit)
    );
        

endmodule