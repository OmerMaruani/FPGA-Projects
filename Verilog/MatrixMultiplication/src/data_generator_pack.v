

`timescale 1ns / 1ps  // Define time scale in the Verilog file



`define ARRAY_SIZE 96

module data_generator_pack;

	//Define 96 bytes of data signed 8bit value
	reg signed [7:0] data_generator_array [`ARRAY_SIZE-1:0];
	
	//Initial the 2D ARRAY_SIZE
	initial begin
	
		data_generator_array = '{

		1,   2,   3,   4,
		5,   6,   7,   8,
		9,   10,  11,  12,
		13,  14,  15,  16,
		 
		17,  18,  19,  20,
		21,  22,  23,  24,
		25,  26,  27,  28,
		29,  30,  31,  32,
		
        4,   -38,   -13,   -32,
        62,   24,    30,    6,
        21,   -4,   -20,    53,
        43,   43,   -24,    35,

		28,    94,  113,   124,
		66,  -113,   68,   117,
		25,  -117,   38,    85,
		103, -19,   -82,   -38,

		-59,    52,    81,   107,
		-38,   -63,    34,  -110,
		13,    80,   -32,   -71,
		-12,   -48,   -72,     3,
		
		16,    -3,    31,  -112,
		14,   -81,   -80,  -96,
		50,   -75,    -8,   -13,
		-2,   -37,    38 ,  -31
		
	};
		 
	
	
	
	
	end
	
	
endmodule;
