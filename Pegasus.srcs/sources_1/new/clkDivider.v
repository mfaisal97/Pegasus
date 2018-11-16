`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2018 05:33:54 PM
// Design Name: 
// Module Name: clkDivider
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


module clkDivider#(parameter n = 1)(
    input clk,
    input rst,
    output reg clkd
    );
    
parameter freq = 100/2;

reg [31:0] count = 32'b0;

always@(posedge clk) begin
	if(rst) begin
		clkd <= 1'b0;
		count <= 32'b0;
	end
	else begin
		if(count >= freq/n -1) begin
			clkd <= ~clkd;
			count <= 32'b0;
		end
		else begin
			count <= count + 1;
			clkd <= clkd;
		end
	end
end
endmodule 