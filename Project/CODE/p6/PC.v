`timescale 1ns / 1ps
`define PC_DEFAULT	32'h0000_3000
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:10:46 11/12/2025 
// Design Name: 
// Module Name:    PC 
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
module PC(
        input clk, reset, 
        input PCEN,

        input [31:0] a_NPC,

        output reg [31:0] a_PC_I
    );

    initial a_PC_I = `PC_DEFAULT;

    always @(posedge clk) begin
        if(reset) begin
            a_PC_I <= `PC_DEFAULT;
        end
        else if (PCEN) begin
            a_PC_I <= a_NPC;
        end
    end
endmodule
