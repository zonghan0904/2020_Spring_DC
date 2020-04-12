module comp2_4bit(input [3:0] I, output [3:0] O);
    assign O[0] = I[0] ^ 0;
    assign O[1] = I[1] ^ O[0];
    assign O[2] = I[2] ^ (O[1] | O[0]);
    assign O[3] = I[3] ^ (O[2] | (O[1] | O[0]));
endmodule
