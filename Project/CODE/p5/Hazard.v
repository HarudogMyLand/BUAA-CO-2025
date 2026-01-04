`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:48:28 11/13/2025 
// Design Name: 
// Module Name:    Hazard 
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
module Hazard (
    input clk, 
    input reset,

    // D Stage
    input  [4:0]  a_R1_D, a_R2_D,
    input  [31:0] v_R1_D, v_R2_D,
    input  h_D1, h_D2,

    // E Stage
    input  [4:0]  a_R1_E, a_R2_E,
    input  [31:0] v_R1_E, v_R2_E,
    input  h_E1, h_E2,

    // MStage
    input  [4:0]  a_R2_M, 
    input  [31:0] v_R2_M,

    // Writeback Destination Signals
    input  [4:0]  a_WB_E,              
    input  [31:0] v_WB_E,

    // M -> WB
    input  [4:0]  a_WB_M,        
    input  [31:0] v_WB_M,    

    // W -> Final Write
    input  [4:0]  a_WB_W,
    input  [31:0] v_WB_W,

    // Control Outputs
    output h_stall_I,                 
    output h_stall_ID,                 
    output h_stall_DE,                 
    output h_flush_DE,                 
    output h_flush_EM,                 

    // Data Forwarding
    output [31:0] hv_fwd_D1, hv_fwd_D2,
    output [31:0] hv_fwd_E1, hv_fwd_E2,
    output [31:0] hv_fwd_M
);

    // Nothing currently here.
    reg [4:0]   a_W;
    reg [31:0]  v_W;

    initial {a_W, v_W} <= 0;

    always @(posedge clk) begin
        if (reset) {a_W, v_W} <= 0;
        else {a_W, v_W} <= {a_WB_W, v_WB_W};
    end

    wire h_stall_D, h_stall_E;

    assign h_stall_D = 
    (
        (h_D1 && a_R1_D == a_WB_E && a_WB_E != 0 && v_WB_E === 32'bz) ||
        (h_D1 && a_R1_D == a_WB_M && a_WB_M != 0 && v_WB_M === 32'bz && !(a_R1_D == a_WB_E && a_WB_E != 0 && v_WB_E !== 32'bz))
    ) ||
    (
        (h_D2 && a_R2_D == a_WB_E && a_WB_E != 0 && v_WB_E === 32'bz) ||
        (h_D2 && a_R2_D == a_WB_M && a_WB_M != 0 && v_WB_M === 32'bz && !(a_R2_D == a_WB_E && a_WB_E != 0 && v_WB_E !== 32'bz))
    ) & ~h_stall_E// ||
    //(
        // for other stall d signal
    //)
    ;
    assign h_stall_E =  (h_E1 && a_R1_E == a_WB_M && a_WB_M != 0 && v_WB_M === 32'bz) ||
                        (h_E2 && a_R2_E == a_WB_M && a_WB_M != 0 && v_WB_M === 32'bz);

    assign h_stall_I =  h_stall_D || h_stall_E;
    assign h_stall_ID = h_stall_D || h_stall_E;
    assign h_stall_DE = h_stall_E;

    assign h_flush_DE = h_stall_D;
    assign h_flush_EM = h_stall_E;

    assign hv_fwd_D1 =	(a_R1_D == a_WB_E && a_WB_E != 0)? v_WB_E :
					    (a_R1_D == a_WB_M && a_WB_M != 0)? v_WB_M :
					    v_R1_D;
	assign hv_fwd_D2 =	(a_R2_D == a_WB_E && a_WB_E != 0)? v_WB_E :
					    (a_R2_D == a_WB_M && a_WB_M != 0)? v_WB_M :
					    v_R2_D;

    assign hv_fwd_E1 =	(a_R1_E == a_WB_M && a_WB_M != 0)? v_WB_M :
					    (a_R1_E == a_WB_W && a_WB_W != 0)? v_WB_W :
                        (a_R1_E == a_W && a_W != 0)? v_W :
					    v_R1_E;
	assign hv_fwd_E2 =	(a_R2_E == a_WB_M && a_WB_M != 0)? v_WB_M :
					    (a_R2_E == a_WB_W && a_WB_W != 0)? v_WB_W :
                        (a_R2_E == a_W && a_W != 0)? v_W :
					    v_R2_E;

    assign hv_fwd_M  = (a_R2_M == a_WB_W && a_WB_W != 0) ? v_WB_W : v_R2_M;
endmodule
