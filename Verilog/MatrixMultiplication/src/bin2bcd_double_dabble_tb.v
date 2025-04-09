

`timescale 1ns / 1ps  // Define time scale in the Verilog file
`define CLK_PER 10


module bin2bcd_double_dabble_tb;



	// Declare testbench signals (inputs and outputs)

	reg [15:0] bin_in;
	reg clk;
	
	wire [19:0] bcd_out;
	
	

	

	
	// Instantiate the and_gate module (DUT)
	bin2bcd_double_dabble #(16) dut(.bin_in(bin_in),.clk(clk),.bcd_out(bcd_out)	);

	
	
	// Stimulus generation: Apply test vectors
	initial begin
		
		
		// Initialiaze the signals
		clk  = 0;
		bin_in = 23456;
		
		
		
		
		// Display headers for simulation outputs
		$display("Time\t clk\t nrst\t en\t out\t");
		
		// Monitor every change of the signals
        $monitor("Time = %0t, bin_in = %d, bcd_out = %b", $time,bin_in, bcd_out);




		// Apply input combinations
		
		#30; bin_in = 12623;
		
	
		
		
	
		
	
	end
	
	
	
	always begin
		#(`CLK_PER) clk = ~clk;
	end
		
		
	
endmodule