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
        input           clk, reset,

        input [31:0]    instrD, v_PC_D, v_PC_I,

        // forwarding data
        input [31:0]    fwd1, fwd2,

        // writing reg data
        input [31:0]    v_WB_W, PC_W,
        input [4:0]     a_WB_W,

        // read out signals
        output [31:0]   v_R1_D, v_R2_D,
        output [31:0]   v_ext32,

        output [4:0]    a_WB_D,
        output [31:0]   v_WB_D,

        output [31:0]   NPC,

        // hazard control signals
        // output h_MD,
        output h_D1, h_D2
    );

    wire [31:0] PC_NOP_D;
    assign PC_NOP_D = v_PC_D + 8;

    // Module_D Control Unit
    wire [4:0] ctrl_op, ctrl_funct;

    assign ctrl_op      = instrD[`op];
    assign ctrl_funct   = instrD[`funct];

    wire ctrl_eq, ctrl_eqz, ctrl_ltz;
    wire ctrl_branch, ctrl_j, ctrl_jr;
    wire ctrl_s_ext;

    wire WD_S;

    assign v_WB_D = (WD_S == 1)? PC_NOP_D : 32'bz;

    // instance
    Controller u_ctrl_I(
        .instr(instrD),

        .branch(ctrl_branch),
        .J(ctrl_j), .JR(ctrl_jr),

        .v_WD_s_D(WD_S),
        .a_WD_s_D(a_WB_D),     // write address

        .eq(ctrl_eq),
        .ltz(ctrl_ltz),
        .eqz(ctrl_eqz),

        .c_sExt(ctrl_s_ext),
        .h_D1(h_D1),
        .h_D2(h_D2),
        .h_MU(h_MD)
    );
    assign v_WB_D = (WD_S == 1) ? PC_NOP_D : 32'bz;
    
    // extender
    assign  v_ext32 = (ctrl_s_ext == 1) ?   {{16{instrD[15]}}, instrD[`imm16]} :
                                            {{16'h0000}, instrD[`imm16]};
    
    CMP     u_cmp (
        .in1(fwd1), .in2(fwd2),
        .eq(ctrl_eq),
        .eqz(ctrl_eqz),
        .ltz(ctrl_ltz)
    );

    NPC     u_npc (
        .branch(ctrl_branch),
        .J(ctrl_j), .JR(ctrl_jr),

        .PC(v_PC_D), .PC_I(v_PC_I),
        .imm26(instrD[`imm26]), .v_Jump(fwd1), .NPC(NPC)
    );

    GRF     u_grf (
        .clk(clk), .reset(reset),
        .PC(PC_W),

        .R1(instrD[`rs]),
        .R2(instrD[`rt]),
        .R3(a_WB_W),

        .WD(v_WB_W),
        .DR1(v_R1_D), .DR2(v_R2_D)
    );
endmodule
