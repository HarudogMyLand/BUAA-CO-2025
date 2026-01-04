`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:59:55 11/13/2025 
// Design Name: 
// Module Name:    NPC 
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
module NPC(
        input c_branch,
        input c_j, c_jr, 
        input [31:0] PC, PC_I,      // Single PC input
        input [25:0] imm26,
        input [31:0] v_Jump,

        output reg [31:0] a_NPC
    );

    wire [31:0] PC4             = PC + 32'h00000004;
    wire [31:0] branch_target   = PC + 32'h00000004 + {{14{imm26[15]}}, imm26[15:0], 2'b00};
    wire [31:0] jump_target     = {{PC4[31:28]}, imm26, 2'b00};

    always @(*) begin
        a_NPC =   (c_jr)        ?  v_Jump :
                (c_branch)    ?  branch_target :
                (c_j)         ?  jump_target : PC_I + 4;
    end
endmodule

