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
        // input
        input clk, reset,
        input PCEN,

        input [31:0] a_NPC,
        
        // output
        output [31:0] a_PC_I
    );

    PC  u_PC (
        .clk(clk), .reset(reset),

        .PCEN(PCEN),
        .a_NPC(a_NPC),
        .a_PC_I(a_PC_I)
    );
endmodule
