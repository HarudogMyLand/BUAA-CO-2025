`timescale 1ns / 1ps
`include "macros.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:54:57 11/13/2025 
// Design Name: 
// Module Name:    Controller 
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
module Controller(
		input [31:0] instr,
		input [31:0] addr_M,
		// CMP signal
		input c_eq, c_eqz, c_ltz,

		// Output
		// Decode Stage
		output 			c_signExt,

		output 			c_branch, 
		output 			c_j, 
		output 			c_jr,

		output 			c_selWD_D,
		output [4:0] 	a_WB_D,
		output 			c_MD,

		// Execute Stage
		output [3:0] 	c_ALU_op,
		output [1:0] 	c_selWD_E,
		output 			c_ALU_in1, c_ALU_in2,

		output 			start,
		output			c_HIWE, c_LOWE,
		output [2:0]	MDUop,
		// Memory Stage
		output 			c_memWE,
		output reg[3:0]	c_byte,
		output [2:0]	c_loadSign,
		output 			c_selWD_M,
		output [2:0]	c_storeSign,

		// Hazard Signals
		output 			h_D1, h_D2,
		output 			h_E1, h_E2,
		output 			h_M2
    );
	
	wire [5:0] op, funct, rt;

	assign op 		= instr[`op];
	assign funct	= instr[`funct];
	assign rt 		= instr[`rt];

	// Instruction definition

	wire add, sub, and_, or_, slt, sltu;
	wire addi, andi, ori, lui;
	wire lb, lh, lw, sb, sh, sw;
	wire mult, multu, div, divu, mfhi, mflo, mthi, mtlo;
	wire beq, bne, jal, jr;

	assign add 	= (op == `R) & (funct == `ADD);
	assign sub 	= (op == `R) & (funct == `SUB);
	assign and_	= (op == `R) & (funct == `AND);
	assign or_ 	= (op == `R) & (funct == `OR);
	assign slt 	= (op == `R) & (funct == `SLT);
	assign sltu	= (op == `R) & (funct == `SLTU);
	
	assign addi = (op == `ADDI);
	assign andi = (op == `ANDI);
	assign ori  = (op == `ORI);
	assign lui  = (op == `LUI);

	assign lb 	= (op == `LB);
	assign lh   = (op == `LH);
	assign lw	= (op == `LW);
	assign sb   = (op == `SB);
	assign sh 	= (op == `SH);
	assign sw 	= (op == `SW);

	assign mult = (op == `R) & (funct == `MULT);
	assign multu= (op == `R) & (funct == `MULTU); 

	assign div  = (op == `R) & (funct == `DIV);
	assign divu = (op == `R) & (funct == `DIVU);

	assign mfhi = (op == `R) & (funct == `MFHI);
	assign mflo = (op == `R) & (funct == `MFLO);

	assign mthi = (op == `R) & (funct == `MTHI);
	assign mtlo = (op == `R) & (funct == `MTLO);

	assign beq = (op == `BEQ);
	assign bne = (op == `BNE);
	assign jal = (op == `JAL);
	assign jr  = (op == `R) & (funct == `JR);

// Control signals

//// D stage
	assign c_signExt 	= 	lw | lb | lh | sw | sb | sh |
							addi | beq | bne;
	assign c_branch		= 	(beq & c_eq) | (bne & ~c_eq);
	assign c_j 			= 	jal;
	assign c_jr 			= 	jr;

	assign c_selWD_D	= 	jal; // if 1, write data would be PC, else zzzz

	assign a_WB_D = (jal)                            			? 5'd31 :         // link to $ra
						(lui | andi | ori | addi | lw | lb | lh) 	? instr[`rt] : // write to rt
						(add | sub | and_ | or_ | sltu | slt | mfhi | mflo) ? instr[`rd] :
						0;
	assign c_MD 		= 	mult | multu | div | divu | mfhi | mflo | mthi | mtlo;


//// E stage
	assign c_ALU_op = 	(add | addi)  ?		4'b0000 : 
						(sub) 		  ?		4'b0001 :
						(and_ | andi) ?		4'b0010 :
						(or_  | ori)  ?		4'b0011 :
						(lui) 		  ?		4'b0100 :
						(slt)		  ?		4'b0101 :
						(sltu)		  ? 	4'b0110 :
						4'b0000;
	assign c_ALU_in1 = 0; 
	// if 1, use shamt
	assign c_ALU_in2 = 	andi | ori | lui | lw | lb | lh | sw | sb | sh |addi;
	// if 1, use imm32

	// MDU signal
	assign start 	= 	mult | multu | div | divu;
	assign MDUop 	= 	multu ? 3'b000 :
						mult  ? 3'b001 :
						divu  ? 3'b010 :
						div   ? 3'b011 :
						3'b000;

	assign c_HIWE	= mthi;
	assign c_LOWE	= mtlo;
	assign c_selWD_E= 	mflo ? 2'b11 :
						mfhi ? 2'b10 :
						(add | sub | andi | ori | lui |
						and_ | or_ | addi | slt | sltu) ? 2'b01 :
						2'b00;

//// M Stage
	assign c_memWE		= sw | sh | sb;
	assign c_loadSign 	= 	(lh) ? 3'b001 : // sign extend half 
							(lb) ? 3'b010 : // sign extend byte 
							3'b000;			// no extend 
	assign c_storeSign 	= 	(sh) ? 3'b001 : // 
							(sb) ? 3'b010 : // 
							(sw) ? 3'b011 :
							3'b000;			// no extend 
	assign c_selWD_M 	= lw | lb | lh;

	always @(*) begin
	    if (sw) begin
			c_byte = 4'b1111;
		end
		else if (sh) begin
			casez(addr_M[1:0])
				2'b0? : c_byte = 4'b0011;
				2'b1? : c_byte = 4'b1100;
			endcase
		end
		else if (sb) begin
			case(addr_M[1:0])
				2'b00: c_byte = 4'b0001;
				2'b01: c_byte = 4'b0010;
				2'b10: c_byte = 4'b0100;
				2'b11: c_byte = 4'b1000;
			endcase
		end
		else
			c_byte = 4'b0000;
	end	

//// Hazard Signal
	assign h_D1 = jr | beq | bne;
	assign h_D2 = beq | bne;

	assign h_E1 = 	add | sub | ori | andi | and_| or_ |
					addi | lw | lb | lh | sw | sb | sh |
					slt | sltu | mult | multu | div | divu | mthi | mtlo;
	assign h_E2 =	add | sub | or_ | and_ | slt | sltu| 
					mult | multu | div | divu;

	assign h_M2 = sw | sh | sb;
endmodule
