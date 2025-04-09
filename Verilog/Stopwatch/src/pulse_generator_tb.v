

`timescale 1ns / 1ps  // Define time scale in the Verilog file
`define CLK_PER 2


module pulse_generator_tb;



	// Declare testbench signals (inputs and outputs)
	reg clk;
	reg nrst;
	reg clear;
	reg ena;
	wire out;

	

	
	// Instantiate the and_gate module (DUT)
	pulse_generator #(10) dut(.out(out),.clk(clk),.nrst(nrst),.clear(clear), .ena(ena) );


	
	// Stimulus generation: Apply test vectors
	initial begin
		
		
		// Initialiaze the signals
		clk  = 0;
		nrst = 1;
		clear =  0;
		ena = 1;
		
		
		
		
		
		// Display headers for simulation outputs
		$display("Time\t clk\t nrst\t en\t out\t");
		
		// Monitor every change of the signals
        $monitor("Time = %0t, clk = %b, nrst = %b, out = %b", $time, clk,nrst, out);



	

		// Apply input combinations
		#50; nrst = 0;
		#50; nrst = 1;
		
		#50; clear = 1;
		#50; clear = 0;
		
		#50; ena = 0;
		#50; ena = 1;
		
		
	
		
	
	end
	
	
	
	always begin
		#(`CLK_PER) clk = ~clk;
	end
		
		
	
endmodule