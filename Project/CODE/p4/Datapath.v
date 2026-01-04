`timescale 1ns / 1ps
`include "NPC.v" 
`include "IFU.v"
`include "Splitter.v"
`include "ALU.v"
`include "RegFile.v"
`include "DataMemo.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:16:02 11/11/2025 
// Design Name: 
// Module Name:    Datapath 
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
module Datapath(
        input           clk, reset,
        // ALU op
        input   [2:0]   aluCtrl, 
        // Reg write address control and reg data control
        input   [1:0]   regDesCtrl, regDataCtrl,
        // NPC select
        input   [2:0]   nextPCop,
        input           aluSrc, usExt, regWE, dmWE, dmRE,

        output  [31:0]  instr
    );

        wire [31:0]     PC, extendedImm, nextPC;

        wire [4:0]      rs, rt, rd;
        wire [4:0]      shamt;
        wire [15:0]     imm;
        wire [25:0]     j_addr;

        wire [4:0]      reg_r1, reg_r2, reg_r3;
        wire [31:0]     o1, o2, regDataIn;

        wire [31:0]     ALUin1, ALUin2, ALUout;
        wire            zero;

        wire [31:0]     dm_out;
        wire [31:0]     dm_addr;

    NPC u_npc(
        .nextPCop(nextPCop),
        .PC(PC), .eq(zero),
        .extendedImm(extendedImm),
        .j_addr(j_addr),
        .regPC(o1),
        .nextPC(nextPC)
    );

    IFU u_ifu(
        .clk(clk), .reset(reset),
        .PC(PC), .NPC(nextPC),
        .instr(instr)
    );

    Splitter u_split(
        .instr(instr),
        .rs(rs), .rt(rt), .rd(rd),
        .shamt(shamt), .imm(imm),
        .j_addr(j_addr)
    );

    RegFile regfile(
        .clk(clk), .reset(reset),
        .WE(regWE), .WD(regDataIn),
        .R1(reg_r1), .R2(reg_r2), .R3(reg_r3),
        .out1(o1), .out2(o2), .PC(PC)
    );

    assign reg_r1 = rs;
    assign reg_r2 = rt;
    assign reg_r3 = (regDesCtrl == 2'b00) ? rt :
                    (regDesCtrl == 2'b01) ? rd :
                    (regDesCtrl == 2'b10) ? 5'h00 : 5'h1f;
    assign regDataIn  = (regDataCtrl == 2'b00) ? dm_out :
                        (regDataCtrl == 2'b01) ? ALUout :
                        (regDataCtrl == 2'b10) ? 0 : PC + 4;

    ALU u_alu (
        .aluOp(aluCtrl),
        .inA(ALUin1), .inB(ALUin2),
        .out(ALUout),
        .zero(zero)
    );

    assign ALUin1 = o1;
    assign ALUin2 = (aluSrc == 0) ? o2 : extendedImm;
    assign extendedImm = (usExt == 0) ? {{16{imm[15]}}, imm} : {{16'd0}, imm};

    DataMemo u_dm(
        .clk(clk), .reset(reset),
        .WE(dmWE), 
        .addr(dm_addr),
        .data(o2), .out(dm_out), .PC(PC)
    );

    assign dm_addr      = (ALUout) >> 2;
endmodule
