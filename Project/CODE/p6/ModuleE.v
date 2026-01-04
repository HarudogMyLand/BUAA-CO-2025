`timescale 1ns / 1ps
`include "ALU.v"
`include "MDU.v"
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

        input [31:0]    instr_E,

        input [31:0]    v_R1_E, v_R2_E, v_WB_E,
        input [4:0]     a_WB_E,

        input [31:0]    v_imm32_E, 

        input [31:0]    hv_fwd1_E,
        input [31:0]    hv_fwd2_E,

        output [31:0]   v_WB_EM,
        output [31:0]   v_ALUout_EM,
        output [31:0]   v_R2_EM,
        output [4:0]    a_WB_EM,

        output start,
        output busy,
        output h_E1, h_E2
    );

    wire [31:0] out, ALU_A, ALU_B;
    wire [3:0]  c_ALU_op;
    wire [2:0]  MDUOp;
    wire [1:0]  WD_sel_E;

    wire [31:0] hi, lo;

    assign ALU_A    =   (c_ALU_in1 == 0)? hv_fwd1_E : {27'b0, instr_E[10:6]};
    assign ALU_B    =   (c_ALU_in2 == 0)? hv_fwd2_E : v_imm32_E;

    assign v_WB_EM  =   (WD_sel_E == 2'b00)?	v_WB_E  :
					    (WD_sel_E == 2'b01)?	out     :
                        (WD_sel_E == 2'b10)?    hi      :
                        (WD_sel_E == 2'b11)?    lo      :
					    v_WB_E;

    assign a_WB_EM      = a_WB_E;
    assign v_R2_EM      = hv_fwd2_E;
    assign v_ALUout_EM  = out;

    Controller u_ctrl_E(
        .instr(instr_E),

        .c_ALU_op(c_ALU_op),
        .c_selWD_E(WD_sel_E),

        .c_ALU_in1(c_ALU_in1),
        .c_ALU_in2(c_ALU_in2),

        .start(start),
        .c_HIWE(c_HIWE),
        .c_LOWE(c_LOWE),

        .MDUop(MDUOp),

        .h_E1(h_E1), .h_E2(h_E2)
    );

    ALU     u_alu (
        .A(ALU_A), 
        .B(ALU_B),

        .ALUOp(c_ALU_op),
        
        .out(out)
    );

    MDU     u_mdu (
        .clk(clk),
        .reset(reset),

        .in1(hv_fwd1_E),
        .in2(hv_fwd2_E),

        .start(start),
        .busy(busy),

        .MDUOp(MDUOp),
        .HIWE(c_HIWE),
        .LOWE(c_LOWE),

        .HI(hi),
        .LO(lo)
    );



endmodule
