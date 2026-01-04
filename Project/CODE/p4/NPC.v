module NPC (
    input [2:0] nextPCop,
    input [31:0] PC,
    input [31:0] extendedImm,
    input [25:0] j_addr,
    input [31:0] regPC,
    input eq,
    output reg [31:0] nextPC
);

    wire [31:0] jPC = {PC[31:28], j_addr, 2'b00};
    wire [31:0] branchPC = PC + 4 + (extendedImm << 2);

    always@(*) begin
        case(nextPCop)
        3'b000: nextPC = PC + 4;
        3'b001: nextPC = jPC;
        3'b011: nextPC = regPC;
        3'b010: nextPC = (eq == 1) ? branchPC : PC + 4;
        default: nextPC = PC + 4;
        endcase
    end

endmodule