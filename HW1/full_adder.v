`timescale 1ns / 1ps // Define time tick unit.

module full_adder_tb;

	// Input signals
	reg A, B;
	reg Cin;         // Carry in

	// Output signals
	wire Sum;
	wire Cout;       // Carry out

	// Instantiate the Unit Under Test (UUT)
	fa_1bit uut (.A_i(A), .B_i(B), .C_i(Cin), .S_o(Sum), .C_o(Cout));

initial begin
    // Setup the signal dump file.
    $dumpfile("full_adder.vcd"); // Set the name of the dump file.
    $dumpvars;                   // Save all signals to the dump file.

    // Display the signal values whenever there is a change.
    $monitor("A=%b, B=%b Cin=%b | Cout=%b Sum=%b", A, B, Cin, Cout, Sum);

    // Initialize the input signals
    A = 0; B = 0; Cin = 0;

    // Change input signals; wait 20 time units for each change
    #20; A = 1'b0; B = 1'b1; Cin = 1'b0;
    #20; A = 1'b1; B = 1'b0; Cin = 1'b1;
    #20; A = 1'b1; B = 1'b1; Cin = 1'b1;
    #20; $finish; // End the simulation.
end
endmodule

module fa_1bit(input A_i, input B_i, input C_i, output S_o, output C_o);
  assign S_o = C_i ^ A_i ^ B_i;
  assign C_o = (A_i & B_i) | (C_i & B_i) | (C_i & A_i);
endmodule
