`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2018 07:25:23 PM
// Design Name: 
// Module Name: timer
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
module timer #(parameter UNIT = 10000000)(
        input clk,
        input rst,
        output reg pulse
    );
    
    reg [31:0] counter;
    
    always@ (posedge clk, posedge rst) 
    begin
        if(rst)
            counter <=0;
        else begin
            counter <= counter + `ONE_ONE_BIT;
            if(counter == UNIT)
                pulse <=  `ONE_ONE_BIT;
            else
                pulse <= `ZERO_ONE_BIT;      
        end
    end
endmodule
