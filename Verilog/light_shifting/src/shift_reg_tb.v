

`timescale 1ns / 1ps  // Define time scale in the Verilog file
`define CLK_PER 10


module shift_reg_tb;



	// Declare testbench signals (inputs and outputs)
	reg clk;
	reg nrst;
	reg ena;
	reg l_rn;
	
	wire [7:0] out ;

	

	
	// Instantiate the and_gate module (DUT)
	shift_reg #(8) dut(.out(out),.clk(clk),.nrst(nrst),.ena(ena),.l_rn(l_rn) );

	
	
	// Stimulus generation: Apply test vectors
	initial begin
		
		
		// Initialiaze the signals
		clk  = 0;
		nrst = 1;
		ena =  1;
		l_rn = 1;
		
		
		
		
		
		// Display headers for simulation outputs
		$display("Time\t clk\t nrst\t en\t out\t");
		
		// Monitor every change of the signals
        $monitor("Time = %0t, clk = %b, nrst = %b, out = %b", $time, clk,nrst, out);



	

		// Apply input combinations
		#10; nrst = 0;
		#10; nrst = 1;
		#10; ena = 0;
		#40; ena= 1;
		#10; l_rn= 0;
		#20; l_rn= 1;
		
		
	
		
	
	end
	
	
	
	always begin
		#(5) clk = ~clk;
	end
		
		
	
endmodule