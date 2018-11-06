// file: tb_RegisterFile.v
// author: @mfaisal
/*
`include "defines.v"

`timescale  1ns / 1ps

module RegisterFile_tb;

// RegisterFile Parameters
parameter PERIOD  = 10;

// RegisterFile Inputs
reg   clk = 0 ;
reg   rst  = 0 ;
reg   reg_write = 0 ;
reg   [`Data_SIZE] write_data = 0;
reg   [`ADDRESS_SIZE] port_one_address = 0;
reg   [`ADDRESS_SIZE] port_two_address = 0;

// RegisterFile Outputs
wire [`Data_SIZE] port_one_data;
wire [`Data_SIZE] port_two_data;

initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(1) rst  =  1;
    #(2) rst  =  0;
end

RegisterFile  u_RegisterFile (
    .clk (clk),
    .rst (rst),
    .reg_write (reg_write),
    .write_data (write_data),
    .port_one_address (port_one_address),
    .port_two_address (port_two_address),
    .port_one_data (port_one_data),
    .port_two_data (port_two_data)
);

initial
begin
    #(PERIOD / 2)         ;
    #PERIOD             reg_write = 1;
    #PERIOD             write_data = 5;
    #PERIOD             reg_write = 0;
                        write_data = 7;
    #PERIOD             port_one_address = 1;
                        reg_write = 0;
    #PERIOD             reg_write = 1;

    $finish;
end

endmodule*/
