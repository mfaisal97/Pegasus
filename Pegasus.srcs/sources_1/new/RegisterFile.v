// file: RegisterFile.v
// author: @mfaisal

`timescale 1ns / 1ps
`include "defines.v"

module RegisterFile(
    input clk,
    input rst,
    input reg_write,
    input [`Data_SIZE] write_data,
    input [`ADDRESS_SIZE] port_one_address,
    input [`ADDRESS_SIZE] port_two_address,
    output [`Data_SIZE] port_one_data,
    output [`Data_SIZE] port_two_data
    );

wire [`RREGISTERS_RANGE] registers_enablers;
wire [`Data_SIZE] data [`RREGISTERS_RANGE];

assign registers_enablers = reg_write ? (`WRITE_FIRST << port_two_address) : `WRITE_NONE;
Register #(`THIRTY_TWO) r0(
                .clk(clk),
                .rst(rst),
                .load(`ONEs_1),
                .data_in(`ZEROs_32),
                .data_out(data[0])
                );
generate
genvar register_number; 
    for (register_number = `FIRST_REG_NUM; register_number <= `LAST_REG_NUM; register_number = register_number + 1)
        begin: RegisterNumber
            Register #(`THIRTY_TWO) register (
                .clk(clk),
                .rst(rst),
                .load(registers_enablers[register_number]),
                .data_in(write_data),
                .data_out(data[register_number])
                );
        end
endgenerate

assign port_one_data = data[port_one_address];
assign port_two_data = data[port_two_address];

endmodule
