

`timescale 1ns / 1ps  // Define time scale in the Verilog file


module pulse_generator #(parameter count_limit=4) (out,clk,nrst,rate);
	input clk;
	input nrst;
	input rate;
	output out;
	reg out;
	
	reg [31:0] count;
	
	always @(posedge clk or negedge nrst) begin
		if (!nrst) begin
			count <= 0;
			out <= #1 0;
		end else begin
			
			count <= count +  1;
			if ((rate == 1'b0 && count >= count_limit) || 
				(rate == 1'b1 && count >= count_limit*2) ) begin
				count <= 0;
				out <= #1 1;
			end else
				out <= #1 0;
			
		end
		
	end
	
endmodule
	
