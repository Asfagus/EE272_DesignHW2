// FIFO Module

module fifo_block (clk, rst, w_en, r_en, full, empty, data_in, data_out);
	
	// define dimensions
	parameter mem_width = 40;	
	parameter depth = 6;
	parameter fifo_width = (1 << depth);
	
	
	input clk, rst, w_en, r_en;
	output reg full, empty;
	input [mem_width - 1 : 0] data_in;
	output reg [mem_width - 1 : 0] data_out;
	
	integer i;
	
	// fifo memory block
	reg [mem_width - 1:0] fifo_memory [fifo_width - 1:0];
	
	// pointers
	reg [depth - 1 : 0] read_pointer, write_pointer;
	reg [depth : 0] fifo_pointer;
	
	// update flags	
	always @(fifo_pointer)
	begin
		if (fifo_pointer == 0)
			empty = 1'b1;
		else
			empty = 1'b0;
	
		if (fifo_pointer < fifo_width)
			full = 1'b0;
		else
			full = 1'b1;		
	end
	
	// read and write 
	assign data_out = fifo_memory[read_pointer];
	
	always @( posedge clk or posedge rst)
	begin
		if (rst)
		begin
			for (i = 0; i < fifo_width; i = i + 1)
			begin
				fifo_memory[i] <= 0;
			end
		end
		else
		begin
			if (w_en == 1'b1 && full == 1'b0)
				fifo_memory[write_pointer] <= #1 data_in;
		end
		
	end
	
	// update pointers
	always @(posedge clk or posedge rst)
	begin
		if (rst)
		begin
			write_pointer <= 1'b0;
			read_pointer <= 1'b0;	
			fifo_pointer <= 1'b0;		
		end
		else
		begin
			if (w_en == 1'b1 && full == 1'b0)
			begin
				write_pointer <= #1 write_pointer + 1;
				fifo_pointer <= #1 fifo_pointer + 1;
			end
			if (r_en == 1'b1 && empty == 1'b0)
			begin
				read_pointer <= #1 read_pointer + 1;
				fifo_pointer <= #1 fifo_pointer - 1;
			end
		end
	end
	
	// update fifo_pointer
	/*
	always @(posedge clk or posedge rst)
	begin
		if (rst)
		begin
			fifo_pointer <= 1'b0;			
		end
		else
		begin
			case ({r_en, w_en})
				2'b01:
				begin
					if (full == 1'b0)
						fifo_pointer <= #1 fifo_pointer + 1;
				end
				2'b10:
				begin
					if (empty == 1'b0)
						fifo_pointer <= #1 fifo_pointer - 1;
				end
				default:
					fifo_pointer <= #1 fifo_pointer;					
			endcase			
		end
	end
	
	*/



endmodule : fifo_block















