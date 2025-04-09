

`timescale 1ns / 1ps  // Define time scale in the Verilog file

`define ARRAY_SIZE 96
`define MATRIX_SIZE 16


//`include "data_generator_pack.v"  // Include the data generator pack file


module data_generator #(parameter N_BITS =8 ) (clk,rst_n,data_request,dout,dout_valid);

	input clk;
	input rst_n;
	input data_request;
	
	output [N_BITS-1:0] dout;
	output dout_valid;
	
	reg [N_BITS-1:0] dout;
	reg dout_valid;
	


	//Signals 
	reg [6:0] index = 0;
	reg end_transmit = 0;
	reg signed [7:0] data_generator_array [`ARRAY_SIZE-1:0];


	// Read data from a file (e.g., "bitmap.txt")
    initial begin
		// Use $readmemb for reading binary values
        $readmemh("../sim/bitmap/bitmap_lines_separated.txt", data_generator_array); 
	end

	
	//states machine variables
	reg [1:0] state,next_state;
	
	//states machines
	parameter ST_IDLE = 2'b00;
	parameter ST_TRANSMIT = 2'b01;
	parameter ST_WAIT_NEXT = 2'b10;
	
	
	
	// Initialize state in the simulation (for simulation purposes only)
    initial begin
        state = ST_IDLE;  // Set initial state to idle (or any valid state)
        //out = 3'b000;  // Set output to some known value
    end



	//Asynchronous state change
	always @*

		case(state) 
		
			ST_IDLE: begin
			
				if(!rst_n) next_state = ST_IDLE;
				else if(data_request) next_state  = ST_TRANSMIT;
				else next_state = ST_IDLE;
				
			end	

			ST_TRANSMIT: begin
				
				if(!rst_n) next_state = ST_IDLE;
				else if(end_transmit) next_state = ST_WAIT_NEXT;
				else next_state = ST_TRANSMIT;
			end	
			
			ST_WAIT_NEXT: begin
			
				if(!rst_n) next_state = ST_IDLE;
				else if(data_request) next_state = ST_TRANSMIT;
				else next_state = ST_WAIT_NEXT;
						
			end	
			
		
			default: begin
				next_state = 2'bx;
				//$display("%t: State machine not initialized\n", $time);

			end

		endcase




	// Next state moving to state after clk, rst_n
	always @(posedge clk or negedge rst_n)
			state <= next_state;
			
			
			
	// Define the outputs basded on the current state
	always @(posedge clk or negedge rst_n)
	
		case(state) 
			ST_IDLE: begin
				index <= 0;
				dout_valid <= 0;
				dout <= 0;
			end
			
				
			ST_TRANSMIT: begin
				dout <= data_generator_array[index];
				dout_valid <= 1;
				index = index + 1;
				
				if(index % 15 == 0) end_transmit <= 1;
				else end_transmit <= 0;
				
			end
			
			ST_WAIT_NEXT:
				dout_valid = 0;
				
					
		
			default
				dout <= 8'bx;
				
		endcase
			

	
	
endmodule
	

