`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:47:57 11/13/2025 
// Design Name: 
// Module Name:    RegEM 
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
module RegEM(
        input           clk, reset,
        input [31:0]    PC_E, instrE,

        input [31:0]    v_R2_E,
        input [31:0]    ALUout_E,
        input [4:0]     a_R3_E,
        input [31:0]    v_R3_E,

        output reg [31:0]   PC_M, instrM,
        output reg [4:0]    a_R3_M,
        output reg [31:0]   v_R3_M,
        output reg [31:0]   ALUout_M,
        output reg [31:0]   v_R2_M
    );

task reset_regEM;
    begin: reset_regEM_block
        {PC_M, instrM, a_R3_M, v_R3_M, ALUout_M, v_R2_M} <= 0;
    end
endtask

    always@(posedge clk) begin
		if(reset) reset_regEM;
		else begin
			PC_M    <= PC_E;
			instrM  <= instrE;
			a_R3_M  <= a_R3_E;
			v_R3_M  <= v_R3_E;
			ALUout_M <= ALUout_E;
			v_R2_M <= v_R2_E;
		end
	end


endmodule
