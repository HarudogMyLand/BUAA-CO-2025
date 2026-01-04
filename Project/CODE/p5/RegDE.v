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
        input [31:0] PC_D, instrD,
        input [31:0] v_R1_D, v_R2_D, v_R3_D,
        input [4:0] a_R3_D,
        input [31:0] v_imm32_D,

        output reg [31:0] PC_E, instrE,
        output reg [31:0] v_R1_E, v_R2_E, v_R3_E,
        output reg [4:0]  a_R3_E,
        output reg [31:0] v_imm32_E
    );

task reset_regDE;
    begin: reset_regDE_block
        {PC_E, instrE, v_R1_E, v_R2_E, a_R3_E, v_R3_E, v_imm32_E} <= 0;
    end
endtask

    always @(posedge clk) begin
        if (reset) reset_regDE;
        else if (DE_EN) begin
            PC_E        <= PC_D;
            instrE      <= instrD;
            v_R1_E      <= v_R1_D;
            v_R2_E      <= v_R2_D;
            v_R3_E      <= v_R3_D;
            a_R3_E      <= a_R3_D;
            v_imm32_E   <= v_imm32_D;
        end
    end

endmodule
