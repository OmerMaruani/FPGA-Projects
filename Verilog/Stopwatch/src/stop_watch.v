

`timescale 1ns / 1ps  // Define time scale in the Verilog file

`define PULSE_PER_CLOCKS 2  // Define the constant value


module stop_watch #(parameter N_CLOCKS = 5_00_000)
				(clk,rst_n,sw_start_stop,sw_clear,sw_lap,
				sec_tens_7seg,sec_ones_7seg,
				hund_tens_7seg, hund_ones_7seg,
				led0,led1,led2,led3);
	
	input clk;
	input rst_n;
	
	input sw_start_stop;
	input sw_clear;
	input sw_lap;
	
	output [6:0] sec_tens_7seg;
	output [6:0] sec_ones_7seg;
	output [6:0] hund_tens_7seg;
	output [6:0] hund_ones_7seg;
	
	output led0,led1,led2,led3;
	
	
	wire sig_start_stop, sig_clear, sig_lap;
	
	wire sig_count_lap, sig_count_clear, sig_count_enable;
	
	wire sig_pulse;
	
	wire [3:0] sig_sec_tens, sig_sec_ones, sig_hund_tens, sig_hund_ones;
	
	
	
	
	
	sync #(0) sync_start_stop	 (.clk(clk),.rst_n(rst_n),.signal(sw_start_stop),.out(sig_start_stop) );
	sync #(0) sync_clear		 (.clk(clk),.rst_n(rst_n),.signal(sw_clear),.out(sig_clear) );
	sync #(0) sync_lap			 (.clk(clk),.rst_n(rst_n),.signal(sw_lap),.out(sig_lap) );
	
	
	controller #(4) control 	 (.clk(clk),.rst_n(rst_n), .sw_start_stop(sig_start_stop),
								  .sw_clear(sig_clear), .sw_lap(sig_lap), .count_enable(sig_count_enable),
								  .count_clear(sig_count_clear), .count_lap(sig_count_lap) );
	
	
	
	pulse_generator #(N_CLOCKS) pulse_gen (.out(sig_pulse),.clk(clk),.rst_n(rst_n),
								  .clear(sig_count_clear),.ena(sig_count_enable) );
	
	
	
	
	counter #(4) counter1	(.sec_tens(sig_sec_tens),.sec_ones(sig_sec_ones),
								 .hund_tens(sig_hund_tens),.hund_ones(sig_hund_ones),
								 .clk(clk),.rst_n(rst_n),.clear(sig_count_clear),
								 .ena(sig_pulse),.oen(sig_count_lap) );
	
	
	
	
	
	bcd_to7seg #(4) bcd1 (.bcd_in(sig_sec_tens),.out(sec_tens_7seg) );
	bcd_to7seg #(4) bcd2 (.bcd_in(sig_sec_ones),.out(sec_ones_7seg) );
	bcd_to7seg #(4) bcd3 (.bcd_in(sig_hund_tens),.out(hund_tens_7seg) );
	bcd_to7seg #(4) bcd4 (.bcd_in(sig_hund_ones),.out(hund_ones_7seg) );


	
	assign led0 = sw_start_stop;
	assign led1 = sw_lap;
	assign led2 = sw_clear;
	assign led3 = rst_n;

	
endmodule
	


