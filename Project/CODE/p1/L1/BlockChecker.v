`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:13:52 10/14/2025 
// Design Name: 
// Module Name:    BlockChecker 
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
`timescale 1ns / 1ps

module BlockChecker(
    input clk,
    input reset,
    input [7:0] in,
    output result
);

function [7:0] to_low;
    input [7:0] c;
    begin
        to_low = (c >= "A" && c <= "Z") ? (c - "A" + "a") :
                 (c >= "a" && c <= "z") ? c : 8'd0;
    end
endfunction

localparam [3:0] S0=0, S1=1, S2=2, S3=3, S4=4, S5=5, S6=6, S7=7, S8=8;

reg [3:0] state;
reg cnt;
reg [7:0] bfb, bfe;
reg [31:0] lef, rit;
reg err, prerr;


initial begin
    {state, cnt, bfb, bfe, lef, rit, err, prerr} <= 0;
    bfb <= " ";
    bfe <= " ";
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= S0;
        {cnt, lef, rit, err, prerr} <= 0;
        {bfb, bfe} <= " ";
    end else begin
        bfb <= in;
        bfe <= in;
        cnt <= 1;
        state <= S0;

        case (state)
            S0: begin
                if (in == " ") begin
                    state <= S0;
                end else if (to_low(in) == "b" && ((cnt == 0) || (bfb == " "))) begin
                    state <= S1;
                end else if (to_low(in) == "e" && ((cnt == 0) || (bfe == " "))) begin
                    state <= S6;
                end
            end

            S1: state <= (to_low(in) == "e") ? S2 : S0;
            S2: state <= (to_low(in) == "g") ? S3 : S0;
            S3: state <= (to_low(in) == "i") ? S4 : S0;
            S4: begin
                if (to_low(in) == "n") begin
                    state <= S5;
                    lef <= lef + 1;
                end
            end
            S5: begin
                if (in != " ") lef <= lef - 1;
                state <= S0;
            end

            S6: state <= (to_low(in) == "n") ? S7 : S0;
            S7: begin
                if (to_low(in) == "d") begin
                    state <= S8;
                    rit <= rit + 1;
                    if (lef == rit) begin
                        prerr <= err;
                        err <= 1;
                    end
                end
            end
            S8: begin
                if (in != " ") begin
                    rit <= rit - 1;
                    if (rit == lef + 1 && prerr == 0) begin
                        prerr <= err;
                        err <= 0;
                    end
                end
                state <= S0;
            end
        endcase
    end
end

assign result = !err && (lef == rit);

endmodule
