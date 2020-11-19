typedef enum bit [1:0] {S0,S1,S2,S3} State ;
module in(input clk,input rst, input pushin,input firstin,input [63:0] din, output reg [2:0] m1wx,
output reg [2:0] m1wy,output reg [63:0] m1wd,output stopin,output reg m1wr,output reg [2:0] m1rx, output reg[2:0] m1ry, output  m2_pushin,output  m2_firstin, input m1_stopout);

reg [4:0] count, count_d;
reg [2:0] wx1,wy1,wx1_d,wy1_d;
reg [2:0] rx1,ry1;
reg stopin_d,data_loaded_d;
reg m2_pushin_d,m2_firstin_d;
reg wr;
State PS,NS;

assign stopin = stopin_d;
assign m2_pushin = m2_pushin_d;
assign m2_firstin = m2_firstin_d;

always @ (*) begin
case (PS)
S0: begin
    wr 	= 0;
    wx1 = 0;
    wy1 = 0;
		rx1 = 0;
		ry1 = 0;
		stopin_d = 0;
		m2_pushin_d = 0;
		m2_firstin_d = 0;
    NS = S1;
    end

S1: begin
			
			m2_pushin_d = 0;
			m2_firstin_d = 0;
			rx1 = 0;
			ry1 = 0;
			
			if(m1wx == 4 & m1wy == 4)begin
				wr = 0;
				end else begin
				wr = pushin;
				end

		if(m1wx == 4 & m1wy == 4)begin
			stopin_d = 1;
			NS = S2;
			end else begin
			stopin_d = 0;
			NS = S1;
			end


		case({pushin,firstin})
    
      2'b11: begin	
								wx1 = 0;
	      				wy1 = 0;
								
	      			end

      2'b10: begin

					 if (m1wx == 4 & m1wy == 4)begin
							wx1 = m1wx;
							end else if (m1wx == 4) begin
							wx1 = 0;
							end else begin
							wx1 = m1wx +1;
							end
		  		
	     		 if (m1wx == 4 & m1wy == 4) begin
							 wy1 = m1wy;
					 end else if (m1wx == 4)begin
							 wy1 = m1wy + 1;
					 end else begin
					 		 wy1 = m1wy;
					 end
								
						end
     
		 default: begin
								
								wx1 = m1wx;
								wy1 = m1wy;
						
						end
									
				endcase
	
		end

S2: begin
					
					stopin_d = 1;
					wr = 0;
					wx1 = 0;
					wy1 = 0;

				if(m1_stopout)begin
					rx1 = m1rx;
					ry1 = m1ry;
					NS = S2;
					m2_pushin_d = 0;
					m2_firstin_d = 0;
				end else begin

					if(m1rx == 4)
						rx1 = 0;
						else 
							rx1 = m1rx + 1;

					if(m1ry == 4 & m1rx == 4)
							ry1 = m1ry;
							else if(m1rx == 4)
							ry1 = m1ry + 1;
							else
								ry1 = m1ry;
		
						if(m1ry == 4 & m1rx == 4)begin
							NS = S3;
							end else begin
							NS = S2;
							end

						if(m1ry == 0 & m1rx == 0)begin
							m2_pushin_d = 1;
							m2_firstin_d = 1;
							end else begin
							m2_pushin_d = 1;
							m2_firstin_d = 0;
							end

							end
		end

S3: begin

		rx1 = 0;
		ry1 = 0;
		wx1 = 0;
		wy1 = 0;
		wr = 	0;
		stopin_d = 1;
		m2_pushin_d = 0;
		m2_firstin_d = 0;
		NS = S1;
		
		end
	endcase
	end

always @ (posedge clk or posedge rst)begin
    if(rst)begin
      m1wr <= 0;
      m1wx <= 0;
      m1wy <= 0;
			m1rx <= 0;
			m1ry <= 0;
			m1wd <= 0;
      PS  <= S0; 
    end else begin
      m1wr <= #1 wr;
      m1wx <= #1 wx1;
      m1wy <= #1 wy1;
			m1rx <= #1 rx1;
			m1ry <= #1 ry1;
			m1wd <= #1 din;
      PS <= #1  NS;
    
   end
end	 

endmodule 	
