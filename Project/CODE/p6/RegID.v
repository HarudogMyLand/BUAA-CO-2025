`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:27:22 11/12/2025 
// Design Name: 
// Module Name:    RegID 
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
module RegID(
        input clk, reset,
        input ID_EN,

        input [31:0] instr_I,
        input [31:0] a_PC_I,

        output reg [31:0] instr_D,
        output reg [31:0] a_PC_D
    );

    always @(posedge clk) begin
        if (reset) begin
            instr_D <= 32'd0;
            a_PC_D  <= 32'd0;
        end else if (ID_EN) begin
            instr_D <= instr_I;
            a_PC_D  <= a_PC_I;
        end
    end

endmodule
