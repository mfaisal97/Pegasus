// file: PIC.v
// author: @melodyg

`timescale 1ns/1ns

module PIC (
        input [7:0] interrupts,
        output status,
        output reg [2:0] interrupt_index
        );
    always @(*) begin
        if(interrupts[0])
            interrupt_index = 3'd0;
        else if(interrupts[1])
            interrupt_index = 3'd1;
        else if(interrupts[2])
            interrupt_index = 3'd2;
        else if(interrupts[3]) 
            interrupt_index = 3'd3;
        else if(interrupts[4]) 
            interrupt_index = 3'd4;
        else if(interrupts[5]) 
            interrupt_index = 3'd5;
        else if(interrupts[6])
            interrupt_index = 3'd6;
        else
            interrupt_index = 3'd7;
    end
    assign status = |interrupts;
endmodule
