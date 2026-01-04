`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:27:22 11/12/2025 
// Design Name: 
// Module Name:    RegID 
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
module RegID(
        input clk, reset,
        input ID_EN,

        input   [31:0]      instrI, PC_I,
        output  reg [31:0]  instrD, PC_D
    );

    // forward instruction and pc

    always @(posedge clk) begin
        if (reset) begin
            instrD  <= 32'd0;
            PC_D  <= 32'd0;
        end
        else if (ID_EN) begin
            instrD  <= instrI;
            PC_D   <= PC_I;
        end
    end

endmodule
