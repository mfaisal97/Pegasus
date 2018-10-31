// file: ForwardingUnit_tb.v
// author: @melodyg
// Testbench for ForwardingUnit

`timescale 1ns/1ns

module ForwardingUnit_tb;

	//Inputs
	reg [6: 2] opcode;
	reg [4: 0] rs1;
	reg [4: 0] rs2;
	reg [4: 0] rd;
	reg reg_write;


	//Outputs
	wire forward_a;
	wire forward_b;
	wire forward_store;


	//Instantiation of Unit Under Test
	ForwardingUnit uut (
		.opcode(opcode),
		.rs1(rs1),
		.rs2(rs2),
		.rd(rd),
		.reg_write(reg_write),
		.forward_a(forward_a),
		.forward_b(forward_b),
		.forward_store(forward_store)
	);


	initial begin
	//Inputs initialization
		opcode = 5'b11_000; //Branch
		rs1 = 1;
		rs2 = 1;
		rd = 1;
		reg_write = 1;
		#50;
		opcode = 5'b00_000; //Load
	    #50
		opcode = 5'b01_000; //Store
	    #50
		opcode = 5'b11_001; //JALR
	    #50
	    opcode = 5'b11_011; //JAL
	    #50
	    opcode = 5'b00_100; //Arith_I
	    #50
	    opcode = 5'b01_100; //Arith_R 
	    #50
		opcode = 5'b11_000; //Branch
		rs1 = 1;
		rs2 = 1;
		rd = 1;
		reg_write = 0;
		#50;
		opcode = 5'b00_000; //Load
	    #50
		opcode = 5'b01_000; //Store
	    #50
		opcode = 5'b11_001; //JALR
	    #50
	    opcode = 5'b11_011; //JAL
	    #50
	    opcode = 5'b00_100; //Arith_I
	    #50
	    opcode = 5'b01_100; //Arith_R 
	    #50;

	end

endmodule
