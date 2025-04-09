

`timescale 1ns / 1ps  // Define time scale in the Verilog file
`define CLK_PER 10


module direction_tb;



	// Declare testbench signals (inputs and outputs)
	reg [7:0] d_in;	
	wire l_rn ;

	

	
	// Instantiate the and_gate module (DUT)
	direction #(8) dut(.l_rn(l_rn),.d_in(d_in));

	
	
	// Stimulus generation: Apply test vectors
	initial begin
		
		
		// Initialiaze the signal
		d_in = 0;
		
		
		
		
		
		// Display headers for simulation outputs
		$display("Time\t clk\t nrst\t en\t out\t");
		
		// Monitor every change of the signals
        $monitor("Time = %0t, d_in = %b, l_rn = %b", $time,d_in, l_rn);



	

		// Apply input combinations
		#10; d_in = 8'b1000_0000;
		#10; d_in = 8'b0000_1000;
		#10; d_in = 8'b0000_0001;
	
		
	
		
	
	end
	
	
	
	
		
	
endmodule