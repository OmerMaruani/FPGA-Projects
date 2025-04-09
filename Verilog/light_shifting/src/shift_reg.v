

`timescale 1ns / 1ps  // Define time scale in the Verilog file


module shift_reg #(parameter N=8) (out,clk,nrst,ena,l_rn);
	input clk;
	input nrst;
	input ena;
	input l_rn;
	output [N-1:0] out;
	reg [N-1:0] out;
	

	always @(posedge clk or negedge nrst) begin
		if (!nrst)
			out <= #1 1;
		else if(ena) begin
		
			if(l_rn)
				out <= out << 1;
			else
				out <= out >> 1;
		end
		
	end
	
endmodule
	

