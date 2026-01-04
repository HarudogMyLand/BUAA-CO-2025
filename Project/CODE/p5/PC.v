`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:10:46 11/12/2025 
// Design Name: 
// Module Name:    PC 
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
module PC(
        input clk, reset,
        input EN,

        input   [31:0] v_NPC,
        output  reg [31:0] v_PC_I, 
        output  [31:0] instrI
    );

reg[31:0] IM [4095:0];
integer i;

task reset_im;
    begin: reset_im_task
        $readmemh("code.txt", IM); 
        v_PC_I <= 32'h00003000;
    end
endtask

    initial begin
        reset_im;
    end

    always @(posedge clk) begin
        if (reset) begin
            reset_im;
        end
        else if (EN == 1) begin
            v_PC_I <= v_NPC;
        end
    end
    wire [31:0] pc = v_PC_I - 32'h00003000;
    
    assign instrI = IM[pc[13:2]];
endmodule
