

`timescale 1ns / 1ps  // Define time scale in the Verilog file


module counter #(parameter n = 1 ) (sec_tens,sec_ones,hund_tens,hund_ones,
											,clk,rst_n,clear,ena,oen);
											
	input clk;
	input rst_n;
	input clear;
	input ena;
	input oen;
	
	output reg [3:0] sec_tens;
	output reg [3:0] sec_ones;
	output reg [3:0] hund_tens;
	output reg [3:0] hund_ones;

	
	
	
	reg [31:0] count = 0;
	
	//ena = 1 counter run, ena = 0 counter hold
	//clear = 1 asyn clear
	//oen = 0 reflect the current value, oen = 1 reflect the last value, counter keep count

	
	always @(posedge clk or negedge rst_n) begin
	
		if (!rst_n) begin
			count <= 0;
			hund_ones <= 4'b0000;
			hund_tens <= 4'b0000;
			sec_ones<= 4'b0000;
			sec_tens<= 4'b0000;
			
		end else if(clear) begin
			count <= 0;
			hund_ones <= 4'b0000;
			hund_tens <= 4'b0000;
			sec_ones<= 4'b0000;
			sec_tens<= 4'b0000;
			
			
		end else if(ena == 1'b1) begin
		
			count <= count + 1;
			
			
			if( oen == 1'b0) begin
			
				hund_ones <= (count %10);
				hund_tens <= (count/10)%10;
				sec_ones <= (count/100)%10;
				sec_tens <= (count/1000)%10;
						
				if(count == 6000) begin
					count <= 0;
				end
	
			end
				
		end
		
		
	end
	
endmodule
	

