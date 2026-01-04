`timescale 1ns / 1ps
// `include "Controller.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:48:08 11/13/2025 
// Design Name: 
// Module Name:    ModuleM 
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
module ModuleM(
        input           clk, reset,
        input [31:0]    a_PC_M,
        input [31:0]    instr_M,

        input [4:0]     a_WB_M,
        input [31:0]    v_WB_M,
        input [31:0]    v_ALUout_M,
        input [31:0]    hv_fwd2_M,

        output [4:0]    a_WB_MW,
        output [31:0]   v_WB_MW,

        // Memory APIs
        input [31:0]    v_MEM_rdata,
        output [31:0]   a_MEM,
        output [31:0]   v_MEM_wdata,
        output [3:0]    c_byte,
        output [31:0]   a_PCM
);

    wire        c_memWE;
    wire [2:0]  c_loadSign;
    wire [31:0] v_MEM;
    wire        c_selWD_M;

    assign a_MEM = v_ALUout_M;

    Controller      u_ctrl_M (
        .instr(instr_M),
        .addr_M(v_ALUout_M),

        .c_memWE(c_memWE),
        .c_byte(c_byte),
        .c_loadSign(c_loadSign),
        .c_selWD_M(c_selWD_M),
        .c_storeSign(c_storeSign)
    );

    wire [8:0]      word_byte;
    wire [15:0]     word_half;
    wire [2:0]      c_storeSign;

    assign word_byte =  (v_ALUout_M[1:0] == 2'b00) ? v_MEM_rdata[7:0]   :
                        (v_ALUout_M[1:0] == 2'b01) ? v_MEM_rdata[15:8]  :
                        (v_ALUout_M[1:0] == 2'b10) ? v_MEM_rdata[23:16] :
                        (v_ALUout_M[1:0] == 2'b11) ? v_MEM_rdata[31:24] :
                        32'hz;
    
    assign word_half =  (v_ALUout_M[1:0] == 2'b00 || v_ALUout_M[1:0] == 2'b01) ? v_MEM_rdata[15:0] :
                        (v_ALUout_M[1:0] == 2'b10 || v_ALUout_M[1:0] == 2'b11) ? v_MEM_rdata[31:16] :
                        32'hz;


    assign v_MEM    =   (c_loadSign == 3'b000) ? v_MEM_rdata :
                        (c_loadSign == 3'b001) ? {{16{word_half[15]}}, word_half[15:0]} :
                        (c_loadSign == 3'b010) ? {{24{word_byte[7]}}, word_byte[7:0]} :
                        // for more load...
                        v_MEM_rdata;

    assign a_WB_MW  = a_WB_M;
    assign v_WB_MW  = (c_selWD_M == 0) ? v_WB_M : v_MEM;
    assign a_PCM    = a_PC_M;
    assign v_MEM_wdata =    (c_storeSign == 3'b011) ? hv_fwd2_M :
                            (c_storeSign == 3'b001) ? {2{hv_fwd2_M[15:0]}}:
                            (c_storeSign == 3'b010) ? {4{hv_fwd2_M[7:0]}} :
                            32'hz;
endmodule
