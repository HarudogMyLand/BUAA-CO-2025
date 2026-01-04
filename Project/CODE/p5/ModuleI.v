`timescale 1ns / 1ps
`include "PC.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:03:58 11/12/2025 
// Design Name: 
// Module Name:    ModuleI 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ModuleI(
    input clk, reset, I_EN,
    input [31:0] v_NPC,

    output [31:0] v_PC_I, instrI
    );

    // PC <= NPC(D-Stage)

    PC u_pc(
        .clk(clk),
        .reset(reset),
        .EN(I_EN),

        .v_NPC(v_NPC),
        .v_PC_I(v_PC_I),
        .instrI(instrI)
    );


endmodule
