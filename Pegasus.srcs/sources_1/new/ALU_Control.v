// file: ALU_Control.v
// author: @melodyg
/*******************************************************************
*
* Module: ALU_Control.v
* Project: Pegasus
* Author: Arig Mostafa, areeg.mostafa@aucegypt.edu
* Description: This module represents the ALU Control Unit of our ALU 
*               as it directs the multiplexer of the ALU output to 
*               which operation output this instruction may need 
*               (+,-,...etc.)
* 
* Change history: 01/01/17 – Did something
*                 10/29/17 – Did something else
*
**********************************************************************/
`timescale 1ns/1ns
`include "defines.v"

module ALU_Control (
    input [4:0] OpCode, 
    input [14:12] Inst, 
    input Inst30, 
    output reg [3:0] ALU_Sel
    );
    always @(*) begin
        case (OpCode)
            `OPCODE_Arith_R     :       ALU_Sel = {Inst[14:12], Inst30};
            `OPCODE_Arith_I     :       if(Inst[14:12] == `F3_SRL)
                                            ALU_Sel = {Inst[14:12], Inst30};
                                        else 
                                            ALU_Sel = {Inst[14:12], `ZEROs_1}; 
            `OPCODE_Branch      :       ALU_Sel = {`F3_ADD, `ONEs_1};              
            `OPCODE_LUI         :       ALU_Sel = `ALU_PASS;
            default             :       ALU_Sel = `DEFAULT_OP;
        endcase
    end
endmodule






