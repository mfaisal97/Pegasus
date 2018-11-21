`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/17/2018 07:59:04 PM
// Design Name: 
// Module Name: RisingEdgeDetector2Cycle
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


module RisingEdgeDetector2Cycle(
    input clk,
    input rst,
    input signal,
    output reg signal_edge
    );
    
    
    reg [2:0] signal_edge_internal;
    
    always @(posedge clk) begin
            if(rst) begin 
                signal_edge = 0;
                signal_edge_internal = 3'b0;
            end
            else begin
            signal_edge_internal = {signal, signal_edge_internal[2:1]};
            signal_edge = (signal_edge_internal == 3'b100) || (signal_edge_internal == 3'b110) || (signal_edge_internal == 3'b010);
            end   
    end 
endmodule
