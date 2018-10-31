// file: Register.v
// author: @mfaisal

`timescale 1ns / 1ps
`include "defines.v"


module Register #(parameter size = `DATA_PARAMTER_SIZE)(
    input clk,
    input rst,
    input load,
    input  [size - 1 : `PARAMTER_SIZE_Zero ] data_in,
    output reg [size - 1 : `PARAMTER_SIZE_Zero ] data_out
    );
    always @(posedge clk or posedge rst)
    begin 
        if(rst)
            data_out <= `RESET_DATA;
        else if (load)
            data_out <= data_in;
        else 
            data_out <= data_out;
    end
endmodule
