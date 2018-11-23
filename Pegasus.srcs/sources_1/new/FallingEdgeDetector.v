`timescale 1ns / 1ps


module FallingEdgeDetector(
    input clk,
    input rst,
    input signal,
    output reg signal_edge
    );
    
    reg [1:0] signal_edge_internal;
    
    always @(posedge clk) begin
            
            if(rst) begin 
                signal_edge = 0;
                signal_edge_internal = 2'b0;
            end
            else begin
            signal_edge_internal = {signal, signal_edge_internal[1]};
            signal_edge = (signal_edge_internal == 2'b01);
            end   
    end 
endmodule