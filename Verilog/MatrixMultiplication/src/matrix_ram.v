

`timescale 1ns / 1ps  // Define time scale in the Verilog file





module matrix_ram #(parameter DATA_WIDTH =8,ADDRESS_BITS = 2 )
					(clk,rst_n,wren_n,enable_n,data,address,byteena,out);

	input clk;								// Clock singal
	input rst_n;							// Active low reset
	input wren_n;							// Active low write 
	input enable_n;							// Active low chip enable
	input [DATA_WIDTH-1:0] data;			// Data to be written
	input [ADDRESS_BITS-1:0] address;		// Address to access memory
	input [2:0] byteena;					// Byte-enable
	
	
	output [DATA_WIDTH-1:0] out;			// Data output from memory
	reg [DATA_WIDTH-1:0] out;
	
	
	

	//Signals 
	// For DATA_WIDTH = 8, we have 4 mem cells of 8Bytes each one, resulting in 4*8 = 32Bytes
	reg signed [(DATA_WIDTH)*8 -1:0] mem_array [(2** (ADDRESS_BITS) )-1:0];


	





			
			
	// Define the outputs basded on the current state
	always @(posedge clk or negedge rst_n) begin
	
		if(!rst_n) 
			out <= 0;
	
		else begin
			
			if(enable_n == 0) 
				//if(wren_n == 0) mem_array[address][(byteena+1)*8-1: byteena*8 ] <= data;
				//else out <= mem_array[address][(byteena+1)*8-1: byteena*8 ];
				
				if(wren_n == 0)
					// Write operation with byte enable
                    case (byteena)
                        3'b000: mem_array[address][7:0] <= data;
                        3'b001: mem_array[address][15:8] <= data;
                        3'b010: mem_array[address][23:16] <= data;
                        3'b011: mem_array[address][31:24] <= data;
                        3'b100: mem_array[address][39:32] <= data;
                        3'b101: mem_array[address][47:40] <= data;
                        3'b110: mem_array[address][55:48] <= data;
                        3'b111: mem_array[address][63:56] <= data;
                        default: ;
                    endcase
					
				else
				
					// Read operation with byte enable
                    case (byteena)
                        3'b000: out <= mem_array[address][7:0];        // Read byte 0
                        3'b001: out <= mem_array[address][15:8];       // Read byte 1
                        3'b010: out <= mem_array[address][23:16];      // Read byte 2
                        3'b011: out <= mem_array[address][31:24];      // Read byte 3
                        3'b100: out <= mem_array[address][39:32];      // Read byte 4
                        3'b101: out <= mem_array[address][47:40];      // Read byte 5
                        3'b110: out <= mem_array[address][55:48];      // Read byte 6
                        3'b111: out <= mem_array[address][63:56];      // Read byte 7
                        default: out <= 0; // Default case to avoid latch inference
                    endcase
				
		end
	
	
	
	end
			

	
	
endmodule
	

