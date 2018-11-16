// file: Pegasus.v
// author: @melodyg

`timescale 1ns/1ns

module Pegasus(
        input clk,
        input rst,
        input NMI,
        input [7:0] interrupts
        );
    wire status;
    wire [2:0] interrupt_index;
    PIC pic (
        .interrupts(interrupts),
        .status(status),
        .interrupt_index(interrupt_index)
        );
    Datapath dp (
        .clk(clk), 
        .rst(rst),
        .NMI(NMI),
        .status(status),
        .interrupt_index(interrupt_index)
        );
endmodule
