// file: ControlUnit.v
// author: @mfaisal

`timescale 1ns/1ns
`include "defines.v"

//Signals Length
//`define     OPCODE_Length               4:0

//Source Muxes Control Signals
// src2 == 0 then rf else imm
// src1 == 0 then rf else pc
// pcsrc == 0 then just adding 4 else getting adderval
// to solve problem with beq, just make use of the and module to eval MAGICBOOL

module ControlUnit (
    input [`IR_opcode] opcode,
    output alu_src_two_sel,
    output mem_read,
    output mem_write,
    output reg_write_back,
    output branch,
    output lui,
    output jal,
    output jalr
);

assign alu_src_two_sel = (opcode == `OPCODE_Arith_I) || (opcode == `OPCODE_Store) || (opcode == `OPCODE_JALR);
assign mem_read = (opcode == `OPCODE_Load);
assign mem_write = (opcode == `OPCODE_Store);
assign reg_write_back = (opcode == `OPCODE_Arith_I ) || (opcode == `OPCODE_Arith_R) || (opcode == `OPCODE_Store) || (opcode == `OPCODE_JAL) || (opcode == `OPCODE_JALR) || (opcode == `OPCODE_AUIPC);
assign branch = (opcode == `OPCODE_Branch);
assign jal = (opcode == `OPCODE_JAL);
assign jalr = (opcode == `OPCODE_JALR);
assign lui = (opcode == `OPCODE_LUI);

endmodule
