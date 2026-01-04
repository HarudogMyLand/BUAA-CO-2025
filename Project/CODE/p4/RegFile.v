module RegFile (
    input           clk, reset,
    input           WE,
    input [31:0]    WD,
    input [4:0]     R1, R2, R3,
    input [31:0]    PC,
    output [31:0]   out1, out2
);

    reg [31:0] rf [0:31];
    integer i;

    // Initialization
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            rf[i] = 32'd0;
        end
    end

    // Register write operation
    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1) begin
                rf[i] = 32'd0;
            end
        end
        else if (WE && (R3 != 5'd0)) begin
            $display("@%h: $%d <= %h", PC, R3, WD);
            rf[R3] <= WD;
        end
    end

    assign out1 = (R1 == 5'd0) ? 32'd0 : rf[R1];
    assign out2 = (R2 == 5'd0) ? 32'd0 : rf[R2];

endmodule