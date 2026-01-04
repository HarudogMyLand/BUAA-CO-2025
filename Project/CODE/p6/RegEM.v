`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:47:57 11/13/2025 
// Design Name: 
// Module Name:    RegEM 
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
module RegEM(
        input           clk, reset,
        input [31:0]    a_PC_E, instr_E,

        input [31:0]    v_R2_EM,
        input [31:0]    v_ALUout_EM,
        input [4:0]     a_WB_EM,
        input [31:0]    v_WB_EM,

        output reg [31:0] a_PC_M, instr_M,
        output reg [31:0] v_WB_M,
        output reg [31:0] v_ALUout_M,
        output reg [31:0] v_R2_M,
        output reg [4:0]  a_WB_M
    );

task reset_regEM;
    begin: reset_block
        a_PC_M      <= 0;
        instr_M     <= 0;
        a_WB_M      <= 0;
        v_WB_M      <= 0;
        v_ALUout_M  <= 0;
        v_R2_M      <= 0;
    end
endtask

    always @(posedge clk) begin
        if (reset) reset_regEM;
        else begin
            a_PC_M      <= a_PC_E;
            instr_M     <= instr_E;
            a_WB_M      <= a_WB_EM;
            v_WB_M      <= v_WB_EM;
            v_ALUout_M  <= v_ALUout_EM;
            v_R2_M      <= v_R2_EM;
        end
    end

endmodule
