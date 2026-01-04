`timescale 1ns / 1ps
`define ADDU_OP    4'b0000
`define SUBU_OP    4'b0001
`define AND_OP     4'b0010
`define OR_OP      4'b0011
`define LUI_OP     4'b0100
`define SLT_OP     4'b0101
`define SLTU_OP    4'b0110
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:37:32 11/13/2025 
// Design Name: 
// Module Name:    ALU 
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
module ALU(
        input [31:0] A,
        input [31:0] B,
        input [3:0] ALUOp,
        output reg [31:0] out
    );

    always @(*) begin
        case(ALUOp)
            `ADDU_OP :
				out = A + B;
			`SUBU_OP :
				out = A - B;
			`AND_OP :
				out = A & B;
			`OR_OP :
				out = A | B;
			`LUI_OP:
				out = {B[15:0], 16'h0};
			`SLT_OP:
				out = ($signed(A) < $signed(B));
			`SLTU_OP:
				out = (A < B);
			default:
				out = 0;
		endcase
    end

endmodule
