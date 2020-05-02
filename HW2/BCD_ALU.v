module BCD_ALU(input [1:0] OP, input [15:0] A, input [15:0] B, output [15:0] C);

reg [15: 0] ain, bin, cout;
reg [15: 0] comp;

always @(OP, A, B) begin
    ain = A[15-:4] * 1000 + A [11-:4] * 100 + A[7-:4] * 10 + A[3-:4];
    bin = B[15-:4] * 1000 + B [11-:4] * 100 + B[7-:4] * 10 + B[3-:4];
    comp = (9 - A[15-:4]) * 1000 + (9 - A[11-:4]) * 100 + (9 - A[7-:4]) * 10 + (9 - A[3-:4]);

    if (A[15-:4] > 9 || A[11-:4] > 9 || A[7-:4] > 9 || A[3-:4] > 9) cout = 16'hCCCC;
    else if (B[15-:4] > 9 || B[11-:4] > 9 || B[7-:4] > 9 || B[3-:4] > 9) cout = 16'hCCCC;
    else if (OP == 2'b00) cout  = ain + bin;
    else if (OP == 2'b01) cout = ain - bin;
    else if (OP == 2'b10) cout = comp;
    else if (OP == 2'b11) begin
	if (ain > bin) cout = 16'h0001;
	else if (ain < bin) cout = 16'hFFFF;
	else cout = 16'h0000;
    end
end

assign C = cout;

endmodule
