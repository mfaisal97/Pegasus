// file: ALU_tb.v
// author: @melodyg
// Testbench for ALU

`timescale 1ns/1ns

module ALU_tb;

	//Inputs
	reg [3: 0] sel;
	reg [31: 0] A;
	reg [31: 0] B;


	//Outputs
	wire [31: 0] out;
	wire ZeroFlag;
	wire Cout;
	wire SignedBit;
	wire Overflow;


	//Instantiation of Unit Under Test
	ALU uut (
		.sel(sel),
		.A(A),
		.B(B),
		.out(out),
		.ZeroFlag(ZeroFlag),
		.Cout(Cout),
		.SignedBit(SignedBit),
		.Overflow(Overflow)
	);


	initial begin
	//Inputs initialization
		sel = 0;
		A = 3;
		B = 7;
		#50;
        sel = 4'b0001;
        #50
        sel = 4'b0010;
        #50
        sel = 4'b0011;
        #50
        sel = 4'b0100;
        #50
        sel = 4'b0101;
        #50
        sel = 4'b0110;
        #50
        sel = 4'b0111;
        #50
        sel = 4'b1000;
        #50
        sel = 4'b1001;
        #50
        sel = 4'b1010;
        #50
        sel = 4'b1011;
        #50
        sel = 4'b1100;
        #50
        sel = 4'b1101;
        #50
        sel = 4'b1110;
        #50
        sel = 4'b1111;
        #50;
	end
endmodule
