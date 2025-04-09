

`timescale 1ns / 1ps  // Define time scale in the Verilog file


module bin2bcd_double_dabble #(parameter N_BITS =16 ) (bin_in,clk,bcd_out);

	input [N_BITS-1:0] bin_in;
	input clk;
	
	output [19:0] bcd_out;
	reg [19:0] bcd_out;
	

	//signals
	integer i;
	reg [N_BITS-1:0] shift_reg;
	reg [19:0] bcd_reg;
	

	
	always @(bin_in) begin
		
		shift_reg = bin_in;
		bcd_reg = 0;
		
		for(i = 0; i < N_BITS; i = i + 1) begin
	
			if(bcd_reg[3:0] > 4) bcd_reg[3:0] = bcd_reg[3:0] + 3;
			if(bcd_reg[7:4] > 4) bcd_reg[7:4] = bcd_reg[7:4] + 3;
			if(bcd_reg[11:8] > 4) bcd_reg[11:8] = bcd_reg[11:8] + 3;
			if(bcd_reg[15:12] > 4) bcd_reg[15:12]= bcd_reg[15:12] + 3;
	

			bcd_reg = bcd_reg << 1;
			bcd_reg[0] = shift_reg[N_BITS-1];
			shift_reg = shift_reg << 1;
		end
		
		
		
	end	
		
	always @(posedge clk) begin
	
		bcd_out <= bcd_reg;
		
	end
		
		
endmodule
	

