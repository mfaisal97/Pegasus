// file: CompressedInstExtender.v
// author: @mfaisal

//To Do List:
//Nop Instruction
//add always @* block
//implement fld?
//implement flw?
//jal immediate?
//lui not valid when imm==0,sign extention ? currently no
//ebreak implementation?
//defines should be moved


`timescale 1ns / 1ps
`include "defines.v"


module CompressedInstExtender(
    input[`COMPRESSED_INST_SIZE] compressed_inst,
    output reg [`EXTENDED_INST_SIZE] extended_inst,
    output not_compressed
    );
    
    assign not_compressed = compressed_inst[0] & compressed_inst[1];

always @(*) begin
    case (compressed_inst[`COMPRESSED_ADDRESS_QUADRANT])
        `COMPRESSED_QUADRANT_0: begin
            case(compressed_inst[`COMPRESSED_ADDRESS_FUNC3])
                `COMPRESSED_FUNC3_ADDI4SPN:         extended_inst = {2'b0, compressed_inst[10:7], compressed_inst[12:11], compressed_inst[5], compressed_inst[6], 2'b0, `COMPRESSED_ADDR_TWO, `F3_ADD, `COMPRESSED_ADDR_EXTENSION, compressed_inst[`COMPRESSED_ADDRESS_RD_REDUCED], `OPCODE_Arith_I, `NOT_COMPRESSED};
                //`COMPRESSED_FUNC3_FLD:              extended_inst = {}
                `COMPRESSED_FUNC3_LW:               extended_inst = {5'b0, compressed_inst[5], compressed_inst[12:10], compressed_inst[6], `COMPRESSED_ADDR_EXTENSION, compressed_inst[`COMPRESSED_ADDRESS_RS1_REDUCED], `F3_LW, `COMPRESSED_ADDR_EXTENSION, compressed_inst[`COMPRESSED_ADDRESS_RD_REDUCED], `OPCODE_Load, `NOT_COMPRESSED};
                //`COMPRESSED_FUNC3_FLW:
                //`COMPRESSED_FUNC3_FSD:
                `COMPRESSED_FUNC3_SW:               extended_inst = {5'b0, compressed_inst[5], compressed_inst[12], `COMPRESSED_ADDR_EXTENSION, compressed_inst[`COMPRESSED_ADDRESS_RS2_REDUCED], `COMPRESSED_ADDR_EXTENSION, compressed_inst[`COMPRESSED_ADDRESS_RS1_REDUCED], `F3_SW, compressed_inst[11:10], compressed_inst[6], 2'b0, `OPCODE_Store, `NOT_COMPRESSED};
                //`COMPRESSED_FUNC3_FSW:
                default:                            extended_inst = `NOP_INSTRUCTION;
            endcase
        end

        `COMPRESSED_QUADRANT_1: begin
            case(compressed_inst[`COMPRESSED_ADDRESS_FUNC3])
                `COMPRESSED_FUNC3_ADDI:             extended_inst = {{7{compressed_inst[12]}}, compressed_inst[6:2], compressed_inst[`COMPRESSED_ADDRESS_RS1_RD], `F3_ADD, compressed_inst[`COMPRESSED_ADDRESS_RS1_RD], `OPCODE_Arith_I, `NOT_COMPRESSED };
                `COMPRESSED_FUNC3_JAL:              extended_inst = {compressed_inst[12], compressed_inst[8] , compressed_inst[10:9] , compressed_inst[6] , compressed_inst[7] , compressed_inst[2] , compressed_inst[11] ,compressed_inst[5:3], {9{compressed_inst[12]}}, `COMPRESSED_ADDR_ONE, `OPCODE_JAL, `NOT_COMPRESSED};
                `COMPRESSED_FUNC3_LI:               extended_inst = {{7{compressed_inst[12]}}, compressed_inst[6:2], `COMPRESSED_ADDR_ZERO, `F3_ADD, compressed_inst[`COMPRESSED_ADDRESS_RD], `OPCODE_Arith_I, `NOT_COMPRESSED };
                `COMPRESSED_FUNC3_ADD16SP_LUI:      begin
                    case(compressed_inst[`COMPRESSED_ADDRESS_RD])
                        `COMPRESSED_ADDR_TWO :      extended_inst = {{3{compressed_inst[12]}}, compressed_inst[4:3], compressed_inst[5], compressed_inst[2], compressed_inst[6], 4'b0, `COMPRESSED_ADDR_TWO, `F3_ADD, `COMPRESSED_ADDR_TWO, `OPCODE_Arith_I, `NOT_COMPRESSED};
                        `COMPRESSED_ADDR_ZERO:      extended_inst = `NOP_INSTRUCTION;
                        default:                    extended_inst = {{15{compressed_inst[12]}}, compressed_inst[6:2], compressed_inst[`COMPRESSED_ADDRESS_RD], `OPCODE_LUI, `NOT_COMPRESSED};
                    endcase
                end
                `COMPRESSED_FUNC3_SR_ALU:   begin
                    case(compressed_inst[`COMPRESSED_ADDRESS_FUNC_11_10])
                        `COMPRESSED_FUNC_10_11_SRLI_64:         extended_inst = {`SRLI_CODE, compressed_inst[12], compressed_inst[6:2], `COMPRESSED_ADDR_EXTENSION, compressed_inst[`COMPRESSED_ADDRESS_RS1_RD_REDUCED], `F3_SRL, `COMPRESSED_ADDR_EXTENSION, compressed_inst[`COMPRESSED_ADDRESS_RS1_RD_REDUCED], `OPCODE_Arith_I, `NOT_COMPRESSED};
                        `COMPRESSED_FUNC_10_11_SRAI_64:         extended_inst = {`SRAI_CODE, compressed_inst[12], compressed_inst[6:2], `COMPRESSED_ADDR_EXTENSION, compressed_inst[`COMPRESSED_ADDRESS_RS1_RD_REDUCED], `F3_SRL, `COMPRESSED_ADDR_EXTENSION, compressed_inst[`COMPRESSED_ADDRESS_RS1_RD_REDUCED], `OPCODE_Arith_I, `NOT_COMPRESSED};
                        `COMPRESSED_FUNC_10_11_ANDI:            extended_inst = {{8{compressed_inst[12]}}, compressed_inst[6:2], `COMPRESSED_ADDR_EXTENSION, compressed_inst[`COMPRESSED_ADDRESS_RS1_RD_REDUCED], `F3_AND, `COMPRESSED_ADDR_EXTENSION, compressed_inst[`COMPRESSED_ADDRESS_RS1_RD_REDUCED], `OPCODE_Arith_I, `NOT_COMPRESSED};
                        `COMPRESSED_FUNC_10_11_ALU: begin
                            case(compressed_inst[`COMPRESSED_ADDRESS_FUNC_6_5])
                                `COMPRESSED_FUNC_5_6_SUB:       extended_inst = {`SUB_CODE, `COMPRESSED_ADDR_EXTENSION, compressed_inst[`COMPRESSED_ADDRESS_RS2_REDUCED], `COMPRESSED_ADDR_EXTENSION, compressed_inst[`COMPRESSED_ADDRESS_RS1_RD_REDUCED],`F3_ADD, `COMPRESSED_ADDR_EXTENSION, compressed_inst[`COMPRESSED_ADDRESS_RS1_RD_REDUCED], `OPCODE_Arith_R, `NOT_COMPRESSED};
                                `COMPRESSED_FUNC_5_6_XOR:       extended_inst = {`XOR_CODE, `COMPRESSED_ADDR_EXTENSION, compressed_inst[`COMPRESSED_ADDRESS_RS2_REDUCED], `COMPRESSED_ADDR_EXTENSION, compressed_inst[`COMPRESSED_ADDRESS_RS1_RD_REDUCED], `F3_XOR, `COMPRESSED_ADDR_EXTENSION, compressed_inst[`COMPRESSED_ADDRESS_RS1_RD_REDUCED], `OPCODE_Arith_R, `NOT_COMPRESSED};
                                `COMPRESSED_FUNC_5_6_OR:        extended_inst = {`OR_CODE, `COMPRESSED_ADDR_EXTENSION, compressed_inst[`COMPRESSED_ADDRESS_RS2_REDUCED], `COMPRESSED_ADDR_EXTENSION, compressed_inst[`COMPRESSED_ADDRESS_RS1_RD_REDUCED], `F3_OR, `COMPRESSED_ADDR_EXTENSION, compressed_inst[`COMPRESSED_ADDRESS_RS1_RD_REDUCED], `OPCODE_Arith_R, `NOT_COMPRESSED};
                                `COMPRESSED_FUNC_5_6_AND:       extended_inst = {`AND_CODE, `COMPRESSED_ADDR_EXTENSION, compressed_inst[`COMPRESSED_ADDRESS_RS2_REDUCED], `COMPRESSED_ADDR_EXTENSION, compressed_inst[`COMPRESSED_ADDRESS_RS1_RD_REDUCED], `F3_AND, `COMPRESSED_ADDR_EXTENSION, compressed_inst[`COMPRESSED_ADDRESS_RS1_RD_REDUCED], `OPCODE_Arith_R, `NOT_COMPRESSED};
                                default:                        extended_inst = `NOP_INSTRUCTION;
                            endcase
                        end
                        default:                                extended_inst = `NOP_INSTRUCTION;
                    endcase
                end
                `COMPRESSED_FUNC3_J:                extended_inst = { compressed_inst[12], compressed_inst[8] , compressed_inst[10:9] , compressed_inst[6] , compressed_inst[7] , compressed_inst[2] , compressed_inst[11] ,compressed_inst[5:3], {9{compressed_inst[12]}}, `COMPRESSED_ADDR_ZERO, `OPCODE_JAL, `NOT_COMPRESSED};
                `COMPRESSED_FUNC3_BEQZ:             extended_inst = {3'b0, compressed_inst[12], compressed_inst[6:5], compressed_inst[2], `COMPRESSED_ADDR_EXTENSION, compressed_inst[`COMPRESSED_ADDRESS_RS1_REDUCED], `BR_BEQ , compressed_inst[11:10], compressed_inst[4:3], 1'b0, `OPCODE_Branch, `NOT_COMPRESSED};
                `COMPRESSED_FUNC3_BNEZ:             extended_inst = {3'b0, compressed_inst[12], compressed_inst[6:5], compressed_inst[2], `COMPRESSED_ADDR_EXTENSION, compressed_inst[`COMPRESSED_ADDRESS_RS1_REDUCED],  `BR_BNE , compressed_inst[11:10], compressed_inst[4:3], 1'b0, `OPCODE_Branch, `NOT_COMPRESSED};
                default:                            extended_inst = `NOP_INSTRUCTION;
            endcase
        end

        `COMPRESSED_QUADRANT_2:     begin
            case(compressed_inst[`COMPRESSED_ADDRESS_FUNC3])
                `COMPRESSED_FUNC3_SLLI_SLLI64:                          extended_inst = {`SRLI_CODE, compressed_inst[12], compressed_inst[6:2], compressed_inst[`COMPRESSED_ADDRESS_RS1_RD], `F3_SLL, compressed_inst[`COMPRESSED_ADDRESS_RS1_RD], `OPCODE_Arith_I, `NOT_COMPRESSED};
                //`COMPRESSED_FUNC3_FLDSP:                                extended_inst = {`SRLI_CODE, compressed_inst[12], compressed_inst[6:2], compressed_inst[`COMPRESSED_ADDRESS_RS1_RD], `F3_SLL, compressed_inst[`COMPRESSED_ADDRESS_RS1_RD], `OPCODE_Arith_I, `NOT_COMPRESSED};
                `COMPRESSED_FUNC3_LWSP:                                 extended_inst = {4'b0, compressed_inst[3:2], compressed_inst[12], compressed_inst[6:4], `COMPRESSED_ADDR_TWO, `F3_LW, compressed_inst[`COMPRESSED_ADDRESS_RD], `OPCODE_Load, `NOT_COMPRESSED};
                //`COMPRESSED_FUNC3_FLWSP:
                `COMPRESSED_FUNC3_____: begin
                    case(compressed_inst[`COMPRESSED_ADDRESS_FUNC_12])
                        `COMPRESSED_FUNC12_JR_: begin
                            case(compressed_inst[`COMPRESSED_ADDRESS_RS2])
                                `COMPRESSED_ADDR_ZERO:                  extended_inst = {12'b0, compressed_inst[`COMPRESSED_ADDRESS_RS1], `F3_JALR, `COMPRESSED_ADDR_ZERO, `OPCODE_JALR, `NOT_COMPRESSED};  //jr
                                default:                                extended_inst = {`ADD_CODE, compressed_inst[`COMPRESSED_ADDRESS_RS2], `COMPRESSED_ADDR_ZERO, `F3_ADD, compressed_inst[`COMPRESSED_ADDRESS_RS1_RD], `OPCODE_Arith_R, `NOT_COMPRESSED}; //MV
                            endcase
                        end
                        `COMPRESSED_FUNC12____: begin
                            case(compressed_inst[`COMPRESSED_ADDRESS_RS2])
                                `COMPRESSED_ADDR_ZERO:  begin
                                    case(compressed_inst[`COMPRESSED_ADDRESS_RS1])
                                        `COMPRESSED_ADDR_ZERO:          extended_inst = {`CSR_ADDR_ONE, `COMPRESSED_ADDR_ZERO, `F3_CSR_ALL_BIT, `COMPRESSED_ADDR_ZERO, `OPCODE_SYSTEM, `NOT_COMPRESSED}; //EBREAK
                                        default:                        extended_inst = {12'b0, compressed_inst[`COMPRESSED_ADDRESS_RS1], `F3_JALR, `COMPRESSED_ADDR_ONE, `OPCODE_JALR, `NOT_COMPRESSED};  //jalr
                                    endcase
                                end
                                default:                                extended_inst = {`ADD_CODE, compressed_inst[`COMPRESSED_ADDRESS_RS2], compressed_inst[`COMPRESSED_ADDRESS_RS1_RD], `F3_ADD, compressed_inst[`COMPRESSED_ADDRESS_RS1_RD], `OPCODE_Arith_R, `NOT_COMPRESSED};
                            endcase
                        end
                        default:                                        extended_inst = `NOP_INSTRUCTION;
                    endcase
                end
                //`COMPRESSED_FUNC3_FSDSP:              
                `COMPRESSED_FUNC3_SWSP:                                 extended_inst = {5'b0, compressed_inst[5], compressed_inst[12], `COMPRESSED_ADDR_TWO, `COMPRESSED_ADDR_EXTENSION, compressed_inst[`COMPRESSED_ADDRESS_RS1_REDUCED], `F3_SW, compressed_inst[11:10], compressed_inst[6], 2'b0, `OPCODE_Store, `NOT_COMPRESSED};
                //`COMPRESSED_FUNC3_FSWSP:
                default:                                                extended_inst = `NOP_INSTRUCTION;
            endcase
        end

        `NOT_COMPRESSED:                                                extended_inst = compressed_inst;
        default:                                                        extended_inst = `NOP_INSTRUCTION;
    endcase

end

endmodule
