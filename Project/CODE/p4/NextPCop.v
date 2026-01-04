`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:12:36 11/11/2025 
// Design Name: 
// Module Name:    NextPCop 
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
//  nextPCop:
//      00: pc + 4
//      01: j index
//      10: beq offset
//      11: register
//////////////////////////////////////////////////////////////////////////////////
module NextPCop(
        input      [2:0] jType, bType,
        output reg [2:0] nextPCop
    );

    always @(*) begin
        case({jType, bType})
            6'b000000: nextPCop = 3'b000; 
            6'b010000: nextPCop = 3'b001;
            6'b000001: nextPCop = 3'b010;
            6'b011000: nextPCop = 3'b011;
            default: nextPCop = 3'b000;
        endcase
    end

endmodule
