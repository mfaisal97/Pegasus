`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/06/2018 09:07:27 PM
// Design Name: 
// Module Name: PC_Incrementor
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module PC_Incrementor(
            input[31:0] Instruction, 
            input[31:0] PC,
            output[31:0] PC_Next
        );
 assign PC_Next = Instruction[0] & Instruction[1] ? PC + 4 : PC + 2;
endmodule
