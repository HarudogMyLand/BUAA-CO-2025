`timescale 1ns / 1ps
`include "Controller.v"
`include "Datapath.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:06:42 11/11/2025 
// Design Name: 
// Module Name:    mips 
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
module mips(
    input reset,
    input clk
);

    wire [31:0] instr;
    wire [2:0]  aluOp;
    wire [1:0]  regDesCtrl, regDataCtrl;
    wire [2:0] nextPCop;
    wire aluSrc, regWE, dmWE, dmRE, usExt;

    Controller
        U_ctrl(
            .instr(instr),
            .aluOp(aluOp),
            .regDesCtrl(regDesCtrl),
            .regDataCtrl(regDataCtrl),
            .nextPCop(nextPCop),
            .aluSrc(aluSrc),
            .regWE(regWE),
            .dmWE(dmWE),
            .dmRE(dmRE),
            .usExt(usExt)
        );
    
    Datapath
        U_dp(
            .instr(instr),
            .clk(clk), .reset(reset),
            .aluCtrl(aluOp),
            .regDesCtrl(regDesCtrl),
            .regDataCtrl(regDataCtrl),
            .nextPCop(nextPCop),
            .aluSrc(aluSrc),
            .regWE(regWE),
            .dmWE(dmWE),
            .dmRE(dmRE),
            .usExt(usExt)
        );

endmodule
