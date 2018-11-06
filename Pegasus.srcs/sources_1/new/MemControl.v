// file: MemControl.v
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

module MemControl(
    input [31:0] address,
    input [31:0] data,
    input unalignedword,
    input lw,
    input lh,
    input lhu,
    input lb,
    input lbu,
    input sw,
    input sh,
    input sb,
    input [7:0] bankdata0,  //data that will be used in output in reading
    input [7:0] bankdata1,
    input [7:0] bankdata2,
    input [7:0] bankdata3,
    output [3:0] bankwritereadbar,
    output [7:0] savedata0, //data that will be saved into memory when storing
    output [7:0] savedata1,
    output [7:0] savedata2,
    output [7:0] savedata3,
    output [31:0] dataout
    );

    wire signex;
    
    //sign bit for lb
    assign signex = address[1]&address[0] ? bankdata3[7] : 
                    address[1]&~address[0] ? bankdata2[7]:
                    ~address[1]&address[0] ? bankdata1[7]: bankdata0[7];
                    
                    
    //write/read' signals for each bank                    
    assign bankwritereadbar[0]=sw|(sh&~address[1])|
                                (sb&~address[1]&~address[0]);
    assign bankwritereadbar[1]=sw|(sh&~address[1])|(sb&~address[1]&address[0]);
    assign bankwritereadbar[2]=sw|(sh&address[1])|(sb&address[1]&~address[0]);
    assign bankwritereadbar[3]=sw|(sh&address[1])|(sb&address[1]&address[0]);

    //data to be saved in each bank in case of storing
    assign savedata0 = data[7:0];
    assign savedata1 =  (sb&address[0]&~address[1]) ? data[7:0] : data[15:8];
    assign savedata2 = sw ? data[23:16] : data[7:0];
    assign savedata3 = sw ? data[31:24] : (sh&address[1])?data[15:8]:data[7:0];


    //32 bit data out from memory based on load instruction
    assign dataout[7:0]= unalignedword ? bankdata2 : (lw | ((lh|lhu)&~address[1]) |     
                        ((lb|lbu)&~address[1]&~address[0])) ? bankdata0 : 
                        ((lb|lbu)&(~address[1]&address[0])) ? bankdata1 :
                        ((lb|lbu)&address[1]&address[0]) ? bankdata3 :
                        bankdata2;

    assign dataout[15:8]= unalignedword ? bankdata3 : lb ? {`EIGHT{signex}}: lbu ? `ZERO : (lh|lhu)&address[1] 
                        ? bankdata3 : bankdata1;  
    assign dataout[23:16]= unalignedword ? bankdata0 : lw ? bankdata2 : lb ? {`EIGHT{signex}}: (lh&~address[1]) ? 
                        {`EIGHT{bankdata1[7]}}: lh&address[1] ? {`EIGHT{bankdata3[7]}} : 
                        `ZERO;
    assign dataout[31:24] = unalignedword ? bankdata1 :lw ? bankdata3 : lb ? {`EIGHT{signex}}: (lh&~address[1]) ? 
                        {`EIGHT{bankdata1[7]}}: lh&address[1] ? {`EIGHT{bankdata3[7]}}: 
                        `ZERO;

endmodule
