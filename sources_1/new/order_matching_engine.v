`timescale 1ns / 1ps

module order_matching_engine(
    input CLK,
    input RESET,
    input packet_ready,
    input reset_byte_count_pulse,
    input [31:0] payload_data,
    output reg trade_valid,
    output reg [7:0] trade_price,
    output reg [7:0] trade_qty,
    output reg [7:0] buy_id,
    output reg [7:0] sell_id
);

reg [7:0] flags;
reg [7:0] price;
reg [7:0] qty;
reg [7:0] order_id;

localparam F_CANCEL = 7;         
localparam F_SIDE   = 0;         
localparam MAX_ORDERS = 16;

reg [7:0] bid_p [0:MAX_ORDERS-1];
reg [7:0] bid_q [0:MAX_ORDERS-1];
reg [7:0] bid_id[0:MAX_ORDERS-1];
reg bid_v [0:MAX_ORDERS-1];

reg [7:0] ask_p [0:MAX_ORDERS-1];
reg [7:0] ask_q [0:MAX_ORDERS-1];
reg [7:0] ask_id[0:MAX_ORDERS-1];
reg ask_v [0:MAX_ORDERS-1];

// simple round-robin indexers so the whole book is checked over time 
reg [3:0] scan_idx, insert_idx; //4 bits for MAX_ORDERS of 16 set above

//State encodings
localparam S_IDLE   = 2'd0;
localparam S_SCAN   = 2'd1;
localparam S_CANCEL = 2'd2;
localparam S_INSERT = 2'd3;

// State register
reg [1:0] state;
integer i;

always @(posedge CLK) begin
    if (RESET || reset_byte_count_pulse) begin
        flags     <= 8'd0;
        price     <= 8'd0;
        qty       <= 8'd0;
        order_id  <= 8'd0;
    end else if (packet_ready) begin
        flags     <= payload_data[31:24];
        price     <= payload_data[23:16];
        qty       <= payload_data[15:8];
        order_id  <= payload_data[7:0];
    end
end

always @(posedge CLK) begin
    if (RESET) begin
        state        <= S_IDLE;
        scan_idx     <= 0;
        insert_idx   <= 0;
        trade_valid  <= 1'b0;
        //Clear valid flags 
        for (i=0; i<MAX_ORDERS; i=i+1) begin
            bid_v[i]   <= 1'b0;
            bid_p[i]   <= 8'd0;
            bid_q[i]   <= 8'd0;
            bid_id[i]  <= 8'd0;
            ask_v[i]   <= 1'b0;
            ask_p[i]   <= 8'd0;
            ask_q[i]   <= 8'd0;
            ask_id[i]  <= 8'd0;
        end
    end else begin
        trade_valid <= 1'b0;     

        case (state)
        //wait for a command 
        S_IDLE: begin
            if (packet_ready) begin
                if (flags[F_CANCEL]) begin
                    state <= S_CANCEL;      
                end else begin
                    state <= S_SCAN;        
                end
                scan_idx <= 0;              
            end
        end

        S_CANCEL: begin
            if (scan_idx < MAX_ORDERS) begin
                if (!flags[F_SIDE]) begin   //cancel BUY
                    if (bid_v[scan_idx] && bid_id[scan_idx]==order_id) begin
                        bid_v[scan_idx] <= 1'b0;
                        state          <= S_IDLE;
                    end else begin
                        scan_idx <= scan_idx + 1;
                    end
                end else begin             //cancel SELL
                    if (ask_v[scan_idx] && ask_id[scan_idx]==order_id) begin
                        ask_v[scan_idx] <= 1'b0;
                        state          <= S_IDLE;
                    end else begin
                        scan_idx <= scan_idx + 1;
                    end
                end
            end else begin
                state <= S_IDLE;           
            end
        end

        //Attempt immediate match 
        S_SCAN: begin        
            if (!flags[F_SIDE]) begin //BUY
                if (scan_idx < MAX_ORDERS) begin
                    if (ask_v[scan_idx] && ask_p[scan_idx] <= price) begin
                        
                        trade_price <= ask_p[scan_idx];
                        trade_qty   <= (qty <= ask_q[scan_idx]) ? qty : ask_q[scan_idx];
                        buy_id      <= order_id;
                        sell_id     <= ask_id[scan_idx];
                        trade_valid <= 1'b1;

                        //Update remaining quantities 
                        if (qty < ask_q[scan_idx]) begin
                            ask_q[scan_idx] <= ask_q[scan_idx] - qty;
                            state           <= S_IDLE;  //completely filled
                        end else begin
                            ask_v[scan_idx] <= 1'b0;    //resting order filled
                            state           <= S_IDLE;
                        end
                    end else begin
                        scan_idx <= scan_idx + 1;   //keep looking
                    end
                end else begin
                    state <= S_INSERT;   //no match, store as bid
                end
            end else begin  //SELL
                if (scan_idx < MAX_ORDERS) begin
                    if (bid_v[scan_idx] && bid_p[scan_idx] >= price) begin
                        trade_price <= bid_p[scan_idx];
                        trade_qty   <= (qty <= bid_q[scan_idx]) ? qty : bid_q[scan_idx];
                        buy_id      <= bid_id[scan_idx];
                        sell_id     <= order_id;
                        trade_valid <= 1'b1;

                        if (qty < bid_q[scan_idx]) begin
                            bid_q[scan_idx] <= bid_q[scan_idx] - qty;
                            state           <= S_IDLE;
                        end else begin
                            bid_v[scan_idx] <= 1'b0;
                            state           <= S_IDLE;
                        end
                    end else begin
                        scan_idx <= scan_idx + 1;
                    end
                end else begin
                    state <= S_INSERT;   //store as ask
                end
            end
        end 

        //Add resting order to book 
        S_INSERT: begin
            if (!flags[F_SIDE]) begin //BUY
                if (!bid_v[insert_idx]) begin
                    bid_v [insert_idx] <= 1'b1;
                    bid_p [insert_idx] <= price;
                    bid_q [insert_idx] <= qty;
                    bid_id[insert_idx] <= order_id;
                    state              <= S_IDLE;
                end
            end else begin //SELL
                if (!ask_v[insert_idx]) begin
                    ask_v [insert_idx] <= 1'b1;
                    ask_p [insert_idx] <= price;
                    ask_q [insert_idx] <= qty;
                    ask_id[insert_idx] <= order_id;
                    state              <= S_IDLE;
                end
            end
            // advance insert pointer every clock until a hole is found 
            insert_idx <= (insert_idx==MAX_ORDERS-1) ? 0 : insert_idx+1;
        end

        default: state <= S_IDLE;
        endcase
    end
end

endmodule
