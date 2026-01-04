`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:57:54 11/11/2025 
// Design Name: 
// Module Name:    ALUDecoder 
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
//  jType:
//      000: not jump
//      001: j
//      010: jal
//      011: jr
//  branch:
//      000: not branch
//      001: beq
//////////////////////////////////////////////////////////////////////////////////
module ALUDecoder(
        input [5:0] funct, opCode,
        input [2:0] aluWire,
        output reg [2:0] aluOp,
        output reg [2:0] jType,
        output reg [2:0] branch
    );
    
    parameter ADD   = 6'b100000;
    parameter SUB   = 6'b100010;
    parameter JR    = 6'b001000;
    parameter JAL   = 6'b000011;
    parameter BEQ   = 6'b000100;

    // decide ALU opcode
    always @(*) begin
        if (aluWire == 3'b111) begin
            case(funct)
                ADD:    aluOp = 3'b000;
                SUB:    aluOp = 3'b001;
                JR:     aluOp = 3'b000;
                default:aluOp = 3'b000;
            endcase
        end
        else aluOp = aluWire;
    end 

    // output j and branch type
    always @(*) begin
        case(opCode)
            6'b000000: begin
                if (funct == JR)    {jType, branch} = 6'b011000;
                else                {jType, branch} = 6'b000000;
            end
            BEQ:                    {jType, branch} = 6'b000001;
            JAL:                    {jType, branch} = 6'b010000;
            default:                {jType, branch} = 6'b000000;
        endcase
    end

endmodule
