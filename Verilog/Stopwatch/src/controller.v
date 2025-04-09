


`timescale 1ns / 1ps  // Define time scale in the Verilog file


module controller
		#(parameter COUNTER_WIDTH= 4)
		(clk,rst_n,sw_start_stop,sw_clear,sw_lap,
		count_enable,count_clear,count_lap);
		
	input clk;
	input rst_n;
	
	input sw_start_stop;
	input sw_clear;
	input sw_lap;
	
	output count_enable;
	output count_clear;
	output count_lap;
	reg count_enable;
	reg count_clear;
	reg count_lap;
	
	
	//states machine variables
	reg [1:0] state,next_state;
	
	//states machines
	parameter IDLE = 2'b00;
	parameter COUNT = 2'b01;
	parameter LAP = 2'b10;
	parameter STOP = 2'b11;
	
	
	

	//Asynchronous state change
	always @* 
		case(state)
		
			IDLE: begin
			
				if(sw_clear == 1) next_state =  IDLE;
				else if(sw_start_stop == 1) next_state = COUNT;
				else next_state = IDLE;
					
			end	

			COUNT: begin
				
				if(sw_clear == 1) next_state =  IDLE;
				else if(sw_start_stop == 1) next_state = STOP;
				else if(sw_lap == 1) next_state = LAP;
				else next_state = COUNT;
				
			end
			
				
			LAP: begin
			
				if(sw_clear == 1) next_state =  IDLE;
				else next_state = COUNT;
				
			end
			
			
			STOP: begin
				
				if(sw_clear == 1) next_state =  IDLE;
				else if(sw_start_stop == 1) next_state = COUNT;
				else next_state = STOP;
				
			end


			default: begin
				next_state = 2'bx;
				$display("%t: State machine not initialized\n", $time);

			end

		endcase




	// Next state moving to state after clk, rst_n
	always @(posedge clk or negedge rst_n)
		if(!rst_n)
			state <= IDLE;
		else
			state <= next_state;
			
			
			
			
	// Define the counter reg
	always @(posedge clk or negedge rst_n)
	
		if(!rst_n)
			count_enable <= 0;
		else
			case(state)
			
			IDLE: begin 
				count_enable <= 0;
				count_clear <= 1;
				count_lap <= 0;
			end
			
			COUNT: begin
				count_enable <= 1;
				count_clear <= 0;
			end
			
			LAP: begin 
				count_lap <= ! count_lap;
			end
			
			STOP: begin 
				count_enable <= 0;
			end
			
			
			endcase
		
		
		
			
			
	
	
endmodule
