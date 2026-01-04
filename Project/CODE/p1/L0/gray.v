`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:45:31 10/14/2025 
// Design Name: 
// Module Name:    gray 
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
module gray(
    input Clk,
    input Reset,
    input En,
    output [2:0] Output,
    output reg Overflow
    );
	reg [2:0] counter;
	
	// counter logic
	always @(posedge Clk) begin
		if (Reset) counter <= 0;
		else if (En) begin
			counter <= counter + 1;
		end
	end
	
	// overflow logic
	always @(posedge Clk) begin
		if (Reset) Overflow <= 0;
		else if (counter == 3'b111) Overflow <= 1;
	end

	// output gray conter code
	assign Output = counter ^ (counter >> 1);
endmodule
