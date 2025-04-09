

`timescale 1ns / 1ps  // Define time scale in the Verilog file

`define PULSE_PER_CLOCKS 5000000  // Define the constant value


module top_level #(parameter N = 8) (out,clk,rate,nrst);
	input clk;
	input rate;
	input nrst;
	output [N-1:0] out;
	
	
	
	wire new_clk;
	wire l_rn;
	
	
	
	pulse_generator #(`PULSE_PER_CLOCKS) pulse(.out(new_clk),.clk(clk),.nrst(nrst),.rate(rate) );
	shift_reg #(N) shift(.out(out),.clk(new_clk),.nrst(nrst),.ena(1'b1),.l_rn(l_rn) );
	direction #(N) dir(.l_rn(l_rn),.d_in(out));

	
endmodule
	


