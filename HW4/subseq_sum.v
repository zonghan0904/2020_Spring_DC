module subseq_sum(input clk,
	          input rst,
		  input valid_in,
		  input signed [7:0] data_in,
		  output valid_out,
		  output unsigned [11:0] max_sum);

    /* Implement your design here. */

    parameter IDLE  = 3'b000;
    parameter READ  = 3'b001;
    parameter INIT  = 3'b010;
    parameter STEP3 = 3'b011;
    parameter STEP4 = 3'b100;
    parameter STEP5 = 3'b101;
    parameter STEP6 = 3'b110;
    parameter OUTP  = 3'b111;

    reg [2:0] curr_state;
    reg [2:0] next_state;
    reg _rst;
    reg vout;
    reg signed [7:0] data_array [0:7];
    reg signed [11:0] m_sum;
    reg signed [11:0] sum;
    reg signed [11:0] p_sum;
    reg [3:0] count, i;

    always@(posedge clk) begin
	if (~_rst && rst) begin
	    curr_state <= IDLE;
	end
	else curr_state <= next_state;
	_rst <= rst;
    end

    always@(*) begin
	case(curr_state)
	    IDLE    : if (valid_in) next_state = READ;
		      else begin
			count = 0;
			if (_rst) begin
			    vout = 0;
			    m_sum = 0;
			end
			else if (vout) begin
			    vout = 0;
			    m_sum = 0;
			end
			next_state = IDLE;
		      end
	    READ    : if (count < 8) begin
			data_array[count] = data_in;
			count = count + 1;
			next_state = READ;
		      end
		      else next_state = INIT;
	    INIT    : begin
			i = 0;
			p_sum = 0;
			sum = 0;
			next_state = STEP3;
		      end
	    STEP3   : begin
			p_sum = p_sum + data_array[i];
			next_state = STEP4;
		      end
	    STEP4   : begin
			if (p_sum < 0) p_sum = 0;
			next_state = STEP5;
		      end
	    STEP5   : begin
			if (sum < p_sum) sum = p_sum;
			next_state = STEP6;
		      end
	    STEP6   : begin
			if (i < 8) begin
			    i = i + 1;
			    next_state = STEP3;
			end
			else next_state = OUTP;
		      end
	    OUTP    : begin
			vout = 1;
			m_sum = sum;
			next_state = IDLE;
		      end
	    default : next_state = IDLE;
	endcase

    end

    assign valid_out = vout;
    assign max_sum = m_sum;

endmodule
