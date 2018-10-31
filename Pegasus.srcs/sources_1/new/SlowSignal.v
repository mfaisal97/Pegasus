// file: SlowSignal.v
// author: @ahmedleithy
`include "defines.v"

`timescale 1ns/1ns

module SlowSignal(
    input clk, 
    input rst,
    output reg [0:0] slow_signal
    );
    
    
        
    always @(posedge clk) begin
        if(rst)
            slow_signal <=  `ZERO;
        else
            slow_signal <= ~slow_signal;
    end
    
    
endmodule