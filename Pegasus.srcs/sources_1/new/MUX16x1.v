// file: MUX16x1.v
// author: @melodyg
/*******************************************************************
*
* Module: MUX16x1.v
* Project: Pegasus
* Author: Arig Mostafa, areeg.mostafa@aucegypt.edu
* Description: This module represents the Multiplexer needed to choose
 *             the ALU output based on the instruction's needs
*
* Change history: 01/01/17 – Did something
* 10/29/17 – Did something else
*
**********************************************************************/
`timescale 1ns/1ns
`include "defines.v"

module MUX16x1 (
    input [31:0] ADD, 
    input [31:0] SUB,
    input [31:0] SLL, 
    input [31:0] PASS,
    input [31:0] SLT, 
    input [31:0] F,
    input [31:0] SLTU, 
    input [31:0] H,
    input [31:0] XOR, 
    input [31:0] J,
    input [31:0] SRL, 
    input [31:0] SRA,
    input [31:0] OR_OP,
    input [31:0] N,
    input [31:0] AND_OP, 
    input [31:0] P, 
    input [3:0] sel, 
    output reg [31:0] out
    );
    always @(*) begin
        case(sel) 
            `ALU_ADD        :       out = ADD;
            `ALU_SUB        :       out = SUB;
            `ALU_SLL        :       out = SLL;
            `ALU_SLT        :       out = SLT;
            `ALU_SLTU       :       out = SLTU;
            `ALU_XOR        :       out = XOR;
            `ALU_SRL        :       out = SRL;
            `ALU_SRA        :       out = SRA;
            `ALU_OR         :       out = OR_OP;
            `ALU_AND        :       out = AND_OP;
            `ALU_PASS       :       out = PASS;
            default         :       out = `DEFAULT_OP;
        endcase
    end
endmodule
