

`timescale 1ns / 1ps  // Define time scale in the Verilog file


module bcd_to7seg #(parameter count_limit=4 ) (bcd_in,out);
	input [3:0] bcd_in;
	
	output [6:0] out;
	reg [6:0] out;
	
	
	
	always @* begin
		case(bcd_in)
		
			0: out = 7'h3F;
			1: out = 7'h06;
			2: out = 7'h5B;
			3: out = 7'h4F;
			4: out = 7'h66;
			5: out = 7'h6D;
			6: out = 7'h7D;
			7: out = 7'h07;
			8: out = 7'h7F;
			9: out = 7'h6F;
			
			default: out = 7'h00;
					

		endcase
		
		out = ~out;
		
	end
	
endmodule
	

