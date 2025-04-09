

`timescale 1ns / 1ps  // Define time scale in the Verilog file


module direction #(parameter N=8) (l_rn,d_in);
	input [N-1:0] d_in;
	output l_rn;
	reg l_rn;
	
	
	always @(*)
	if( d_in[N-1] == 1)
		l_rn = 0;
	else if(d_in[0] == 1)
		l_rn= 1;
		
	
endmodule
	

