`timescale 1ns/1ps
module Inner_Prod_tb;

real CYCLE=1000;

// Input signals
reg clk;
reg valid_in;
reg [7:0] A_input;
reg [7:0] B_input;
reg rst;
// Output signals
wire valid_out;
wire [18:0] C_out;

// other
reg [18:0] correct_data;
reg error_occur;
integer i;
reg [7:0] A_seq [0:7];
reg [7:0] B_seq [0:7];
// Instantiate the Unit Under Test (UUT)
Inner_Prod uut (
                .rst(rst),
                .clk(clk),
                .valid_in(valid_in),
                .A(A_input),
                .B(B_input),
                .valid_out(valid_out),
                .C(C_out));

initial clk = 0;
always #(CYCLE/2.0) clk = ~clk;

initial begin
    // Setup the signal dump file.
    $dumpfile("Inner_Prod.vcd"); // Set the name of the dump file.
    $dumpvars;                   // Save all signals to the dump file.

    // Display the signal values whenever there is a change.
    //$monitor("valid_in = %b,A = %d,B = %d,valid_out = %b,C = %d",
    //            valid_in, A_input, B_input, valid_out, C_out);

    // Initialize the input signals

    error_occur = 0;
    A_input = 0;
    B_input = 0;
    valid_in = 0;
    clk = 0;
    rst = 0;
    @(posedge clk); //Initialize reset
    #1; //Simulate flip-flop delay
    rst = 1;
    @(posedge clk); //Initialize reset
    #1; //Simulate flip-flop delay
    rst = 0;
    //valid_out and C should be zero after reset
    //You should make sure that when valid_out high , C contains correct data.

    if (valid_out !== 0) begin
        $display("Error: C or valid_out should be reset");
        error_occur = 1;
    end
    @(posedge clk);
    #1; //Simulate flip-flop delay

    // You can use for-loop or other way to create consecutive test case
    // Don't forget to add simulate flip-flop delay.
    testcase_generate;

    for (i = 0 ; i < 8 ; i = i + 1) begin
        @(posedge clk);
        #1; //Simulate flip-flop delay
        valid_in = 1;
        A_input = A_seq[i];
        B_input = B_seq[i];
    end
    @(posedge clk);
    #1; //Simulate flip-flop delay
    valid_in = 0;
    A_input = 0;
    B_input = 0;
    @(posedge clk);//It should take only one clock cycle to compute the inner-product and send the result to port C.
                   //Please write some testing code for this error case;
    #1; //Simulate flip-flop delay
    if (valid_out) begin
        if (C_out !== correct_data ) begin
            $display("Error:result failed");
            $display("Correct = %d , C = %d",correct_data,C_out);
            error_occur = 1;
        end
    end else begin
        $display("Error: no output");
        error_occur = 1;
    end

    @(posedge clk);//Raising the valid_out signal by "only" one clock cycle
                   //Please write some testing code for this error case;

    #1; //Simulate flip-flop delay
    if (error_occur === 0) begin
        $display("=========================");
        $display("Congratulations!!!");
        $display("=========================");
    end else begin
        $display("some error happened!!!");
    end
    @(posedge clk);
    $finish;
end



task testcase_generate; begin
    // You can try to use $random and for-loop to replace this section.

    A_seq[0] = 8'h01;
    B_seq[0] = 8'h3D;

    A_seq[1] = 8'hB2;
    B_seq[1] = 8'h15;

    A_seq[2] = 8'h31;
    B_seq[2] = 8'h99;

    A_seq[3] = 8'h15;
    B_seq[3] = 8'hA6;

    A_seq[4] = 8'hE3;
    B_seq[4] = 8'h72;

    A_seq[5] = 8'hD0;
    B_seq[5] = 8'h5B;

    A_seq[6] = 8'hFF;
    B_seq[6] = 8'h4E;

    A_seq[7] = 8'hCB;
    B_seq[7] = 8'h53;

    correct_data = 19'h17847;
end endtask
endmodule


module Inner_Prod(input clk,
		  input rst,
		  input valid_in,
		  input unsigned [7:0] A,
		  input unsigned [7:0] B,
		  output valid_out,
		  output unsigned [18:0] C);
    /* Implement your design here. */
    reg vout;
    reg unsigned [18:0] val, out;
    reg last_state;
    reg last_reset;

    always@(rst) begin
	if (~rst && last_reset) begin
	    vout <= 0;
	    out <= 0;
	    val <= 0;
	end
	last_reset <= rst;
    end

    always@(posedge clk) begin
	if (valid_in) val += A * B;
	if (last_state && ~valid_in) begin
	    vout <= 1;
	    out <= val;
	end
	if (~last_state && ~valid_in) begin
	    vout <= 0;
	    out <= 0;
	    val <= 0;
	end
	last_state = valid_in;
    end

    assign valid_out = vout;
    assign C = out;

endmodule
