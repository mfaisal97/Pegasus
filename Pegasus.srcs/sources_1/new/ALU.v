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
* Change history: 22/10/18 – Did the ALU Skeleton
*                 24/10/18 – Added the Logic of the ALU functionalities as well
*                            as the multiplexer to choose the output 
*                 29/10/18 – Instead of RCA I used the + as suggested to allow
*                            flexibilty
*                 01/11/18 – I added the pass signal instead of default 
*                            0 as I finally understood why its needed for 
*                            LUI instruction.
*                 03/11/18 – I'm cleaning up our code with constants and 
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
    assign SLL_ALU = A << B[`_2ND_OPERAND_LOWER_5];
    assign SRL_ALU = A >> B[`_2ND_OPERAND_LOWER_5];
    assign SRA_ALU = $signed($signed(A) >>> B[`_2ND_OPERAND_LOWER_5]);
    assign SLT_ALU = {`ZERO_31, $signed(A) < $signed(B)};
    assign SLTU_ALU = {`ZERO_31, A < B};
    assign {Cout, AddSubALU} = sel[`ZERO_1]? (A + B_Comp + `ONE_1) : A + B;
    
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
    assign SignedBit = AddSubALU[`LAST_BIT];
    assign Overflow = A[`LAST_BIT]^B_Comp[`LAST_BIT]^AddSubALU[`LAST_BIT]^Cout;
endmodule
