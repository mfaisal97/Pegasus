// file: ResetSync.v
// author: @ahmedleithy

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
