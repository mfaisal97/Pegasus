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
    input [`IR_opcode] OpCode, 
    input [`IR_funct3] Inst, 
    input Inst30,
    output reg [`ALUSEL_SIZE] ALU_Sel
    );
    always @(*) begin
        case (OpCode)
            `OPCODE_Arith_R     :       ALU_Sel = {Inst[`IR_funct3], Inst30};
            `OPCODE_Arith_I     :       if(Inst[`IR_funct3] == `F3_SRL)
                                            ALU_Sel = {Inst[`IR_funct3], Inst30};
                                        else 
                                            ALU_Sel = {Inst[`IR_funct3], `ZERO_1}; 
            `OPCODE_Branch      :       ALU_Sel = {`F3_ADD, `ONE_1};              
            `OPCODE_LUI         :       ALU_Sel = `ALU_PASS;
            `OPCODE_SYSTEM      :       begin
                case (Inst[`F3_LEAST_LOC])
                    `F3_LEAST_CSR_RS:       ALU_Sel = `ALU_OR;    
                    `F3_LEAST_CSR_RC:       ALU_Sel = `ALU_AND;
                    default         :       ALU_Sel = `DEFAULT_OP;
                endcase
                end
            default             :       ALU_Sel = `DEFAULT_OP;
        endcase
    end
endmodule






