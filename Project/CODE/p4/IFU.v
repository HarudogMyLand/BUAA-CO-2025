module IFU (
    input clk, reset,
    input [31:0] NPC,
    output reg [31:0] instr,
    output reg [31:0] PC
);
// counter
    reg [31:0] counter;

    initial counter <= 0;

    always @(posedge clk) begin
        if (reset) counter <= 0;
        else counter <= NPC - 32'h00003000;
    end

    always @(*) begin
        PC = counter + 32'h00003000;
    end
    
// IM
    reg [31:0] IM [0:4095];

    initial begin
        $readmemh("code.txt", IM); 
    end

    wire [11:0] curPC = counter[13:2];

    always @(*) begin
        instr = IM[curPC];
    end

endmodule