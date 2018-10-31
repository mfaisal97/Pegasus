// file: MemControl_tb.v
// author: @ahmedleithy
// Testbench for MemControl

`timescale 1ns/1ns

module MemControl_tb;

	//Inputs
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
	reg [7: 0] bankdata0;
	reg [7: 0] bankdata1;
	reg [7: 0] bankdata2;
	reg [7: 0] bankdata3;


	//Outputs
	wire [3: 0] bankwritereadbar;
	wire [7: 0] savedata0;
	wire [7: 0] savedata1;
	wire [7: 0] savedata2;
	wire [7: 0] savedata3;
	wire [31: 0] dataout;


	//Instantiation of Unit Under Test
	MemControl uut (
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
		.bankdata0(bankdata0),
		.bankdata1(bankdata1),
		.bankdata2(bankdata2),
		.bankdata3(bankdata3),
		.bankwritereadbar(bankwritereadbar),
		.savedata0(savedata0),
		.savedata1(savedata1),
		.savedata2(savedata2),
		.savedata3(savedata3),
		.dataout(dataout)
	);


	initial begin
	//Inputs initialization
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
		bankdata0 = 0;
		bankdata1 = 0;
		bankdata2 = 0;
		bankdata3 = 0;


	//Wait for the reset
		#100;
        bankdata0 = 8'b10000000;
		bankdata1 = 8'b10000011;
		bankdata2 = 8'b10001111;
		bankdata3 = 8'b00111111;
		
		
		sw=1;
		data = 32'b00000000_11111101_00000010_11111111;
		#250;
		sw=0;
		sb=1;
		#250;
		sb=0;
		sh=1;
		#250;
		address = 0;
        lb =1;
        #250;
        address = 1;
        #250;
        address = 2;
        #250;
        address = 3;
        #250;
        lb=0;
        lh=1;
        address=2;
        #250;
        lh=0;
        lhu=1;
        #250;
	end

endmodule
