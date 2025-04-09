

`timescale 1ns / 1ps  // Define time scale in the Verilog file
`define CLK_PER 5

`define N_BITS 16	

module stop_watch_tb;



	// Declare testbench signals (inputs and outputs)
	reg clk;
	reg rst_n;
	
	reg sw_start_stop;
	reg sw_clear;
	reg sw_lap;
	
	wire [6:0] sec_tens_7seg;
	wire [6:0] sec_ones_7seg;
	wire [6:0] hund_tens_7seg;
	wire [6:0] hund_ones_7seg;

	
	// Instantiate the and_gate module (DUT)	
	stop_watch #(2) dut
				(.clk(clk),.rst_n(rst_n),.sw_start_stop(sw_start_stop),
				.sw_clear(sw_clear),.sw_lap(sw_lap),
				.sec_tens_7seg(sec_tens_7seg),.sec_ones_7seg(sec_ones_7seg),
				.hund_tens_7seg(hund_tens_7seg),.hund_ones_7seg(hund_ones_7seg)	);
	
	// Stimulus generation: Apply test vectors
	initial begin
		
		
		// Initialiaze the signal
		clk = 0;
		rst_n = 1;
		sw_start_stop = 1;
		sw_clear = 1;
		sw_lap = 1;
	
		
		
		
		
		// Display headers for simulation outputs
		$display("Time\t clk\t rst_n\t en\t out\t");
		
		// Monitor every change of the signals
        //$monitor("Time = %0t, rate = %b, out= %b", $time,rate, out);



	

		// Apply input combinations
		#10; rst_n = 0;
		#10; rst_n = 1;


		#100; sw_start_stop = 0;
		#100; sw_start_stop = 1;
		
		#100; sw_lap = 0;
		#100; sw_lap = 1;
		
		#20; sw_lap = 0;
		#20; sw_lap = 1;
		
		//#100; sw_clear = 1;
		//#100; sw_clear = 0;
		
	
		
	
	end
	
	
	
	
	always begin
		#(`CLK_PER) clk = ~clk;
	end
		
	
		
	
endmodule