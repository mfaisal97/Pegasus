// file: CompressedInstExtender.v
// author: @mfaisal

`timescale 1ns / 1ps

`define     COMPRESSED_INST_SIZE        15:0
`define     EXTENDED_INST_SIZE          31:0
`define     COMPRESSED_QUADRANT_0                       2'b00
`define     COMPRESSED_QUADRANT_1                       2'b01
`define     COMPRESSED_QUADRANT_2                       2'b10
`define     COMPRESSED_NOP                              32'B0


//Function 3
`define     COMPRESSED_JAL                              3'b001
//`define     COMPRESSED_ADDIW                            


module CompressedInstExtender(
    input compressed_inst
    );
endmodule
