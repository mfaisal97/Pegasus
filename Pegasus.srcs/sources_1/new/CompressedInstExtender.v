// file: CompressedInstExtender.v
// author: @mfaisal

`timescale 1ns / 1ps

//PARTS LOCATIONS
`define     COMPRESSED_ADDRESS_RS1_RD                           11:7
`define     COMPRESSED_ADDRESS_RD                               11:7
`define     COMPRESSED_ADDRESS_RS1                              11:7
`define     COMPRESSED_ADDRESS_RS1_RD_REDUCED                   9:7
`define     COMPRESSED_ADDRESS_RS1_REDUCED                      9:7
`define     COMPRESSED_ADDRESS_RD_REDUCED                       4:2
`define     COMPRESSED_ADDRESS_RS2_REDUCED                      4:2
`define     COMPRESSED_ADDRESS_RS2                              6:2


//INSTRUCTIONS SIZES
`define     COMPRESSED_INST_SIZE                                15:0
`define     EXTENDED_INST_SIZE                                  31:0

`define     NOP_INSTRUCTION                                     32'b0

//ADDRESSES
`define     COMPRESSED_ADDR_ZERO                                5'b00
`define     COMPRESSED_ADDR_TWO                                 5'b10

//QUADRANTS
`define     COMPRESSED_QUADRANT_0                       2'b00
`define     COMPRESSED_QUADRANT_1                       2'b01
`define     COMPRESSED_QUADRANT_2                       2'b10
`define     NOT_COMPRESSED                              2'b11

//Function 3
//Quadrant one
`define     COMPRESSED_FUNC3_ADDI4SPN                            3'b000
`define     COMPRESSED_FUNC3_FLD                              3'b001
`define     COMPRESSED_FUNC3_LW                               3'b010
`define     COMPRESSED_FUNC3_FLW                              3'b101
`define     COMPRESSED_FUNC3_FSD                              3'b101
`define     COMPRESSED_FUNC3_SW                               3'b110
`define     COMPRESSED_FUNC3_FSW                              3'b111

//QUADRANT TWO
`define     COMPRESSED_FUNC3_ADDI                             3'b000
`define     COMPRESSED_FUNC3_JAL                              3'b001
`define     COMPRESSED_FUNC3_LI                               3'b010
`define     COMPRESSED_FUNC3_ADD16SP_LUI                      3'b011
`define     COMPRESSED_FUNC3_SR_ALU                           3'b100

//START:    FUNC10,11
`define     COMPRESSED_FUNC_10_11_SRLI_64                          2'b00
`define     COMPRESSED_FUNC_10_11_SRAI_64                          2'b01
`define     COMPRESSED_FUNC_10_11_ANDI                             2'b10

`define     COMPRESSED_FUNC_10_11_ALU                              2'b11
//FUNC5,6
`define     COMPRESSED_FUNC_5_6_SUB                              2'b00
`define     COMPRESSED_FUNC_5_6_XOR                              2'b01
`define     COMPRESSED_FUNC_5_6_OR                               2'b10
`define     COMPRESSED_FUNC_5_6_AND                              2'b11
//FUNC5,6
`define     COMPRESSED_FUNC12_ALU                           2'b
//END:      FUNC10,11

`define     COMPRESSED_FUNC3_J                                3'b101
`define     COMPRESSED_FUNC3_BEQZ                             3'b110
`define     COMPRESSED_FUNC3_BNEZ                             3'b111

//QUADRANT THREE
`define     COMPRESSED_FUNC3_SLLI_SLLI64                      3'b000
`define     COMPRESSED_FUNC3_FLDSP                            3'b001
`define     COMPRESSED_FUNC3_LWSP                             3'b010
`define     COMPRESSED_FUNC3_FLWSP                            3'b011
`define     COMPRESSED_FUNC3_____                             3'b100
`define     COMPRESSED_FUNC12_JR_                             1'b0
`define     COMPRESSED_FUNC12____                             1'b1
`define     COMPRESSED_FUNC3_FSDSP                            3'b101
`define     COMPRESSED_FUNC3_SWSP                             3'b110
`define     COMPRESSED_FUNC3_FSWSP                            3'b111


module CompressedInstExtender(
    input[`COMPRESSED_INST_SIZE] compressed_inst
    );
endmodule
