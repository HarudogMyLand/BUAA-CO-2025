`timescale 1ns / 1ps
`include "macros.v"
`include "GRF.v"
`include "CMP.v"
`include "Controller.v"
`include "NPC.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:52:56 11/12/2025 
// Design Name: 
// Module Name:    ModuleD 
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
module ModuleD(
    input clk, reset,

    // Input
    input [31:0] instr_D, a_PC_D, a_PC_I,

    // Forwarding data
    input [31:0] hv_fwd1_D, hv_fwd2_D,

    // Writing stage data
    input [31:0] v_WB_W, a_PC_W,
    input [4:0]  a_WB_W,

    // Output
    output [31:0] v_R1_D, v_R2_D,
    output [31:0] v_ext32,

    output [31:0] v_WB_D,
    output [4:0]  a_WB_D,

    output [31:0] a_NPC,

    output c_MD,
    // Hazard Control Unit
    output h_D1, h_D2
);

    wire [31:0] PC_D_NOP;
    
    wire [4:0] c_op, c_funct;

    wire c_eq, c_eqz, c_ltz;
    wire c_branch, c_j, c_jr;
    wire c_signExt;

    wire c_selWD;

    assign PC_D_NOP = a_PC_D + 32'h00008;
    assign c_op     = instr_D[`op];
    assign c_funct  = instr_D[`funct];

    assign v_WB_D   = (c_selWD) ? PC_D_NOP : 32'bz;

    assign v_ext32 = c_signExt ? {{16{instr_D[15]}}, instr_D[`imm16]} :
                                {{16'h0000}, instr_D[`imm16]};

    // Controller
    Controller  u_ctrl_I (
        .instr(instr_D),

        .c_branch(c_branch),
        .c_j(c_j),
        .c_jr(c_jr),

        .c_selWD_D(c_selWD),
        .a_WB_D(a_WB_D),

        .c_MD(c_MD),

        .c_eq(c_eq), 
        .c_ltz(c_ltz),
        .c_eqz(c_eqz),

        .c_signExt(c_signExt),

        .h_D1(h_D1),
        .h_D2(h_D2)
    );

    CMP         u_cmp(
        .in1(hv_fwd1_D),
        .in2(hv_fwd2_D),

        .eq(c_eq)
    );

    // NPC
    NPC         u_npc (
        .c_branch(c_branch),
        .c_j(c_j),
        .c_jr(c_jr),

        .PC(a_PC_D), .PC_I(a_PC_I),
        .imm26(instr_D[`imm26]),
        .v_Jump(hv_fwd1_D), .a_NPC(a_NPC)
    );

    GRF         u_grf (
        .clk(clk), .reset(reset),
        .PC(a_PC_W), 

        .R1(instr_D[`rs]),
        .R2(instr_D[`rt]),
        .R3(a_WB_W),

        .WD(v_WB_W),

        .DR1(v_R1_D),
        .DR2(v_R2_D)
    );
endmodule