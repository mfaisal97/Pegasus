/*
// file: ControlUnit_tb.v
// author: @mfaisal
// Testbench for ControlUnit

`timescale 1ns/1ns

`include "defines.v"

module ControlUnit_tb;

    // ControlUnit Parameters
    parameter PERIOD  = 10;

	//Inputs
	reg [`IR_opcode] opcode;


	//Outputs
	wire alu_src_one_sel;
	wire mem_read;
	wire mem_write;
	wire reg_write_back;
	wire branch;
	wire lui;
	wire jal;
	wire jalr;
	wire auipc;


	//Instantiation of Unit Under Test
	ControlUnit uut (
		.opcode(opcode),
		.alu_src_two_sel(alu_src_two_sel),
		.mem_read(mem_read),
		.mem_write(mem_write),
		.reg_write_back(reg_write_back),
		.branch(branch),
		.lui(lui),
		.jal(jal),
		.jalr(jalr),
		.auipc(auipc)
	);


    initial begin
        #5 ;
        #(PERIOD)   opcode = `OPCODE_Branch;
        #(PERIOD)   opcode = `OPCODE_Load;
        #(PERIOD)   opcode = `OPCODE_Store;
        #(PERIOD)   opcode = `OPCODE_JALR;
        #(PERIOD)   opcode = `OPCODE_JAL;
        #(PERIOD)   opcode = `OPCODE_Arith_I;
        #(PERIOD)   opcode = `OPCODE_Arith_R;
        #(PERIOD)   opcode = `OPCODE_AUIPC;
        #(PERIOD)   opcode = `OPCODE_LUI;
        #(PERIOD)   opcode = `OPCODE_SYSTEM;
        #(PERIOD)   opcode = `OPCODE_Custom;
        $finish;
    end

endmodule
*/