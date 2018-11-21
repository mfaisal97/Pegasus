// file: PC_Incrementor.v
// author: @melodyg
/*******************************************************************
*
* Module: PC_Incrementor.v
* Project: Pegasus
* Author: Arig Mostafa, areeg.mostafa@aucegypt.edu
* Description: This module increments the PC based on the instruction
*
* Change history: 05/11/18 – Module istantiation
*                 05/11/18 – Added the fact that if its an illegal
*                           instruction increment by 4 instead using ~|
*                 07/11/18 - Faisal changed the input from an instruction to a signal
**********************************************************************/

`timescale 1ns / 1ps
`include "defines.v"
module PC_Incrementor(
            input not_compressed, 
            input[`REGISTERS_RANGE] PC,
            output[`REGISTERS_RANGE] PC_Next
        );
 assign PC_Next = not_compressed ? PC + 4 : PC + 2;
endmodule

