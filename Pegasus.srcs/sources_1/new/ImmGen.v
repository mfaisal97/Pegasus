/*******************************************************************
*
* Module: rv32_ImmGen.v
* Project: Pegasus
* Author: Mohamed Shalan, mshalan@aucegypt.edu
* Description: Immediate generator module depending on the type of instruction
*
* Change history: ------
*
**********************************************************************/
`timescale 1ns/1ns
`include "defines.v"

module rv32_ImmGen (
	input  wire [`REGISTERS_RANGE]  IR,
	output reg  [`REGISTERS_RANGE]  Imm
);

always @(*) begin
	case (`OPCODE)
		`OPCODE_Arith_I   :     Imm = { {21{IR[31]}}, IR[30:25], IR[24:21], IR[20] };
		`OPCODE_Store     :     Imm = { {21{IR[31]}}, IR[30:25], IR[11:8], IR[7] };
		`OPCODE_LUI       :     Imm = { IR[31], IR[30:20], IR[19:12], 12'b0 };
		`OPCODE_AUIPC     :     Imm = { IR[31], IR[30:20], IR[19:12], 12'b0 };
		`OPCODE_JAL       :     Imm = { {12{IR[31]}}, IR[19:12], IR[20], IR[30:25], IR[24:21], 1'b0 };
		`OPCODE_JALR      :     Imm = { {21{IR[31]}}, IR[30:25], IR[24:21], IR[20] };
		`OPCODE_Branch    :     Imm = { {20{IR[31]}}, IR[7], IR[30:25], IR[11:8], 1'b0};
		`OPCODE_SYSTEM    :     Imm = { 27'b0, IR[19:15]};
		default           :     Imm = { {21{IR[31]}}, IR[30:25], IR[24:21], IR[20] }; // IMM_I
	endcase 
end
endmodule
