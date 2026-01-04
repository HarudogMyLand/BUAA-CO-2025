`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:40:40 11/13/2025 
// Design Name: 
// Module Name:    CMP 
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
module CMP(
        input [31:0]    in1, in2,

        output          eq, eqz, ltz, new_signal
    );

    assign eq   = (in1 == in2);
	assign eqz  = (in1 == 0);
	assign ltz  = in1[31];


endmodule
