

`timescale 1ns / 1ps  // Define time scale in the Verilog file
`define CLK_PER 2

`define DATA_WIDTH 8
`define ADDRESS_BITS 2


module matrix_ram_tb;



	// Declare testbench signals (inputs and outputs)
	reg clk;								// Clock singal
	reg rst_n;							// Active low reset
	reg wren_n;							// Active low write 
	reg enable_n;							// Active low chip enable
	reg [`DATA_WIDTH-1:0] data;			// Data to be written
	reg [`ADDRESS_BITS-1:0] address;		// Address to access memory
	reg [2:0] byteena;		// Byte-enable
	
	
	wire [`DATA_WIDTH-1:0] out;			// Data output from memory
	

	reg read_write_n = 0;
	
	// Instantiate the and_gate module (DUT)
	matrix_ram #(`DATA_WIDTH,`ADDRESS_BITS) dut(.clk(clk),.rst_n(rst_n),.wren_n(wren_n),.enable_n(enable_n),
												.data(data),.address(address),.byteena(byteena),.out(out));
	
	
	// Stimulus generation: Apply test vectors
	initial begin
		
		
		// Initialiaze the signals
		clk  = 0;
		rst_n = 1;
		wren_n = 0;
		enable_n = 0;
		byteena = 1;
		
		data = 10;
		address = 0;
		
		
		
		
		
		
		// Display headers for simulation outputs
		//$display("Time\t clk\t nrst\t en\t out\t");
		
		// Monitor every change of the signals
        //$monitor("Time = %0t, bin_in = %d, bcd_out = %b", $time,bin_in, bcd_out);




		// Apply input combinations
		
		//#30; bin_in = 12623;
		
		// Loop to write data to memory
        for (address = 0; address <= (2**`ADDRESS_BITS) - 1; address = address + 1) begin
           
			//if(!read_write_n) wren_n = 0;
			//else wren_n = 1;
       	
			for(byteena = 0 ; byteena < (`DATA_WIDTH) ; byteena = byteena + 1) begin
				
				
				if(!read_write_n) begin 
					wren_n = 0;
					data = data+ 1;
				end
				else 
					wren_n = 1;
				
				
				
				
				
				
				
				if(byteena == 7 & address < 4) address = address +1;
				if(address == 3) read_write_n = 1;
				
				#10;
			end
		
		
			//if( address == (2**`ADDRESS_BITS) - 1 ) read_write_n = 1;
            $display("Address: %d, Written Data: %h, Read Data: %h", address, data, out);
        end
		
		
		
	end
	

	
	
	
	always begin
		#(`CLK_PER) clk = ~clk;
	end
		
		
	
endmodule

/*

// Loop to write data to memory
        for (address = 0; address <= (2**`ADDRESS_BITS) - 1; address = address + 1) begin
           
       	
			
			
			if(!read_write_n) begin
				wren_n = 0;
				data = address + 10;
			end
			else
				wren_n = 1;
			
		
			
			#10;
			
			if( address == 63) read_write_n = 1;
			
			
            $display("Address: %d, Written Data: %h, Read Data: %h", address, data, out);
        end
		*/