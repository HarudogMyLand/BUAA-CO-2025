`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:54:57 11/13/2025 
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
`include "macros.v"
module Controller(
    input [31:0] instr,
	
	// cmp signal
	input eq,
	input eqz,
	input ltz,
	
	// Decode-Stage
    output c_sExt,		// signed ext
	
	output branch,
    output J,
    output JR,
	
	output v_WD_s_D,
	output [4:0] a_WD_s_D,
	
	// Execute-Stage
    output [3:0] 	ALU_op,
	output 			ALU_sel1,
	output 			ALU_sel2,
	output [1:0] 	WD_sel_E,
	
	// Memory-Stage
	output WE_mem,
	output WD_sel_M,
	
	// hazard signals
	output h_D1,
	output h_D2,
	output h_E1,
	output h_E2,
	output h_MU
    );
	
	wire [5:0] op, funct, rt;

	assign op = instr[`op];
	assign funct = instr[`funct];
	assign rt = instr[`rt];
	
	wire addu, subu, ori, lw, sw, beq, lui, jal, nop;
	wire new_signal;
/// P5 decode
	assign addu = (op == `R) & (funct == `ADDU);
	assign subu = (op == `R) & (funct == `SUBU);
	assign ori 	= (op == `ORI);
	assign lw 	= (op == `LW);
	assign sw 	= (op == `SW);
	assign beq 	= (op == `BEQ);
	assign lui 	= (op == `LUI);
	// assign new_signal = (op == `NEWS);
// jump wire
	assign jal 	= (op == `JAL);
	assign jr 	= (op == `R) & (funct == `JR);

// sign
	assign c_sExt = lw || sw || beq;
// branch
	assign branch = (beq & eq);
// J
	assign J = jal;
// JR
	assign JR = jr;
	
	// Write value select at D stage
	assign v_WD_s_D = jal;	// PC + 8 would be write into GRF
	
	// Write addr select at D stage
	assign a_WD_s_D =	(jal) 				? 5'd31 :			// write to 31
						(lui | ori| lw) 	? instr[`rt] :		// I-Type, write to rt
						(addu | subu)		? instr[`rd]:
						0;
////////// Decode End /////////////

//////////// Execute begin ///////////

	// ALUOp, 0 means add
	assign ALU_op =	(addu)?  4'b0000 :
					(subu)?	4'b0001 :
					(ori)?	4'b0011 :
					(lui)?	4'b0100 :
					0;
	// ALUSel
	assign ALU_sel1 = 0;						// use s in instr
	assign ALU_sel2 =	ori || lui || lw || sw;	// if you need to use imm26
						
	
	// write data select at E stage
	assign WD_sel_E = 
					(addu || subu || ori || lui) ?  2'b01 :	// use alu data
													2'b00;	// default use jump data that generate on D-Stage

////////////// Execute End ////////////

//////////// Memory Begin /////////////
	assign WE_mem = sw; 
	assign WD_sel_M = lw; 
//////////// Memory End //////////////

////////////// Stall Begin ///////////////

	// D use signal
	// Report to Hazard unit: require writing data at D stage
	assign h_D1 = jr || beq;
	assign h_D2 = beq;
	
	// E-Use: the RegRead Data is using in the Exe-Stage
	// E-Use will tell the Forwaed/Stall, I need the GRF Data right now!!
	assign h_E1 = addu || subu || ori || lw || sw;
	assign h_E2 = addu || subu;
	
	// M-Use: the RegRead Data is useing in the Mem-Stage
	// assign M2Use = sw || sh || sb;
	assign h_MU = sw;
endmodule
