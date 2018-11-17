// file: Concurrency_Block.v
// author: @melodyg

`timescale 1ns/1ns

module Concurrency_Block(
    input NMI, //0x10
    input ECALL, //0x20
    input EBREAK, //0x30
    input TMR, //0x40
    input INT, //0x100
    input [3:0] MIE_output,
    output interrupt_indicator,
    output reg [31:0] handler_location,
    output [2:0] MIP_input
    );
    wire enable_TMR;
    wire enable_INT;
    wire enable_ECALL;
    always @(*) begin
        if(NMI) 
            handler_location = {20'd0, 12'h10};
        else if (EBREAK)
            handler_location = {20'd0, 12'h30};
        else if(TMR & enable_TMR)
            handler_location = {20'd0, 12'h40};
        else if(INT & enable_INT)
            handler_location = {20'd0, 12'h100};
        else if(ECALL & enable_ECALL)
            handler_location = {20'd0, 12'h20};
        else 
            handler_location = 32'd0;
    end
    assign enable_TMR = ~(MIE_output[0]|MIE_output[3]); 
    assign enable_INT = ~(MIE_output[1]|MIE_output[3]); 
    assign enable_ECALL = ~(MIE_output[2]|MIE_output[3]); 
    assign MIP_input = {ECALL&enable_ECALL, INT&enable_INT, TMR&enable_TMR};
    assign interrupt_indicator = NMI | (ECALL&enable_ECALL) | EBREAK | (TMR&enable_TMR) | (INT&enable_INT);
endmodule

