// file: MUX2x1.v
// author: @ahmedleithy

`timescale 1ns/1ns
`include "defines.v"

module MUX2x1 #(parameter BYTES = `THIRTY_TWO ) (
    input [BYTES-1:0] A, 
    input [BYTES-1:0] B,
    input sel, 
    output [BYTES-1:0] out
    );
    assign out = sel ? B : A;
endmodule
