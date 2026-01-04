`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   23:40:00 11/14/2025
// Design Name:   mips
// Module Name:   C:/Users/Harudog/Desktop/Use/WorkingArea/SrcCode/coCode/2025/coHw/p5/CPU_P5/test.v
// Project Name:  CPU_P5
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: mips
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test;

	// Inputs
	reg clk;
	reg reset;

	// Instantiate the Unit Under Test (UUT)
	mips uut (
		.clk(clk), 
		.reset(reset)
	);

	always #5 clk = ~clk;
	
	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 1;
		#20;
		reset = 0;
		// Wait 100 ns for global reset to finish
		#5000;
        $finish;
		// Add stimulus here

	end
endmodule

