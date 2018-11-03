// file: ALU.v
// author: @melodyg
/*******************************************************************
*
* Module: ALU.v
* Project: Pegasus
* Author: Arig Mostafa, areeg.mostafa@aucegypt.edu
* Description: This module represents the Arithmetic Logic Unit of our CPU 
*               that is the major component of the execute stage. 
*               It supports all the instructions of RISC-V32I
*
* Change history: 01/01/17 – Did something
*                 10/29/17 – Did something else
*
**********************************************************************/
`timescale 1ns/1ns
`include "defines.v"

module ALU (
    input [3:0] sel, 
    input [31:0] A, 
    input [31:0] B, 
    output [31:0] out, 
    output ZeroFlag,
    output Cout,
    output SignedBit,
    output Overflow
    );
    wire [31:0] AddSubALU;
    wire [31:0] AndALU;
    wire [31:0] OrALU;
    wire [31:0] XorALU;
    wire [31:0] SLL_ALU;
    wire [31:0] SRL_ALU; 
    wire [31:0] SRA_ALU;
    wire [31:0] SLT_ALU;
    wire [31:0] SLTU_ALU;
    wire [31:0] B_Comp;
    
    assign B_Comp = ~B;
    
    assign AndALU = A & B;
    assign OrALU = A | B;
    assign XorALU = A ^ B;
    assign SLL_ALU = A << B[4:0];
    assign SRL_ALU = A >> B[4:0];
    assign SRA_ALU = $signed($signed(A) >>> B[4:0]);
    assign SLT_ALU = {`ZEROs_31, $signed(A) < $signed(B)};
    assign SLTU_ALU = {`ZEROs_31, A < B};
    assign {Cout, AddSubALU} = sel[0]? (A + B_Comp + `ONEs_1) : A + B;
    
    MUX16x1 Multiplexer (
        .ADD(AddSubALU), 
        .SUB(AddSubALU), 
        .SLL(SLL_ALU), 
        .PASS(B), 
        .SLT(SLT_ALU), 
        .F(32'd0),
        .SLTU(SLTU_ALU), 
        .H(32'd0), 
        .XOR(XorALU), 
        .J(32'd0), 
        .SRL(SRL_ALU), 
        .SRA(SRA_ALU), 
        .OR_OP(OrALU),
        .N(32'd0), 
        .AND_OP(AndALU), 
        .P(32'd0), 
        .sel(sel), 
        .out(out)
        );
  
    assign ZeroFlag = ~|AddSubALU;
    assign SignedBit = AddSubALU[31];
    assign Overflow = A[31]^B_Comp[31]^AddSubALU[31]^Cout;
endmodule
