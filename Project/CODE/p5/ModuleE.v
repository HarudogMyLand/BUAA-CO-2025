`timescale 1ns / 1ps
`include "ALU.v"
// `include "Controller.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:47:39 11/13/2025 
// Design Name: 
// Module Name:    ModuleE 
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
module ModuleE(
        input           clk, reset,

        input [31:0]    instrE,

        input [31:0]    v_R1_E, v_R2_E, v_R3_E,
        input [4:0]     a_R3_E,

        input [31:0]    v_imm32_E,

        input [31:0]    fwd1, fwd2,

        output [31:0]   v_R3_EM,
        output [31:0]   v_ALUout_EM,
        output [31:0]   v_R2_EM,
        output [4:0]    a_R3_EM,

        // output          start, // for MDU
        // output          busy,
        output          h_E1, h_E2
    );

    wire [31:0] out, ALU_A, ALU_B;
    wire [3:0]  ALUop;
    wire [1:0] WD_sel_E;
    // wire [31:0] hi, lo;

    // Controller

    Controller u_ctrl_E(
        .instr(instrE),

        .ALU_op(ALUop),
        .ALU_sel1(ALU_sel1), .ALU_sel2(ALU_sel2),

        .WD_sel_E(WD_sel_E),

        .h_E1(h_E1), .h_E2(h_E2)
    );

    assign ALU_A = (ALU_sel1 == 0)? fwd1 : {27'b0, instrE[10:6]};
    assign ALU_B = (ALU_sel2 == 0)? fwd2 : v_imm32_E;

    // ALU
    ALU u_alu (
        .inA(ALU_A), .inB(ALU_B),
        .op(ALUop),
        .out(out)
    );

    assign v_R3_EM =(WD_sel_E == 2'b00)?	v_R3_E  :
					(WD_sel_E == 2'b01)?	out     :
					v_R3_E;

    assign a_R3_EM      = a_R3_E;
    assign v_ALUout_EM  = out;
    assign v_R2_EM      = fwd2;

endmodule
