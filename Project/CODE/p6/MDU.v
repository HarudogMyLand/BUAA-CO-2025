`timescale 1ns / 1ps
`define MULTU_OP	3'b000
`define MULT_OP	3'b001
`define DIVU_OP	3'b010
`define DIV_OP		3'b011
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:17:33 12/04/2025 
// Design Name: 
// Module Name:    MDU 
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
module MDU(
    input           clk,
    input           reset,
    
    input [31:0]    in1,
    input [31:0]    in2,
    
    input           start,
    input [2:0]     MDUOp,
    input           HIWE, 
    input           LOWE, 
    
    output reg [31:0] HI,
    output reg [31:0] LO,
    output            busy    
);

    reg [31:0]  temp_HI, temp_LO;
    reg [3:0]   cnt;

    assign busy = (cnt != 0);

    always @(posedge clk) begin
        if (reset) begin
            HI      <= 0;
            LO      <= 0;
            temp_HI <= 0;
            temp_LO <= 0;
            cnt     <= 0;
        end else begin
            if (cnt > 0) begin
                cnt <= cnt - 1;
                if (cnt == 1) begin
                    HI <= temp_HI;
                    LO <= temp_LO;
                end
            end
            if (start) begin
                case (MDUOp)
                    `MULTU_OP : begin
                        {temp_HI, temp_LO} <= in1 * in2;
                        cnt <= 5;
                    end
                    `MULT_OP : begin
                        {temp_HI, temp_LO} <= $signed(in1) * $signed(in2);
                        cnt <= 5;
                    end
                    `DIVU_OP : begin
                        if(in2 != 0) begin
                            temp_LO <= in1 / in2;
                            temp_HI <= in1 % in2;
                        end else begin 
                        end
                        cnt <= 10;
                    end
                    `DIV_OP : begin
                        if(in2 != 0) begin
                            temp_LO <= $signed(in1) / $signed(in2);
                            temp_HI <= $signed(in1) % $signed(in2);
                        end
                        cnt <= 10;
                    end
                    default: cnt <= 0;
                endcase
            end 
            else if (HIWE) begin
                HI <= in1;
            end 
            else if (LOWE) begin
                LO <= in1;
            end
        end
    end

endmodule