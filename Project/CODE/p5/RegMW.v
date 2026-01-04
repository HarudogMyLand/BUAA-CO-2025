`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:48:16 11/13/2025 
// Design Name: 
// Module Name:    RegMW 
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
module RegMW(
    input clk, reset,
    input [31:0] PC_M, instrM,

    input [31:0] v_R3_M,
    input [4:0] a_R3_M,

    output reg [31:0] PC_W, instrW,
    output reg [4:0] a_R3_W,
    output reg [31:0] v_R3_W
    );

task reset_mw;
    begin: reset_mw_block
		PC_W    <= 0;
		instrW  <= 0;
		a_R3_W  <= 0;
		v_R3_W  <= 0;
	end
endtask

	always@(posedge clk) begin
		if(reset) reset_mw;
		else begin
			PC_W <= PC_M;
			instrW <= instrM;
			a_R3_W <= a_R3_M;
			v_R3_W <= v_R3_M;
		end
	end
endmodule
