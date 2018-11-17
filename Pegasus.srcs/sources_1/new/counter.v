`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2018 06:29:29 PM
// Design Name: 
// Module Name: counter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "defines.v"
module counter#(parameter bits = 32)(
    input clk,
    input rst,
    input en,
    output reg [bits-1:0]count
    );
    always@(posedge clk)
    begin 
        if (rst)
            count <=0;
        else if (en)
            count <= count + `ONE_ONE_BIT;
        else 
            count <= count;    
    end
endmodule
