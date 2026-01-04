`timescale 1ns / 1ps
`include "DM.v"
// `include "Controller.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:48:08 11/13/2025 
// Design Name: 
// Module Name:    ModuleM 
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
module ModuleM(
        input           clk, reset,
        input [31:0]    PC_M, instrM,
        input [4:0]     a_R3_M,
        input [31:0]    v_R3_M,

        input  [31:0]   ALUout_M,
        input [31:0]    fwdM2,
        output [4:0]    a_R3_MW, 
        output [31:0]   v_R3_MW
    );

    wire WE, WD_sel_M;
    wire [31:0] v_RD_M;

    Controller u_ctrl_M(
        .instr(instrM),
        .WE_mem(WE),
        // .width(),
        // .loadSign()
        .WD_sel_M(WD_sel_M)
    );

    DM  u_dm (
        .clk(clk), .reset(reset),

        .WE(WE),
        // .width(),
        // .loadSign()
        .addr(ALUout_M),
        .WD(fwdM2),

        .RD(v_RD_M),
        .PC(PC_M)
    );

    assign a_R3_MW = a_R3_M;
    assign v_R3_MW = (WD_sel_M == 0) ? v_R3_M : v_RD_M;
endmodule
