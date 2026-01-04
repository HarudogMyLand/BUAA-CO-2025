`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:17:30 11/13/2025 
// Design Name: 
// Module Name:    RegDE 
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
module RegDE(
        input clk, reset,
        input DE_EN,
        input [31:0] a_PC_D, instr_D,
        input [31:0] v_R1_D, v_R2_D, v_WB_D,
        input [4:0]  a_WB_D, 
        input [31:0] v_imm32_D,

        output reg [31:0] a_PC_E, instr_E,
        output reg [31:0] v_R1_E, v_R2_E, v_WB_E,
        output reg [4:0]  a_WB_E,
        output reg [31:0] v_imm32_E
    );

task reset_regDE;
    begin: reset_block
        a_PC_E  <= 0;
        instr_E <= 0;
        v_R1_E  <= 0;
        v_R2_E  <= 0;
        v_WB_E  <= 0;
        a_WB_E  <= 0;
        v_imm32_E <= 0;
    end 
endtask

    always @(posedge clk) begin
        if(reset) reset_regDE;
        else if (DE_EN) begin
            a_PC_E      <= a_PC_D;
            instr_E     <= instr_D;
            v_R1_E      <= v_R1_D;
            v_R2_E      <= v_R2_D;
            v_WB_E      <= v_WB_D;
            a_WB_E      <= a_WB_D;
            v_imm32_E   <= v_imm32_D;
        end
    end
endmodule
