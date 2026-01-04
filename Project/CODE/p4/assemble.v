`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:41:46 11/16/2025 
// Design Name: 
// Module Name:    assemble 
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
module assemble(
    input [31:0] in,
    output [31:0] hex
    );

    assign hex = in;
    always@(*) begin
        $display("%h", in);
    end

endmodule
