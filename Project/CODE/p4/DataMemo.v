module DataMemo (
    input clk, reset,
    input WE,
    input [31:0] data,
    input [31:0] addr,
    input [31:0] PC,
    output[31:0] out
); 
    reg [31:0] memo [0:3071];
    integer i;
    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i <= 3071; i = i + 1) begin
                memo[i] = 0;
            end
        end
        else begin
            if (WE) begin
                $display("@%h: *%h <= %h", PC, addr << 2, data);
                memo[addr] <= data;
            end    
        end
    end

    assign out = memo[addr];
endmodule