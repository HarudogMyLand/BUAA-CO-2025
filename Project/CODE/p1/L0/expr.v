`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:50:54 10/14/2025 
// Design Name: 
// Module Name:    expr 
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
module expr(
    input clk,
    input clr,
    input [7:0] in,
    output out
    );
	reg [2:0] state, next_state;
	
	parameter s0 = 3'b000;
	parameter s1 = 3'b001;
	parameter s2 = 3'b010;
	parameter s3 = 3'b011;
	
	parameter error = 3'b111;
	
	always @(posedge clk or posedge clr) begin
		if (clr) state <= s0;
		else begin
			state <= next_state;
		end
	end
	
	always @(*) begin
		case(state)
		s0: 
			if (in >= 8'h30 && in <= 8'h39) next_state = s1;
			else if (in == 8'h2B || in == 8'h2A) next_state = error;
			else next_state = s0;
		s1:
			if (in == 8'h2B || in == 8'h2A) next_state = s2;
			else if (in >= 8'h30 && in <= 8'h39) next_state = error;
			else next_state = error;
		s2:
			if (in >= 8'h30 && in <= 8'h39) next_state = s3;
			else next_state = error;
		s3:
			if (in >= 8'h30 && in <= 8'h39) next_state = error;
			else if (in == 8'h2B || in == 8'h2A) next_state = s2;
			else next_state = error;
		error:
			next_state = error;
		default: next_state = s0;
		endcase
	end
	
	assign out = (state == s3)|| (state == s1);
	
endmodule
