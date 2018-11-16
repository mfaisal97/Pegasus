`timescale 1ns / 1ps
// file: CSR.v
// author: @ahmedleithy
/*******************************************************************
*
* Module: CSR.v
* Project: Pegasus
* Author: Ahmed Leithy - Ahmed.leithym@aucegypt.edu
* Description: This is the Module that interacts with the datapath and handles all csr operations internally.
*
* Change history: 
* 16/11/2018 - CSR was created
*
**********************************************************************/

`include "defines.v"
module CSR(
    input clk,
    input rst,
    input interrupt_indicator,
    input instruction_retired,
    input [31:0] PC,
    input [11:0] address,
    input [31:0] dataIn,
    input CSRwrite,
    output [31:0] CSRout,
    output [3:0] mieSignals,
    output timerInterrupt
    );
    

    wire [31:0] mcycleOut,mtimeOut, minstretOut;
    wire pulse;
    
    timer t(
            .clk(clk),
            .rst(rst),
            .pulse(pulse)
        );
        
    counter mcycle(
        .clk(clk),
        .rst(rst),
        .en(`ONE_ONE_BIT),
        .count(mcycleOut)
     );
     
     counter mtime (
             .clk(clk),
             .rst(rst),
             .en(pulse),
             .count(mtimeOut)
          );
     
    counter minstret(
              .clk(clk),
              .rst(rst),
              .en(instruction_retired),
              .count(minstretOut)
           );     
     
    reg [31:0] mtimecmp;
    reg [31:0] mepc;
    reg [3:0] mie;
    reg [2:0] mip;
    assign mieSignals = mie;
    
    always@(posedge clk) begin
        if(rst)begin
            mtimecmp <= `ZERO;
            mepc <= `ZERO;
            mie <= `ZERO;
            mip <= `ZERO;
        end    
        else begin 
            if(CSRwrite)
                if(address==32'hb03)
                    mtimecmp <= dataIn;
                else if(address ==    
        end
    end
    
endmodule
