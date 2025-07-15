`timescale 1ns / 1ps


module order_matching_engine_tb;
      
      
    reg CLK = 0;
    reg RESET = 1;
    reg packet_ready = 0;
    reg reset_byte_count_pulse = 0;
    reg [31:0] payload_data = 32'd0;
    
    wire trade_valid;
    wire [7:0] trade_price, trade_qty, buy_id, sell_id;
    
    /* --- instantiate the DUT --- */
    order_matching_engine DUT (
        .CLK                   (CLK),
        .RESET                 (RESET),
        .packet_ready          (packet_ready),
        .reset_byte_count_pulse(reset_byte_count_pulse),
        .payload_data          (payload_data),
        .trade_valid           (trade_valid),
        .trade_price           (trade_price),
        .trade_qty             (trade_qty),
        .buy_id                (buy_id),
        .sell_id               (sell_id)
    );
    
    parameter CLK_PERIOD = 10;
    
      // Clock generation
    always begin
      CLK = 1'b0;
      #(CLK_PERIOD/2);
      CLK = 1'b1;
      #(CLK_PERIOD/2);
    end
    
    initial begin
        $monitor("T=%0t | flags=%h price=%d qty=%d id=%d", 
        $time, DUT.flags, DUT.price, DUT.qty, DUT.order_id);
        CLK = 0;
        RESET = 0;
        packet_ready = 0;
        reset_byte_count_pulse = 0;
        payload_data = 32'd0;
 
        @(posedge CLK);
        RESET = 1;
        @(posedge CLK);
        RESET = 0;
        
        @(posedge CLK);
        payload_data = {8'b00000000, 8'd42, 8'd10, 8'd7};
        packet_ready = 1;

    end
    
    /* --- simple monitor --- */
    always @ (posedge CLK)
        if (trade_valid)
            $display("[%0t] TRADE  price=%0d qty=%0d  buy_id=%h sell_id=%h",
                     $time, trade_price, trade_qty, buy_id, sell_id);

endmodule
