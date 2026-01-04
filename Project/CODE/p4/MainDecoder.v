`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:25:52 11/11/2025 
// Design Name: 
// Module Name:    MainDecoder 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//   Decode the input instruction [31:25] part, output coresponding siganl
// Dependencies: 
// 
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
// 
//  aluCtrl:
//      000: add
//      001: sub
//      010: and
//      011: or
//      100: sll inB 16
//      ...
//      111: need ALU decoder
//  aluSrc:
//      0: reg2
//      1: extended imm
//  regDataCtrl:
//      00: data from data memory
//      01: data from alu result
//      10: data from ???
//      11: data from PC + 4
//  regDesCtrl:
//      00: des count on rt
//      01: des count on rd
//      10: des count on ???
//      11: des is $ra, $31
//////////////////////////////////////////////////////////////////////////////////
module MainDecoder(
        input [5:0] opCode,
        output reg [2:0] aluCtrl,
        output reg [1:0] regDataCtrl, regDesCtrl,
        output reg regWE, dmRE, dmWE, aluSrc, usExt
    );

    parameter R_TYPE    = 6'b000000;
    parameter ORI       = 6'b001101;
    parameter LW        = 6'b100011;
    parameter SW        = 6'b101011;
    parameter BEQ       = 6'b000100;
    parameter BAO       = 6'b101101;
    parameter LUI       = 6'b001111;
    parameter JAL       = 6'b000011;

    always @(*) begin
        case(opCode)
            R_TYPE: begin
                aluCtrl = 3'b111;
                {regDataCtrl, regDesCtrl} = 4'b0101;
                {regWE, dmRE, dmWE ,usExt, aluSrc} = 5'b10000;
            end
            ORI: begin
                aluCtrl = 3'b011;
                {regDataCtrl, regDesCtrl} = 4'b0100;
                {regWE, dmRE, dmWE, usExt, aluSrc} = 5'b10011;
            end
            LW: begin
                aluCtrl = 3'b000;
                {regDataCtrl, regDesCtrl} = 4'b0000;
                {regWE, dmRE, dmWE, usExt, aluSrc} = 5'b11001;
            end
            SW: begin
                aluCtrl = 3'b000;
                {regDataCtrl, regDesCtrl} = 4'b0000;
                {regWE, dmRE, dmWE, usExt, aluSrc} = 5'b00101;
            end
            BEQ: begin
                aluCtrl = 3'b001;
                {regDataCtrl, regDesCtrl} = 4'b0000;
                {regWE, dmRE, dmWE, usExt, aluSrc} = 5'b00000;
            end
            LUI: begin
                aluCtrl = 3'b100;
                {regDataCtrl, regDesCtrl} = 4'b0100;
                {regWE, dmRE, dmWE, usExt, aluSrc} = 5'b10011;
            end
            JAL: begin
                aluCtrl = 3'b000;
                {regDataCtrl, regDesCtrl} = 4'b1111;
                {regWE, dmRE, dmWE, usExt, aluSrc} = 5'b10001;
            end
            default: begin
                aluCtrl = 3'b000;
                {regDataCtrl, regDesCtrl} = 4'b0000;
                {regWE, dmRE, dmWE, usExt, aluSrc} = 5'b00000;
            end
        endcase
    end
endmodule
