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
