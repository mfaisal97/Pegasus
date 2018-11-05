// file: SlowSignal.v
// author: @ahmedleithy
/*******************************************************************
*
* Module: module_name.v
* Project: Project_Name
* Author: name and email
* Description: put your description here
*
* Change history: 01/01/17 – Did something
* 10/29/17 – Did something else
*
**********************************************************************/
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
