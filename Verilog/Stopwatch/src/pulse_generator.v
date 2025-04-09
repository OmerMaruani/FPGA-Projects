

`timescale 1ns / 1ps  // Define time scale in the Verilog file


module pulse_generator #(parameter count_limit=4 ) (out,clk,rst_n,clear,ena);
	input clk;
	input rst_n;
	input clear;
	input ena;
	
	output out;
	reg out;
	
	reg [31:0] count = 0;
	
//	initial begin
//		count <= 0
	//end
	
	always @(posedge clk or negedge rst_n) begin
	
		if (!rst_n) begin
			count <= 0;
			out<=  0;
			
		end else if(clear) begin
			count <=0;
			out<=0;

			
		end else if(ena) begin
			count <=  count + 1;
			
			if(count == count_limit) begin
				out <= 1'b1;
				count <= 0;
			end else begin
				out <= 1'b0;
			end
				
		end
		
		
	end
	
endmodule
	

