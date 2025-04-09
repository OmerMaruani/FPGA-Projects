

`timescale 1ns / 1ps  // Define time scale in the Verilog file
`define CLK_PER 2


module sync_tb;



	// Declare testbench signals (inputs and outputs)
	reg clk;
	reg rst_n;
	reg signal;
	
	wire out;

	

	
	// Instantiate the and_gate module (DUT)
	sync #(0) dut(.clk(clk),.rst_n(rst_n),.signal(signal), .out(out) );


	
	// Stimulus generation: Apply test vectors
	initial begin
		
		
		// Initialiaze the signals
		clk  = 0;
		rst_n = 1;
		signal =  0;
		
		
		
		
		
		
		// Display headers for simulation outputs
		$display("Time\t clk\t rst_n\t en\t out\t");
		
		// Monitor every change of the signals
        $monitor("Time = %0t, clk = %b, rst_n = %b, out = %b", $time, clk,rst_n, out);



	

		// Apply input combinations
		#50; rst_n = 0;
		#50; rst_n = 1;
		
		#50; signal = 0;
		#50; signal = 1;
		#50; signal = 0;
		
		
		
	
		
	
	end
	
	
	
	always begin
		#(`CLK_PER) clk = ~clk;
	end
		
		
	
endmodule