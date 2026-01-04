module ALU (
    input [31:0]    inA, inB,
    input [2:0]     aluOp,
    output          zero,
    output          overflow,
    output reg [31:0] out
);

    always @(*) begin
        case(aluOp)
            3'b000: out = inA + inB;
            3'b001: out = inA - inB;
            3'b010: out = inA & inB;
            3'b011: out = inA | inB;
            3'b100: out = inB << 16;
            default: out = 0;
        endcase
    end
    assign zero = (out == 0);
endmodule