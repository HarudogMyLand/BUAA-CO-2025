`timescale 1ns / 1ps
`include "ALU.v"
////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:54:21 11/15/2025
// Design Name:   ALU
// Module Name:   C:/Users/Harudog/Desktop/Use/WorkingArea/SrcCode/coCode/2025/coHw/p4/rebuildProject/ISE/test_alu.v
// Project Name:  ISE
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ALU
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_alu;

	// Inputs
	reg [31:0] inA;
	reg [31:0] inB;
	reg [2:0] aluOp;

	// Outputs
	wire zero;
	wire [31:0] out;

	// Instantiate the Unit Under Test (UUT)
	ALU uut (
		.inA(inA), 
		.inB(inB), 
		.aluOp(aluOp), 
		.zero(zero), 
		.out(out)
	);

	initial begin
		// Initialize Inputs
		inA = 0;
		inB = 0;
		aluOp = 0;
		aluOp = 3'b101;
		inA = 0;
		#10
		inA = -1;
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

