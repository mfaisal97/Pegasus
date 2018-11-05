`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/04/2018 07:43:20 PM
// Design Name: 
// Module Name: InstructionRegister
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


module InstructionRegister(input clk, input rst, input[31:0] word, input load, output reg [31:0] inst, output reg compressed, output reg stall, output reg DontLoad);
    reg [47:0] IR;
    reg [1:0] counter;
    always @(posedge clk) begin
        if(rst) begin
            inst = 32'd0;
            compressed = 1'b0;
            counter = 2'b00;
            IR = 48'd0;
            DontLoad = 0;
            stall = 0;
        end
        else begin
           if(load) begin
              if(~|IR[15:0]) 
                    IR[31:0] = word;
              else  
                    IR[47:16] = word;
              counter = 0;                     
           end
           else begin
                compressed = ~(IR[1]&IR[0]);
                inst = compressed? {16'd0,IR[15:0]}: IR[31:0];
                IR = compressed? {16'd0, IR[16:47]}: {32'd0, IR[31:47]};///not sure
                counter = compressed? counter + compressed : 2'd2;
                stall = counter == 2'b01 && ~(IR[16]&IR[17]);
                DontLoad = counter != 2'd2 && (~|IR[16:47] && counter != 2'd1);
           end  
        end
    end
endmodule
