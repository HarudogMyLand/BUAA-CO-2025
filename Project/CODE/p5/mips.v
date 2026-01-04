`timescale 1ns / 1ps
`include "ModuleI.v"
`include "RegID.v"
`include "ModuleD.v"
`include "RegDE.v"
`include "ModuleE.v"
`include "RegEM.v"
`include "ModuleM.v"
`include "RegMW.v"
`include "Hazard.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:17:09 11/12/2025 
// Design Name: 
// Module Name:    mips 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//  This is top module of our CPU.
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//////////////////////////////////////////////////////////////////////////////////
module mips(
        input clk,
        input reset
    );

    // Hazard Signal
    wire h_stall_I;                 // stall i module
    wire h_stall_ID, h_stall_DE;    // stall id, de reg
    wire h_flush_DE, h_flush_EM;    // flush de, em reg
    wire h_D1, h_D2, h_E1, h_E2;    // require forwarding value

    // Hazard Forward values from HU
    wire [31:0] hv_fwd_D1, hv_fwd_D2, hv_fwd_E1, hv_fwd_E2;
    // Forward values from modules
    wire [31:0] fwd_D1, fwd_D2, fwd_E1, fwd_E2, fwdM2;

    // instructions and program counter wires
    wire [31:0] instr_I, instr_D, instr_E, instr_M, instr_W;
    wire [31:0] v_PC_I, v_PC_D, v_PC_E, v_PC_M, v_PC_W, v_NPC;

    // rd1 and rd2 wires
    wire [31:0] v_R1_D, v_R2_D, v_R1_E, v_R2_E, v_R2_EM, v_R2_M;

    // hazard address and value of write back
    wire [4:0]  ha_R3_E, ha_R3_M;
    wire [31:0] hv_R3_E, hv_R3_M;
    // write back wires
    wire [31:0] v_WB_D, v_WB_E, v_WB_M, v_WB_EM, v_WB_MW, v_WB_W;
    wire [4:0]  a_WB_D, a_WB_E, a_WB_M, a_WB_EM, a_WB_MW, a_WB_W;

    wire [31:0] ext_imm32_D, ext_imm32_E, ext_imm32_M;

    wire [31:0] ALUout_E, ALUout_M;
    
    // I-Stage, I_EN and stall_f should be connected, also fetch stage
    ModuleI u_modI (
        .clk(clk), .reset(reset),
        .I_EN(~h_stall_I),

        .v_NPC(v_NPC),
        .v_PC_I(v_PC_I),
        .instrI(instr_I)
    );

    RegID   r_modID (
        .clk(clk), .reset(reset),
        .ID_EN(~h_stall_ID),

        .instrI(instr_I),
        .instrD(instr_D),

        .PC_I(v_PC_I),
        .PC_D(v_PC_D)
    );

    // D-Stage
    ModuleD u_modD (
        // top control signal
        .clk(clk), .reset(reset),

        // instruction and program counter signal
        .instrD(instr_D),
        .v_PC_D(v_PC_D),
        .v_PC_I(v_PC_I),

        // forward values to HU
        .fwd1(hv_fwd_D1), .fwd2(hv_fwd_D2),

        // WB stage value
        .v_WB_W(v_WB_W), .PC_W(v_PC_W),
        .a_WB_W(a_WB_W),

        // output
        .v_R1_D(v_R1_D), .v_R2_D(v_R2_D),
        .a_WB_D(a_WB_D), .v_WB_D(v_WB_D),

        .v_ext32(ext_imm32_D),
        .NPC(v_NPC),

        // output hazard signal
        // .h_MD(h_MD),
        .h_D1(h_D1), .h_D2(h_D2)
    );

    RegDE   r_modDE (
        .clk(clk), .reset(reset || h_flush_DE),
        .DE_EN(~h_stall_DE),

        .instrD(instr_D),
        .instrE(instr_E),

        .PC_D(v_PC_D),
        .PC_E(v_PC_E),

        .v_imm32_D(ext_imm32_D),
        .v_imm32_E(ext_imm32_E),

        .v_R1_D(v_R1_D), .v_R2_D(v_R2_D),
        .v_R3_D(v_WB_D), .a_R3_D(a_WB_D),

        .v_R1_E(v_R1_E), .v_R2_E(v_R2_E),
        .v_R3_E(v_WB_E), .a_R3_E(a_WB_E)
    );

    // E-Stage
    ModuleE u_modE (
        .clk(clk), .reset(reset),
        .instrE(instr_E),

        .v_imm32_E(ext_imm32_E),

        .v_R1_E(v_R1_E), .v_R2_E(v_R2_E),
        .v_R3_E(v_WB_E), .a_R3_E(a_WB_E),

        .fwd1(fwd_E1), .fwd2(fwd_E2),
        // output 
        .v_R3_EM(v_WB_EM),
        .a_R3_EM(a_WB_EM),

        .v_ALUout_EM(ALUout_E), 
        .v_R2_EM(v_R2_EM),

        // .start(start),
        // .busy(busy),
        .h_E1(h_E1), .h_E2(h_E2)
    );

    RegEM   r_modEM (
        .clk(clk), .reset(reset || h_flush_EM), 
        
        .PC_E(v_PC_E), 
        .instrE(instr_E),
        
        .a_R3_E(a_WB_EM), .v_R3_E(v_WB_EM), 

        .ALUout_E(ALUout_E),
        .v_R2_E(v_R2_EM), 
        
        .PC_M(v_PC_M), 
        .instrM(instr_M), 
        .a_R3_M(a_WB_M), 
        .v_R3_M(v_WB_M),
        .ALUout_M(ALUout_M),
        .v_R2_M(v_R2_M)
    );

    // M-Stage
    ModuleM u_modM (
        .clk(clk), .reset(reset), 
        .PC_M(v_PC_M), 
        .instrM(instr_M), 
        
        .ALUout_M(ALUout_M),
        
        .a_R3_M(a_WB_M),
        .v_R3_M(v_WB_M), 
        
        .fwdM2(fwdM2), 
        
        .a_R3_MW(a_WB_MW),
        .v_R3_MW(v_WB_MW)
    );

    RegMW   r_modMW (
        .clk(clk), 
        .reset(reset), 
        .PC_M(v_PC_M), 
        .instrM(instr_M),
        .a_R3_M(a_WB_MW), 
        .v_R3_M(v_WB_MW), 
        
        .PC_W(v_PC_W), 
        .instrW(instr_W),
        .a_R3_W(a_WB_W), 
        .v_R3_W(v_WB_W)
    );

    // Hazard Ctrl Signal
    Hazard  u_hazard (
        .clk(clk), .reset(reset),

        // I & D-Stage
        .a_R1_D(instr_D[`rs]),
        .a_R2_D(instr_D[`rt]),

        // D-Stage
        .v_R1_D(v_R1_D),
        .v_R2_D(v_R2_D),

        .v_R1_E(v_R1_E),
        .v_R2_E(v_R2_E),

        .a_R1_E(instr_E[`rs]),
        .a_R2_E(instr_E[`rt]),

        .h_D1(h_D1),
        .h_D2(h_D2),
        .h_E1(h_E1),
        .h_E2(h_E2),
        // .MDU(MDU)

        .a_WB_E(a_WB_E),
        .v_WB_E(v_WB_E),

        // .start(start), .busy(busy),

        .a_R2_M(instr_M[`rt]),
        .v_R2_M(v_R2_M),

        .a_WB_M(a_WB_M),
        .v_WB_M(v_WB_M),

        .a_WB_W(a_WB_W),
        .v_WB_W(v_WB_W),

        .hv_fwd_D1(hv_fwd_D1), .hv_fwd_D2(hv_fwd_D2),
        .hv_fwd_E1(fwd_E1), .hv_fwd_E2(fwd_E2),
        .hv_fwd_M(fwdM2),

        .h_stall_I(h_stall_I),
        .h_stall_ID(h_stall_ID),
        .h_stall_DE(h_stall_DE),
        .h_flush_DE(h_flush_DE),
        .h_flush_EM(h_flush_EM)
    );

endmodule
