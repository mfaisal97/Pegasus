// file: BranchControlUnit.v
// author: @mfaisal
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

module BranchControlUnit(
    input branch,
    input ssignal,
    input unconditionalbranch,
    input [`IR_funct3] func3,
    input zeroflag,
    input cout,
    input signbit,
    input overflow,
    output reg takebranch
);

always @(*) begin
  //  if (ssignal) begin
        if(branch) begin
            case (func3)
                `BR_BEQ     :   takebranch = zeroflag;
                `BR_BNE     :   takebranch = ~ zeroflag;
                `BR_BLT     :   takebranch = (signbit != overflow);
                `BR_BGE     :   takebranch = (signbit == overflow);
                `BR_BLTU    :   takebranch = ~ cout;
                `BR_BGEU    :   takebranch = cout;
                default     :   takebranch = `BRANCHFALSE;
            endcase
    
        end
    
        else if (unconditionalbranch)
                 takebranch = `BRANCHTRUE;
        else takebranch = `BRANCHFALSE;

 //   end
   // else 
   //     takebranch = `BRANCHFALSE;
end

endmodule
