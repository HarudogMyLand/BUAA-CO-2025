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
        input clk,
        input reset,
        
        input [31:0] a_PC_M,
        input [31:0] instr_M,
        input [4:0] a_WB_M,
        input [31:0] v_WB_M,
        
        output reg [31:0] a_PC_W,
        output reg [31:0] instr_W,
        output reg [4:0] a_WB_W,
        output reg [31:0] v_WB_W
    );

initial begin
    a_PC_W      <=  0;
    instr_W     <=  0;
    a_WB_W      <=  0;
    v_WB_W      <=  0;
end

    always@(posedge clk) begin
		if(reset) begin
            a_PC_W      <=  0;
            instr_W     <=  0;
            a_WB_W      <=  0;
            v_WB_W      <=  0;
		end
		else begin
			a_PC_W <= a_PC_M;
			instr_W <= instr_M;
			a_WB_W <= a_WB_M;
			v_WB_W <= v_WB_M;
		end
	end
endmodule
