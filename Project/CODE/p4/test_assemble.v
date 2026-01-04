`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:43:05 11/16/2025
// Design Name:   assemble
// Module Name:   C:/Users/Harudog/Desktop/Use/WorkingArea/SrcCode/coCode/2025/coHw/p4/rebuildProject/ISE/test_assemble.v
// Project Name:  ISE
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: assemble
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_assemble;

	// Inputs
	reg [31:0] in;

	// Outputs
	wire [31:0] hex;

	// Instantiate the Unit Under Test (UUT)
	assemble uut (
		.in(in), 
		.hex(hex)
	);

	initial begin
		// Initialize Inputs
		in = 0;
		
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

