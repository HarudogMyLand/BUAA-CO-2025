`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:27:42 11/13/2025 
// Design Name: 
// Module Name:    GRF 
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
module GRF(
        input           clk, reset,
        input [4:0]     R1, R2, R3,
        input [31:0]    WD, PC,

        output [31:0]   DR1, DR2
    );

    reg [31:0] GRF [31:0];
    integer i;

    task reset_reg;
        begin: reset_reg_block
            for(i = 0; i < 32; i = i + 1) GRF[i] <= 0;
        end
    endtask

    initial reset_reg;

    always @(posedge clk) begin
        if (reset) reset_reg;
        else begin
            if (R3 != 0) begin
                GRF[R3] <= WD;
            end
        end
    end

    assign DR1 = (R1 == R3 && R1 != 0) ? WD : GRF[R1];
    assign DR2 = (R2 == R3 && R2 != 0) ? WD : GRF[R2];
endmodule
