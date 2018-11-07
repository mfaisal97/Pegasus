
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
            input not_compressed, 
            input[31:0] PC,
            output[31:0] PC_Next
        );

 assign PC_Next = not_compressed ? PC + 4 : PC + 2;

endmodule