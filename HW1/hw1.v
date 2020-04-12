`timescale 1ns / 1ps // Define time tick unit.

module testbench;

	// Input signals
	reg [3:0] I;

	// Output signals
	wire [3:0] O;

	// Instantiate the Unit Under Test (UUT)
	comp2_4bit uut (.I(I), .O(O));

initial begin
    // Setup the signal dump file.
    $dumpfile("testbench.vcd"); // Set the name of the dump file.
    $dumpvars;                   // Save all signals to the dump file.

    // Display the signal values whenever there is a change.
    $monitor("I=%4b | O=%4b", I, O);

    // Initialize the input signals
    I = 0;

    // Change input signals; wait 20 time units for each change
    #20; I = 4'b0001;
    #20; I = 4'b0010;
    #20; I = 4'b0011;
    #20; I = 4'b0100;
    #20; I = 4'b0101;
    #20; I = 4'b0110;
    #20; I = 4'b0111;
    #20; I = 4'b1000;
    #20; I = 4'b1001;
    #20; I = 4'b1010;
    #20; I = 4'b1011;
    #20; I = 4'b1100;
    #20; I = 4'b1101;
    #20; I = 4'b1110;
    #20; I = 4'b1111;
    #20; $finish; // End the simulation.
end
endmodule

module comp2_4bit(input [3:0] I, output [3:0] O);
    assign O[0] = I[0] ^ 0;
    assign O[1] = I[1] ^ O[0];
    assign O[2] = I[2] ^ (O[1] | O[0]);
    assign O[3] = I[3] ^ (O[2] | (O[1] | O[0]));
endmodule
