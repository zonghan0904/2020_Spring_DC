module BCD_ALU_tb;

// Input signals
reg [1:0] op_in;
reg [15:0] a_in,b_in;


// Output signals
wire [15:0] c_out;

integer i;
// Instantiate the Unit Under Test (UUT)
BCD_ALU uut (.OP(op_in), .A(a_in), .B(b_in), .C(c_out));


initial begin
    // Setup the signal dump file.
    $dumpfile("BCD_ALU.vcd"); // Set the name of the dump file.
    $dumpvars;                   // Save all signals to the dump file.

    // Display the signal values whenever there is a change.
    //$monitor("OP=%h, A=%h, B=%h, C=%h", op_in, a_in, b_in, c_out);

    // Initialize the input signals
    #10
    op_in = 2'b00;
    a_in = 16'h0006;
    b_in = 16'h0063;

    #10
    if(c_out !== 16'd0069)begin//'d means decimal
        error_display;
    end

    #10
    op_in = 2'b01;
    a_in = 16'h0007;
    b_in = 16'h0023;

    #10
    if(c_out !== 16'hFFF0)begin//'h means hex
        error_display;
    end
    #10

    op_in = 2'b10;
    a_in = 16'h0013;
    b_in = 16'h0023;

    #10
    if(c_out !== 16'd9986)begin
        error_display;
    end
    #10

    op_in = 2'b11;
    a_in = 16'h0651;
    b_in = 16'h0650;

    #10
    if(c_out !== 16'h0001)begin
        error_display;
    end
    #10

    a_in = 16'h0651;
    b_in = 16'h0651;

    #10
    if(c_out !== 16'h0000)begin
        error_display;
    end
    #10

    a_in = 16'h0651;
    b_in = 16'h0652;

    #10
    if(c_out !== 16'hFFFF)begin
        error_display;
    end
    #10

    $display ("--------------------------------------------------------------------");
    $display ("                         Congratulations!                           ");
    $display ("                  You have passed all patterns!                     ");
    $display ("--------------------------------------------------------------------");
    $finish;
end

task error_display; begin
    $display ("----------------------------------------------------------------------");
    $display ("             FAIL!                                                ");
    $display ("             tb_input: OP=%h, A=h'%h, B=h'%h                           ",op_in, a_in, b_in);//show input
    $display ("             Your output: C=h'%h                                ",c_out);//show output
    $display ("----------------------------------------------------------------------");

    $finish;
end endtask
endmodule

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


