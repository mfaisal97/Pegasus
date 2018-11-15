// file: MemBank.v
// author: @ahmedleithy
/*******************************************************************
*
* Module: MemBank.v
* Project: Pegasus
* Author: Ahmed Leithy - Ahmed.leithym@aucegypt.edu
* Description: This module functions as a single memory bank.
*
* Change history: 
* 26/10/18 – Memory Bank was initialized
*
**********************************************************************/
`include "defines.v"

`timescale 1ns/1ns

module MemBank(
    input clk, 
    input [29:0] address,
    input [7:0] datain,    
    input writereadbar,
    output reg [7:0] dataout
    );
    
    reg [7:0] mem [`MEM_Bank_Range];
    
    always @(posedge clk) begin
        if (writereadbar)
            mem[address] <= datain;
        else 
            dataout <= mem[address];
    end
    
   // assign dataout = !writereadbar ? mem[address] : `ZERO;
    
endmodule





