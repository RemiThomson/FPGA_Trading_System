`timescale 1ns / 1ps

module debouncer(
    input CLK,
    input BTNR,
    output reg Transmit
    );
    
    parameter threshold = 100000;

    reg button_ff1 = 0;
    reg button_ff2 = 0;
    reg [30:0] count = 0;
    reg Transmit_q = 0;

    // Synchronise to clock domain
    always @(posedge CLK)
    begin
        button_ff1 <= BTNR;
        button_ff2 <= button_ff1;
    end

    always @(posedge CLK)
    begin
        if (button_ff2) begin
            if (~&count)
                count <= count + 1;
        end
        else begin
            if (|count)
                count <= count - 1;
        end

        // One-clock Transmit pulse generation
        Transmit_q <= Transmit;
        if (count > threshold)
            Transmit <= 1;
        else
            Transmit <= 0;

        // Convert to one-clock pulse
        Transmit <= (count > threshold) & ~Transmit_q;
    end
    

endmodule