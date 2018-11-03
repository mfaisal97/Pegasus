// file: ForwardingUnit.v
// author: @melodyg
/*******************************************************************
*
* Module: module_name.v
* Project: Project_Name
* Author: name and email
* Description: put your description here
*
* Change history: 01/01/17 – Did something
* 10/29/17 – Did something else
*
**********************************************************************/
`timescale 1ns / 1ps
`include "defines.v"


module ForwardingUnit (
        input [6:2] opcode,
        input [4:0] rs1, 
        input [4:0] rs2, 
        input [4:0] rd, 
        input  reg_write, 
        output reg [0:0] forward_a, 
        output reg [0:0] forward_b,  
        output reg [0:0] forward_store
        );
    always @(*) begin
        case(opcode)
            `OPCODE_Branch,
            `OPCODE_Arith_R     :       begin
                                            forward_a = (rs1 == rd) & reg_write & (rd != `ZERO_REGISTER);
                                            forward_b = (rs2 == rd) & reg_write & (rd != `ZERO_REGISTER);
                                            forward_store = `NO_FORWARD;
                                        end 
            `OPCODE_Arith_I,
            `OPCODE_JALR,
            `OPCODE_Load        :       begin 
                                            forward_a = (rs1 == rd) & reg_write & (rd != `ZERO_REGISTER);
                                            forward_b = `NO_FORWARD;
                                            forward_store = `NO_FORWARD;
                                        end
            `OPCODE_Store       :       begin
                                            forward_a = (rs1 == rd) & reg_write & (rd != `ZERO_REGISTER);
                                            forward_b = `NO_FORWARD;
                                            forward_store = (rs2 == rd) & reg_write & (rd != `ZERO_REGISTER);
                                        end
            default             :       begin
                                            forward_a = `NO_FORWARD;
                                            forward_b = `NO_FORWARD;
                                            forward_store = `NO_FORWARD;
                                        end
        endcase
    end
endmodule
