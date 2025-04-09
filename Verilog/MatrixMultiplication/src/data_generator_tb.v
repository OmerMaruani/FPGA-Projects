

`timescale 1ns / 1ps  // Define time scale in the Verilog file
`define CLK_PER 5


module data_generator_tb;



	// Declare testbench signals (inputs and outputs)
	reg clk;
	reg rst_n;
	reg data_request;
	
	wire [7:0] dout;
	wire dout_valid;
	

	
	// Instantiate the and_gate module (DUT)
	data_generator #(8) dut(.clk(clk),.rst_n(rst_n),.data_request(data_request),.dout(dout),.dout_valid(dout_valid));

	
	
	// Stimulus generation: Apply test vectors
	initial begin
		
		
		// Initialiaze the signals
		clk  = 0;
		rst_n = 1;
		data_request = 0;
		
		
		
		
		
		
		// Display headers for simulation outputs
		//$display("Time\t clk\t nrst\t en\t out\t");
		
		// Monitor every change of the signals
        //$monitor("Time = %0t, bin_in = %d, bcd_out = %b", $time,bin_in, bcd_out);




		// Apply input combinations
		
		//#30; bin_in = 12623;
		
		
		#250; data_request = 1;
		#10; data_request =0;
		
		#250; data_request = 1;
		#10; data_request =0;
		
		#10; rst_n = 0;
		#100; rst_n = 1;
		
		#250; data_request = 1;
		#10; data_request =0;
		

		
	
		
		
	
		
	
	end
	
	
	
	always begin
		#(`CLK_PER) clk = ~clk;
	end
		
		
	
endmodule