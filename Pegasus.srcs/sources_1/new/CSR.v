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
`define     MCYCLE    32'hb00
`define     MTIME    32'hb01
`define     MINSTRET    32'hb02
`define     MTIMECMP    32'hb03
`define     MEPC    32'h341
`define     MIE    32'h304
`define     MIP    32'h344

module CSR(
    input clk,
    input rst,
    input timerSolved,
    input interrupt_indicator,
    input instruction_retired,
    input [31:0] PC,
    input [11:0] address,
    input [31:0] dataIn,
    input [2:0] mipInput,
    input CSRwrite,
    output [31:0] CSRout,
    output [3:0] mieSignals,
    output timerInterrupt,
    output [31:0] mepcout 
    );
    

    wire [31:0] mcycleOut,mtimeOut, minstretOut;
    wire pulse;
    wire timerrst;
    
    assign timerrst = timerSolved | rst;
    
    timer t(
            .clk(clk),
            .rst(timerrst),
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
             .rst(timerrst),
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
    assign mepcout = mepc;

    //assign mepc = interrupt_indicator ? PC : ((address==`MEPC)&CSRwrite) ? dataIn : mepc;
    
    assign timerInterrupt = (mtimeOut >= mtimecmp && mtimeOut!=0);
    
    always@(posedge clk) begin
        if(rst)begin
            mtimecmp <= `ZERO;
            mepc <= `ZERO;
            mie <= `ZERO;
            mip <= `ZERO;
        end    
        else begin 
            mip <= mipInput;
            
            if(interrupt_indicator)
                mepc <=PC;
            else if((address==`MEPC)&&CSRwrite)
                mepc <= dataIn;
            else 
                mepc<= mepc;
         
                
            
            if(CSRwrite)
                if(address== `MTIMECMP)
                    mtimecmp <= dataIn;
                else if(address == `MIE)
                    mie <= dataIn[3:0]; 
               // else if (address == `MIP)
                 //   mip <= dataIn[2:0];   
                else
                    mie <=mie;  
        end
    end
    
    assign CSRout = (address == `MCYCLE) ? mcycleOut :
                (address == `MTIME) ? mtimeOut  :
                (address == `MTIMECMP) ? mtimecmp  :
                (address == `MINSTRET) ? mcycleOut  :
                (address == `MEPC) ? mepc:
                (address == `MIE) ? {{28{`ZERO_ONE_BIT}} ,mie}: 
                (address == `MIP)? {{29{`ZERO_ONE_BIT}} ,mip}:`ZERO;
endmodule
