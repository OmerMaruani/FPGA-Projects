

`timescale 1ns / 1ps  // Define time scale in the Verilog file
`define CLK_PER 0.2


module counter_tb;



	// Declare testbench signals (inputs and outputs)

	reg clk;
	reg nrst;
	reg clear;
	reg ena;
	reg oen;
	
	wire  [3:0] sec_tens;
	wire  [3:0] sec_ones;
	wire  [3:0] hund_tens;
	wire  [3:0] hund_ones;

	

	
	// Instantiate the and_gate module (DUT)
	
	counter #(10) dut(.sec_tens(sec_tens),.sec_ones(sec_ones),.hund_tens(hund_tens),.hund_ones(hund_ones),
	.clk(clk),.nrst(nrst),.clear(clear),.ena(ena),.oen(oen));

	
	// Stimulus generation: Apply test vectors
	initial begin
		
		
		// Initialiaze the signals
		clk  = 0;
		nrst = 1;
		clear =  0;
		ena = 1;
		oen = 0;
		
		
		
		
		
		// Display headers for simulation outputs
		$display("Time\t clk\t nrst\t en\t out\t");
		
		// Monitor every change of the signals
        $monitor("Time = %0t, clk = %b, nrst = %b", $time, clk,nrst);



	

		// Apply input combinations
		#50; nrst = 0;
		#50; nrst = 1;
		
		#50; clear = 1;
		#50; clear = 0;
		
		#50; ena = 0;
		#50; ena = 1;
		
		#50; oen = 1;
		#50; oen = 0;
		
		

	
	end
	
	
	
	always begin
		#(`CLK_PER) clk = ~clk;
	end
		
		
	
endmodule