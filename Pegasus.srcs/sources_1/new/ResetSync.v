// file: ResetSync.v
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

module ResetSync(
    input clk,
    input inrst,
    output outrst
);

reg [1:0] registers;

always @(posedge clk)
    begin
        registers <= {registers[0],inrst}; 
    end

assign outrst = registers[1];
endmodule
