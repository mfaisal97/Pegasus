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
*                 11/01/18 – I added the pass signal instead of default 
*                            0 as I finally understood why its needed for 
*                            LUI instruction.
*                 11/03/18 – I'm cleaning up our code with constants and 
*                            making sure we are following the coding guidelines
**********************************************************************/
`timescale 1ns/1ns
`include "defines.v"

module ALU (
    input [`ALUSEL_SIZE] sel, 
    input [`DATA_SIZE] A, 
    input [`DATA_SIZE] B, 
    output [`DATA_SIZE] out, 
    output ZeroFlag,
    output Cout,
    output SignedBit,
    output Overflow
    );
    wire [`DATA_SIZE] AddSubALU;
    wire [`DATA_SIZE] AndALU;
    wire [`DATA_SIZE] OrALU;
    wire [`DATA_SIZE] XorALU;
    wire [`DATA_SIZE] SLL_ALU;
    wire [`DATA_SIZE] SRL_ALU; 
    wire [`DATA_SIZE] SRA_ALU;
    wire [`DATA_SIZE] SLT_ALU;
    wire [`DATA_SIZE] SLTU_ALU;
    wire [`DATA_SIZE] B_Comp;
    
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
        .F(`ZERO_32),
        .SLTU(SLTU_ALU), 
        .H(`ZERO_32), 
        .XOR(XorALU), 
        .J(`ZERO_32), 
        .SRL(SRL_ALU), 
        .SRA(SRA_ALU), 
        .OR_OP(OrALU),
        .N(`ZERO_32), 
        .AND_OP(AndALU), 
        .P(`ZERO_32), 
        .sel(sel), 
        .out(out)
        );
  
    assign ZeroFlag = ~|AddSubALU;
    assign SignedBit = AddSubALU[31];
    assign Overflow = A[31]^B_Comp[31]^AddSubALU[31]^Cout;
endmodule
