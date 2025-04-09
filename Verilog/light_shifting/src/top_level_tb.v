

`timescale 1ns / 1ps  // Define time scale in the Verilog file
`define CLK_PER 5

`define N_BITS 16	

module top_level_tb;



	// Declare testbench signals (inputs and outputs)
	reg clk;
	reg rate;
	reg nrst;
	wire [`N_BITS-1:0] out;
	

	
	// Instantiate the and_gate module (DUT)
	top_level #(`N_BITS) dut (.out(out),.clk(clk),.rate(rate),.nrst(nrst));

	
	
	// Stimulus generation: Apply test vectors
	initial begin
		
		
		// Initialiaze the signal
		clk = 0;
		nrst =1;
		rate =1;
		
		
		
		
		// Display headers for simulation outputs
		$display("Time\t clk\t nrst\t en\t out\t");
		
		// Monitor every change of the signals
        $monitor("Time = %0t, rate = %b, out= %b", $time,rate, out);



	

		// Apply input combinations
		#10; nrst = 0;
		#10; nrst = 1;

		#10; rate = 1;
		#50; rate = 0;
		
		
	
		
	
	end
	
	
	
	
	always begin
		#(`CLK_PER) clk = ~clk;
	end
		
	
		
	
endmodule