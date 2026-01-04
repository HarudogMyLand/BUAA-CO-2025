`timescale 1ns / 1ps
`include "MainDecoder.v"
`include "ALUDecoder.v"
`include "NextPCop.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:15:49 11/11/2025 
// Design Name: 
// Module Name:    Controller 
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
module Controller(
        input  [31:0] instr,
        output [2:0] aluOp,
        output [1:0] regDesCtrl, regDataCtrl,
        output aluSrc, regWE, dmWE, dmRE, usExt,
        output [2:0] nextPCop
    );

    wire [2:0] aluWire, jType, bType;

    MainDecoder U_md(
            .opCode(instr[31:26]),
            .aluCtrl(aluWire),
            .aluSrc(aluSrc),
            .regDesCtrl(regDesCtrl), .regDataCtrl(regDataCtrl),
            .regWE(regWE), .dmWE(dmWE), .dmRE(dmRE), .usExt(usExt)
    );

    ALUDecoder U_ad(
		.funct(instr[5:0]),
        .opCode(instr[31:26]),
		.aluWire(aluWire),
		.aluOp(aluOp),
		.jType(jType), .branch(bType)
	);

    NextPCop U_npcOP(
        .nextPCop(nextPCop),
		.jType(jType), .bType(bType)
	);

endmodule
