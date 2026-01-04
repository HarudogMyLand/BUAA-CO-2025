`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:42:11 11/13/2025 
// Design Name: 
// Module Name:    DM 
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
module DM(
        input clk, reset,
        input WE,

        // input [1:0] width,
        // input loadSign,

        input [31:0] addr, WD,

        output reg [31:0] RD,

        input [31:0] PC
    );

    reg [31:0] DataMemory [4095:0];
    integer i;

task reset_dm;
    begin: reset_dm_block
        for (i = 0; i < 4096; i = i + 1) DataMemory[i] <= 0;
    end
endtask

initial reset_dm;

    // write
    always @(posedge clk) begin
        if (reset) reset_dm;
        else if (WE == 1) begin
            DataMemory[addr[13:2]] <= WD;
			$display("%d@%h: *%h <= %h", $time, PC, addr, WD);	
        end
    end

    always@(*) begin	// load
		// case(width)
		RD = DataMemory[addr[13:2]];
			// default : RD = 32'bZ;
		// endcase
	end

endmodule
