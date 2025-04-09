

`timescale 1ns / 1ps  // Define time scale in the Verilog file


module sync #(parameter sig_active = 0 ) (clk,rst_n,signal,out);
	input clk;
	input rst_n;
	input signal;
	
	output out;
	reg out;
	
	
	reg cur_out = 0;

	always @(posedge clk or negedge rst_n) begin
	
		if (!rst_n) begin 
			out <= 0;
			cur_out <=0;
			
		end
		
		else begin
			
			if(signal == !sig_active) cur_out <= 1;
			else cur_out <= 0;

			
			if(signal == sig_active && cur_out == 1 ) out <= 1;
			else out <= 0;
			
		end
		
		
		
		
	end
	
endmodule
	

