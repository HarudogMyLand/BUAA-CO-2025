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
        // input api
        input clk,
        input reset,
        input [31:0] i_inst_rdata,      // Instruction
        input [31:0] m_data_rdata,      // Read Data

        // output api
        output [31:0] i_inst_addr,      // PC addr
        output [31:0] m_data_addr,      // Memo addr
        output [31:0] m_data_wdata,     // Memo data
        output [3 :0] m_data_byteen,    // Memo byte enable
        output [31:0] m_inst_addr,      // Memo stage PC
        output w_grf_we,                // GRF write enable
        output [4:0] w_grf_addr,        // GRF write addr
        output [31:0] w_grf_wdata,      // GRF write data
        output [31:0] w_inst_addr       // write stage PC
    );
    
    // Instructions and program counters
    wire [31:0] a_PC_I, a_PC_D, a_PC_E, a_PC_M, a_PC_W, a_NPC;
    wire [31:0] instr_I, instr_D, instr_E, instr_M, instr_W;

    // r1 and r2 values
    wire [31:0] v_R1_D, v_R1_E;
    wire [31:0] v_R2_D, v_R2_E, v_R2_EM, v_R2_M;

    // Write back wires
    wire [31:0] v_WB_D, v_WB_E, v_WB_M, v_WB_EM, v_WB_MW, v_WB_W;
    wire [4:0]  a_WB_D, a_WB_E, a_WB_M, a_WB_EM, a_WB_MW, a_WB_W;

    // Forward Write back wires
    wire [31:0] hv_WB_E, hv_WB_M;
    wire [4:0]  ha_WB_E, ha_WB_M;

    // Forward values from Hazard Unit
    wire [31:0] hv_fwd1_D, hv_fwd2_D, hv_fwd1_E, hv_fwd2_E, hv_fwd2_M;
    // Forward values from modules
    wire [31:0] fwd1_D, fwd2_D, fwd1_E, fwd2_E, fwd2_M;

    // Extended Imm number
    wire [31:0] v_imm32_D, v_imm32_E, ext_imm32_M;

    // ALU out
    wire [31:0] ALUout_E, ALUout_M;
    
    // Hazard Unit control signals
    wire h_stall_I;
    wire h_stall_ID;
    wire h_stall_DE;
    wire h_flush_DE;
    wire h_flush_EM;

    // Module D/E/Hazard interface
    wire h_D1, h_D2;
    wire h_E1, h_E2;
    wire c_MD;
    wire start;
    wire busy;

    // Memory Module M Outputs
    wire [3:0] c_byte; // for m_data_byteen
    wire [31:0] a_PCM; // for m_inst_addr

    // Fetch Stage
    ModuleI u_modI (
        .clk(clk),
        .reset(reset),
        // Input
        .PCEN(~h_stall_I),
        .a_NPC(a_NPC),
        // Output
        .a_PC_I(a_PC_I)
    );

    assign i_inst_addr  = a_PC_I;
    assign instr_I      = i_inst_rdata;

    RegID   r_modID (
        .clk(clk), .reset(reset),
        .ID_EN(~h_stall_ID),
        .instr_I(instr_I),
        .instr_D(instr_D), 

        .a_PC_I(a_PC_I),
        .a_PC_D(a_PC_D)
    );

    ModuleD u_modD (
        .clk(clk), .reset(reset),
        // Input
        .instr_D(instr_D),
        .a_PC_I(a_PC_I),
        .a_PC_D(a_PC_D),
        
        .hv_fwd1_D(hv_fwd1_D),
        .hv_fwd2_D(hv_fwd2_D),

        .v_WB_W(v_WB_W),
        .a_WB_W(a_WB_W),
        .a_PC_W(a_PC_W),
        // Output
        .v_R1_D(v_R1_D),
        .v_R2_D(v_R2_D),
        .a_WB_D(a_WB_D),
        .v_WB_D(v_WB_D),

        .v_ext32(v_imm32_D),
        .a_NPC(a_NPC),

        .h_D1(h_D1),
        .h_D2(h_D2),
        .c_MD(c_MD)
    );

    assign w_grf_we     = (a_WB_W !== 0 && a_WB_W !== 32'hx) & (v_WB_W !== 32'hz);
    assign w_grf_addr   = (a_WB_W);
    assign w_grf_wdata  = (v_WB_W);
    assign w_inst_addr  = (a_PC_W);

    RegDE   r_modDE (
        .clk(clk), .reset(reset || h_flush_DE),
        .DE_EN(~h_stall_DE),

        .instr_D(instr_D), 
        .instr_E(instr_E),

        .a_PC_D(a_PC_D),
        .a_PC_E(a_PC_E),

        .v_imm32_D(v_imm32_D),
        .v_imm32_E(v_imm32_E),

        .v_R1_D(v_R1_D), .v_R2_D(v_R2_D),
        .v_WB_D(v_WB_D), .a_WB_D(a_WB_D),

        .v_R1_E(v_R1_E), .v_R2_E(v_R2_E),
        .v_WB_E(v_WB_E), .a_WB_E(a_WB_E)
    );

    ModuleE u_modE (
        .clk(clk), .reset(reset),
        // Input
        .instr_E(instr_E),

        .v_R1_E(v_R1_E),
        .v_R2_E(v_R2_E),
        .v_WB_E(v_WB_E),
        .a_WB_E(a_WB_E),

        .v_imm32_E(v_imm32_E),

        .hv_fwd1_E(hv_fwd1_E),
        .hv_fwd2_E(hv_fwd2_E),

        // Output
        .v_WB_EM(v_WB_EM),
        .v_ALUout_EM(ALUout_E),

        .v_R2_EM(v_R2_EM),
        .a_WB_EM(a_WB_EM),

        .start(start),
        .busy(busy),

        .h_E1(h_E1),
        .h_E2(h_E2)
    );

    RegEM   r_modEM (
        .clk(clk),
        .reset(reset | h_flush_EM),
        // input 
        .a_PC_E(a_PC_E),
        .instr_E(instr_E),

        .a_WB_EM(a_WB_EM),
        .v_WB_EM(v_WB_EM),

        .v_ALUout_EM(ALUout_E),

        .v_R2_EM(v_R2_EM),
        // Output
        .a_PC_M(a_PC_M),
        .instr_M(instr_M),

        .a_WB_M(a_WB_M),
        .v_WB_M(v_WB_M),

        .v_ALUout_M(ALUout_M),
        .v_R2_M(v_R2_M)

    );

    ModuleM u_modM (
        .clk(clk),
        .reset(reset),
        
        .a_PC_M(a_PC_M),
        .instr_M(instr_M),

        .a_WB_M(a_WB_M),
        .v_WB_M(v_WB_M),

        .v_ALUout_M(ALUout_M),

        .hv_fwd2_M(hv_fwd2_M),

        .a_WB_MW(a_WB_MW),
        .v_WB_MW(v_WB_MW),

        .v_MEM_rdata(m_data_rdata),

        .a_MEM(m_data_addr),
        .v_MEM_wdata(m_data_wdata),
        .c_byte(m_data_byteen),
        .a_PCM(m_inst_addr)
    );

    RegMW   r_modMW (
        .clk(clk), 
        .reset(reset), 
        // Input Signal
        .a_PC_M(a_PC_M), 
        .instr_M(instr_M),
        .a_WB_M(a_WB_MW), 
        .v_WB_M(v_WB_MW), 
        // Output Signal
        .a_PC_W(a_PC_W), 
        .instr_W(instr_W),
        .a_WB_W(a_WB_W), 
        .v_WB_W(v_WB_W)
    );

    Hazard  u_hazard (
        .clk(clk),
        .reset(reset),

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
        .MDU(c_MD),

        .a_WB_E(a_WB_E),
        .v_WB_E(v_WB_E),

        .start(start), .busy(busy),

        .a_R2_M(instr_M[`rt]),
        .v_R2_M(v_R2_M),

        .a_WB_M(a_WB_M),
        .v_WB_M(v_WB_M),

        .a_WB_W(a_WB_W),
        .v_WB_W(v_WB_W),

        .hv_fwd1_D(hv_fwd1_D),
        .hv_fwd2_D(hv_fwd2_D),
        .hv_fwd1_E(hv_fwd1_E),
        .hv_fwd2_E(hv_fwd2_E),
        .hv_fwd2_M(hv_fwd2_M),

        .h_stall_I(h_stall_I),
        .h_stall_ID(h_stall_ID),
        .h_stall_DE(h_stall_DE),
        .h_flush_DE(h_flush_DE),
        .h_flush_EM(h_flush_EM)
    );

endmodule
