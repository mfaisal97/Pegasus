// file: SlowClock_tb.v
// author: @ahmedleithy
// Testbench SlowClock_tb

`timescale 1ns/1ns

module SlowSignal_tb;

    reg clk;
    reg rst;
    
    wire slow_signal;
    
    SlowSignal uut (
        .clk(clk),
        .rst(rst),
        .slow_signal(slow_signal)
    );
    
    always #20 clk=~clk;
    initial begin
        clk=0;
        rst=20;
        #50;
        rst=1;
        #50;
        rst=0;
    end
endmodule
