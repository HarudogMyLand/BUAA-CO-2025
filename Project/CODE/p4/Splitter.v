module Splitter (
    input   [31:0]  instr,
    output  [5:0]   opCode,
    output  [4:0]   rs, rt, rd,
    output  [4:0]   shamt,
    output  [5:0]   funct,
    output  [15:0]  imm,
    output  [25:0]  j_addr
);

    assign {opCode, rs, rt, rd, shamt, funct} = instr;
    assign imm      = instr[15:0];
    assign j_addr   = instr[25:0];
    
endmodule