// file: RegisterFile.v
// author: @mfaisal
/*******************************************************************
*
* Module: module_name.v
* Project: Project_Name
* Author: name and email
* Description: put your description here
*
* Change history: 01/01/17 â€“ Did something
* 10/29/17 â€“ Did something else
*
**********************************************************************/
`timescale 1ns / 1ps
`include "defines.v"

module RegisterFile(
    input clk,
    input rst,
    input reg_write,
    input [`DATA_SIZE] write_data,
    input [`ADDRESS_SIZE] port_one_address,
    input [`ADDRESS_SIZE] port_two_address,
    output [`DATA_SIZE] port_one_data,
    output [`DATA_SIZE] port_two_data
    );

    wire [`REGISTERS_RANGE] registers_enablers;
    wire [`DATA_SIZE] data [`REGISTERS_RANGE];

    assign registers_enablers = reg_write ? (`WRITE_FIRST << port_two_address) : `WRITE_NONE;
    Register #(`THIRTY_TWO) r0(
                .clk(clk),
                .rst(rst),
                .load(`ONE_1),
                .data_in(`ZERO_32),
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

