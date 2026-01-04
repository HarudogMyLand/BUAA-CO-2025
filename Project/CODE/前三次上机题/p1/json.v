`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:14:49 10/21/2025 
// Design Name: 
// Module Name:    json 
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
module json(
    input clk,
    input reset,
    input [7:0] char,
    output reg [7:0] cur_num,
    output reg [7:0] max_num
    );
	reg [3:0] state, next_state;
	reg [7:0] counter;
	
	parameter s0 = 4'd0, s1 = 4'd1, s2 = 4'd2, s3 = 4'd3;
	parameter s4 = 4'd4, s5 = 4'd5, s6 = 4'd6, s7 = 4'd7;
	parameter s8 = 4'd8, ERROR = 4'd9;
	
	always @(*) begin
		case(state) 
		s0: begin
			if (char == "\{") next_state = s1;
			else next_state = s0;
		end
		s1: begin
			if (char == 8'h22) next_state = s2;
			else if (char == " ") next_state = s1;
			else if (char == "\}") next_state = s0;
		end
		s2: begin
			if (char == 8'h22) next_state = ERROR;
			else next_state = s3;
		end
		s3: begin
			if (char == 8'h22) next_state = s4;
			else next_state = s3;
		end
		s4: begin
			if (char == ":") next_state = s5;
			else next_state = s4;
		end
		s5: begin
			if (char == 8'h22) next_state = s6;
			else next_state = s5;
		end
		s6: begin
			if (char == 8'h22) next_state = ERROR;
			else next_state = s7;
		end
		s7: begin
			if (char == 8'h22) next_state = s8;
			else next_state = s7;
		end
		s8: begin
			if (char == "\}") next_state = s0;
			else if (char == " ") next_state = s8;
			else if (char == ",") next_state = s1;
		end
		ERROR: begin
			if (char == "\}") next_state = s0;
			else next_state = ERROR;
		end
		endcase
	end
	
	always @(posedge clk or posedge reset) begin
		if (reset) begin
			{counter, cur_num, max_num} <= 0;
			state <= s0;
		end
		else begin
			state <= next_state;
		end
	end
	
	always @(posedge clk) begin
		case(state) 
			s8: begin
				if (next_state == s0) begin
					cur_num <= counter;
					max_num <= (counter > max_num) ? counter : max_num;
				end
			end
			s0: begin
				if (next_state == s1) counter <= 0;
			end
			s1: begin 
				if (next_state == s0) begin
					counter <= 0;
					cur_num <= 0;
				end
			end
			s7: begin
				if (char == 8'h22) 
					counter <= counter + 1;
			end
			ERROR: begin
				counter <= 0;
				if (next_state == s0) begin
					cur_num <= counter;
				end
			end
		endcase
	end

endmodule
