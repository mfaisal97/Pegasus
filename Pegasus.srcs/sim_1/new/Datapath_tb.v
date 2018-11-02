// file: Datapath_tb.v
// author: @melodyg
// Testbench for Datapath

`timescale 1ns/1ns

module Datapath_tb;

	//Inputs
	reg clk = 0;
	reg rst;


	//Outputs


	//Instantiation of Unit Under Test
	Datapath uut (
		.clk(clk),
		.rst(rst)
	);

    always #100 begin
        clk = ~clk;
    end
	initial begin
	//Inputs initialization
		clk = 0;
		rst =1;


	//Wait for the reset
		#600;
        rst = 0;
	end

endmodule

