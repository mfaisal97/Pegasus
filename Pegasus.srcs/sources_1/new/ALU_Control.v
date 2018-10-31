// file: ALU_Control.v
// author: @melodyg

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
            default             :       ALU_Sel = `DEFAULT_OP;
        endcase
    end
endmodule