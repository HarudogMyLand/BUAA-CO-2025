`timescale 1ns / 1ps
`define ADDU_OP    4'b0000
`define SUBU_OP    4'b0001
`define AND_OP     4'b0010
`define OR_OP      4'b0011
`define	LUI_OP	   4'b0100
`define NEW_OP     4'b0101
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
    input   [31:0]  inA, inB,
    input   [3:0]   op,

    output  reg [31:0]  out
    );

    always @(*) begin
        case (op)
            `ADDU_OP: out = inA + inB;
            `SUBU_OP: out = inA - inB;
            `AND_OP : out = inA & inB;
            `OR_OP  : out = inA | inB;
            `LUI_OP : out = {inB[15:0], 16'h0};
            `NEW_OP: begin

            end
        endcase
    end

endmodule
