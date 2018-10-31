// file: Memory_tb.v
// author: @ahmedleithy
// Testbench for Memory

`timescale 1ns/1ns

module Memory_tb;

	//Inputs
	reg clk=0;
	reg rst;
	reg [31: 0] address;
	reg [31: 0] data;
	reg lw;
	reg lh;
	reg lhu;
	reg lb;
	reg lbu;
	reg sw;
	reg sh;
	reg sb;


	//Outputs
	wire [31: 0] dataout;


	//Instantiation of Unit Under Test
	Memory uut (
		.clk(clk),
		.address(address),
		.data(data),
		.lw(lw),
		.lh(lh),
		.lhu(lhu),
		.lb(lb),
		.lbu(lbu),
		.sw(sw),
		.sh(sh),
		.sb(sb),
		.dataout(dataout)
	);

    always 
        begin #22
            clk=~clk;
        end
        
        
	initial begin
	//Inputs initialization
		clk = 0;
		address = 0;
		data = 0;
		lw = 0;
		lh = 0;
		lhu = 0;
		lb = 0;
		lbu = 0;
		sw = 0;
		sh = 0;
		sb = 0;


	//Wait for the reset
	    
		#100;
		address = 4;
        data = 32'b00000000_11111111_10001111_11110000;
        sw=1;
        #250;
        address = 6;
        sw=0;
        lbu =1;
        #250
        sh = 1;
        lbu=0;
        address =0;
        #250;
        address =1;
        sh =0;  
        lb = 1;
        #250;
        address =0;
        lb = 0;
        lw =1;
        #250;
        address =4;
        #250;
	end

endmodule
