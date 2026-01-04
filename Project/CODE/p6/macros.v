// MACROS
// INSTRUCTION ASSITANT MACROS
`define instr   31:0
`define rs      25:21
`define rt      20:16
`define rd      15:11
`define imm16   15:0
`define imm26   25:0
`define op      31:26
`define funct   5:0
`define shamt   10:6

// R TYPE FUNCT
`define R       6'h0

`define ADDU    6'b100001
`define ADD     6'b100000
`define SUBU    6'b100011
`define SUB     6'b100010

`define AND     6'b100100
`define OR		6'b100101
`define XOR		6'b100110
`define NOR		6'b100111

`define MULT	6'b011000
`define MULTU	6'b011001

`define MFHI	6'b010000
`define MFLO	6'b010010
`define MTHI	6'b010001
`define MTLO	6'b010011

`define	DIV		6'b011010
`define DIVU	6'b011011

`define SLL		6'b000000
`define SRL		6'b000010
`define SRA		6'b000011
`define SLLV	6'b000100
`define SRLV	6'b000110
`define SRAV	6'b000111

`define SLT		6'b101010
`define SLTU	6'b101011

// I TYPE OP
`define LUI		6'b001111

`define ADDI	6'b001000
`define ADDIU	6'b001001

`define ANDI	6'b001100

`define ORI		6'b001101
`define XORI	6'b001110

`define SLTI	6'b001010
`define SLTIU	6'b001011

// MEMORY INSTRUCTION
`define LW		6'b100011
`define SW		6'b101011
`define LB		6'b100000
`define LBU		6'b100100
`define LH		6'b100001
`define LHU		6'b100101
`define SB		6'b101000
`define SH		6'b101001

// BRANCH INSTRUCTION
`define BEQ		6'b000100	
`define BNE		6'b000101
`define BLEZ	6'b000110
`define BGTZ	6'b000111
`define BLTZ	6'b000001
`define BGEZ	6'b000001

// JUMP
`define J		6'b000010
`define JAL		6'b000011

`define JR		6'b001000
`define JALR	6'b001001

// Some macros are copied from AI...