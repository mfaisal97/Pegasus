// file: Memory.v
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

module Memory(
    input clk,
    input slow_signal,
    input [31:0] address,
    input [31:0] data,
    input memread,
    input memwrite,
    input [2:0] funct3,
    output [31:0] dataout,
    output reg [31:0] testingRead
    );
    
    reg a1, a0;
    //reg [31:0] testingRead [0:4];
    
    always@(posedge clk) begin
        a1 <= address[1];
        a0 <= address[0];
    end
    
    wire lw, lh ,lhu, lb , lbu , sw, sh ,sb;
    
    assign lw = funct3[1] & memread | slow_signal;
    assign lh = ~slow_signal&(funct3[0]&memread&~funct3[2]);
    assign lhu= ~slow_signal&(funct3[0]&memread&funct3[2]);
    assign lb = ~slow_signal&(memread&~funct3[0]&~funct3[1]&~funct3[2]);
    assign lbu= ~slow_signal&(memread&~funct3[0]&~funct3[1]&funct3[2]);
    assign sh = slow_signal&(funct3[0]&memwrite);
    assign sw = slow_signal&(funct3[1] & memwrite);
    assign sb = slow_signal&(memwrite&~funct3[0]&~funct3[1]);
    

    wire [31:0] bankout;             //output of banks concatenation
    wire [3:0] bankwritereadbar;     //writereadbar signals for each bank
    wire [7:0] bank0datain;          //data that is input to banks
    wire [7:0] bank1datain;         
    wire [7:0] bank2datain;
    wire [7:0] bank3datain;

    MemControl MC(.address({address[31:2],a1,a0}),.data(data),
    .lw(lw),.lh(lh),.lhu(lhu),.lb(lb),.lbu(lbu),
    .sw(sw),.sh(sh),.sb(sb),.bankdata0(bankout[7:0]),
    .bankdata1(bankout[15:8]),.bankdata2(bankout[23:16]),
    .bankdata3(bankout[31:24]),.bankwritereadbar(bankwritereadbar),
    .savedata0(bank0datain),.savedata1(bank1datain),
    .savedata2(bank2datain),.savedata3(bank3datain),
    .dataout(dataout));

    MemBank Bank0(.clk(clk),.address(address[31:2]), 
                .datain(bank0datain), 
                .writereadbar(bankwritereadbar[0]),.dataout(bankout[7:0]));    
    MemBank Bank1(.clk(clk),.address(address[31:2]),
                .datain(bank1datain), 
                .writereadbar(bankwritereadbar[1]),.dataout(bankout[15:8]));        
    MemBank Bank2(.clk(clk),.address(address[31:2]),
                .datain(bank2datain), 
                .writereadbar(bankwritereadbar[2]),.dataout(bankout[23:16]));  
    MemBank Bank3(.clk(clk),.address(address[31:2]),
                .datain(bank3datain), 
                .writereadbar(bankwritereadbar[3]),.dataout(bankout[31:24]));  
    reg [31:0] memt [0:127];
    integer i;

 /*
    initial 
        begin
            $readmemh("C:/Users/mfaisal/Pegasus/Resources/test1.txt", memt); //<-- why does cloudv save it as txt??
            for(i=0;i<128;i = i+1) begin
                Bank0.mem[i] = memt[i][31:24];
                Bank1.mem[i] = memt[i][23:16];
                Bank2.mem[i] = memt[i][15:8];
                Bank3.mem[i] = memt[i][7:0];
            end
            testingRead = memt[0];
   //         testingRead[1] = memt[4];
     //       testingRead[2] = memt[8];
       //     testingRead[3] = memt[12];
        end
  */
  initial  
        begin
            $readmemh("C:/Users/ahmed.leithym/Downloads/Project2-11/Pegasus/Resources/test1.txt", memt);
            for(i=0;i<128;i = i+1) begin
                Bank0.mem[i] = memt[i][31:24];
                Bank1.mem[i] = memt[i][23:16];
                Bank2.mem[i] = memt[i][15:8];
                Bank3.mem[i] = memt[i][7:0];
            end     
       end
         
         /*   
            Bank0.mem[0] = 8'h93;
            Bank1.mem[0] = 8'h00;
            Bank2.mem[0] = 8'h70;
            Bank3.mem[0] = 8'h00;
            
            Bank0.mem[1] = 8'h13;
            Bank1.mem[1] = 8'h01;
            Bank2.mem[1] = 8'h80;
            Bank3.mem[1] = 8'h00;
            
            Bank0.mem[2] = 8'h93;
            Bank1.mem[2] = 8'h01;
            Bank2.mem[2] = 8'h90;
            Bank3.mem[2] = 8'h00;
        
        end
*/
endmodule
