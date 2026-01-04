`timescale 1ns/1ps
// ================================================================
// Instruction Field Macros
// ================================================================
`define instr  31:0
`define op     31:26
`define rs     25:21
`define base   25:21
`define rt     20:16
`define rd     15:11
`define shamt  10:6
`define funct  5:0
`define imm26  25:0
`define imm16  15:0

// ================================================================
// R-Type Instructions (opcode = 6'h0)
// ================================================================
`define R      6'h00

// Arithmetic Operations
// `define ADDU   6'b100001
`define ADDU    6'b100000
// `define SUBU   6'b100011
`define SUBU    6'b100010

// Logical Operations
`define AND    6'b100100
`define OR     6'b100101
`define XOR    6'b100110
`define NOR    6'b100111

// ================================================================
// I-Type Instructions
// ================================================================
// Immediate Arithmetic
`define LUI    6'b001111

// Immediate Logical
`define ORI    6'b001101


// ================================================================
// Memory Access Instructions
// ================================================================
`define LW     6'b100011
`define LB     6'b100000
`define LBU    6'b100100
`define LH     6'b100001
`define LHU    6'b100101

`define SW     6'b101011
`define SB     6'b101000
`define SH     6'b101001

// ================================================================
// Branch Instructions
// ================================================================
`define BEQ    6'b000100
`define BNE    6'b000101
`define BLEZ   6'b000110
`define BGTZ   6'b000111
`define BLTZ   6'b000001
`define BGEZ   6'b000001  // Note: Same opcode as BLTZ, differentiated by rt field

// ================================================================
// Jump Instructions
// ================================================================
// J-Type (uses opcode field only)
`define J      6'b000010
`define JAL    6'b000011

// R-Type Jump (uses funct field, opcode = `R)
`define JR     6'b001000