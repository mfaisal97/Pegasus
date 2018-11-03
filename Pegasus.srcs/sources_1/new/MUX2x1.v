// file: MUX2x1.v
// author: @ahmedleithy
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
