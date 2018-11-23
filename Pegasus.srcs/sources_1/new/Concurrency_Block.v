// file: Concurrency_Block.v
// author: @melodyg
`include "defines.v"
`timescale 1ns/1ns

module Concurrency_Block( 
    input NMI, //0x10
    input ECALL, //0x20
    input EBREAK, //0x30
    input TMR, //0x40
    input INT, //0x100
    input [2:0] int_index,
    input [3:0] MIE_output,
    output interrupt_indicator,
    output reg [31:0] handler_location,
    output [2:0] MIP_input,
    output reg [4:0] all_interrupts // {NMI, EBREAK, TIMR, INT, ECALL}
    );
    wire enable_TMR;
    wire enable_INT;
    wire enable_ECALL;
    
    
    always @(*) begin
        if(NMI) begin
            handler_location = {20'd0, 12'h10};
            all_interrupts = {`ONE_ONE_BIT, {4{`ZERO_ONE_BIT}}};
            end
        else if (EBREAK)begin
            handler_location = {20'd0, 12'h30};
            all_interrupts = {`ZERO_ONE_BIT, `ONE_ONE_BIT, {3{`ZERO_ONE_BIT}}};
            end
        else if(TMR & enable_TMR)begin
            handler_location = {20'd0, 12'h40};
            all_interrupts = {{2{`ZERO_ONE_BIT}}, `ONE_ONE_BIT, {2{`ZERO_ONE_BIT}}};

            end
        else if(INT & enable_INT)begin
            handler_location = {20'd0, 12'h100} + (int_index << 4);
            all_interrupts = {{3{`ZERO_ONE_BIT}}, `ONE_ONE_BIT, {`ZERO_ONE_BIT}};

            end
        else if(ECALL & enable_ECALL)begin
            handler_location = {20'd0, 12'h20};
            all_interrupts = {{4{`ZERO_ONE_BIT}}, `ONE_ONE_BIT};
            end
        else begin
            handler_location = 32'd0;
            all_interrupts = {{5{`ZERO_ONE_BIT}}};
            end
    end
    /*assign enable_TMR = ~(MIE_output[0]|MIE_output[3]); 
    assign enable_INT = ~(MIE_output[1]|MIE_output[3]); 
    assign enable_ECALL = ~(MIE_output[2]|MIE_output[3]); */
    assign enable_TMR = (MIE_output[0]|MIE_output[3]); 
    assign enable_INT = (MIE_output[1]|MIE_output[3]); 
    assign enable_ECALL = (MIE_output[2]|MIE_output[3]);
    assign MIP_input = {ECALL&enable_ECALL, INT&enable_INT | NMI, TMR&enable_TMR};
    //assign interrupt_indicator = NMI | (ECALL&enable_ECALL) | EBREAK | (TMR&enable_TMR) | (INT&enable_INT);
    assign interrupt_indicator = NMI | (TMR&enable_TMR) | (INT&enable_INT);

endmodule

