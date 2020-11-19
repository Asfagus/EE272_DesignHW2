`define add(x) (x==2?0:x==3?1:x==4?2:x+3)

typedef enum bit [4:0] {reset, m2_write, Calc_C,get_D,Calc_D,Dummy,Theta,Rpi,Chi1,Chi2,Chi_iota, m2_read, idle} step;

module rounds(input clk,input rst, input [63:0] din,input pushin, input firstin,output  m2_stopin,
							input [63:0] m2rd, output reg [63:0] m2wd,output reg m2wr,output reg [2:0] m2wx,
							output reg [2:0] m2wy, output reg [2:0] m2rx, output reg [2:0] m2ry,input [63:0] m3rd, 
							output reg [63:0] m3wd, output reg m3wr, output reg [2:0] m3wx, output reg [2:0] m3wy,
							output reg [2:0] m3rx, output reg [2:0] m3ry, input stopout, output  m4_pushin, output  m4_firstin);


reg [2:0] wx2,wy2,rx2,ry2;
reg [2:0] wx3, wy3, rx3, ry3;
reg wx3_d,wy3_d;

reg [63:0] C_d,m_wd;
reg m2wr_d, m3wr_d;
step PS, NS;
reg m2_stopin_d,m4_pushin_d,m4_firstin_d;
reg [63:0] RC [23:0];
reg [4:0] round_count,round_count_d;
reg [5:0] rpi [4:0] [4:0];

assign rpi[0][0] = 0;  assign rpi[1][0] = 36; assign rpi[2][0] = 3;  assign rpi[3][0] = 41; assign rpi[4][0] = 18;
assign rpi[0][1] = 1;  assign rpi[1][1] = 44;	assign rpi[2][1] = 10; assign rpi[3][1] = 45; assign rpi[4][1] = 2; 
assign rpi[0][2] = 62; assign rpi[1][2] = 6;  assign rpi[2][2] = 43; assign rpi[3][2] = 15; assign rpi[4][2] = 61;
assign rpi[0][3] = 28; assign rpi[1][3] = 55;	assign rpi[2][3] = 25; assign rpi[3][3] = 21; assign rpi[4][3] = 56; 
assign rpi[0][4] = 27; assign rpi[1][4] = 20;	assign rpi[2][4] = 39; assign rpi[3][4] = 8;  assign rpi[4][4] = 14;


assign RC[00] = 64'h0000000000000001; 
assign RC[01] = 64'h0000000000008082;
assign RC[02] = 64'h800000000000808A;
assign RC[03] = 64'h8000000080008000;
assign RC[04] = 64'h000000000000808B;
assign RC[05] = 64'h0000000080000001;
assign RC[06] = 64'h8000000080008081;
assign RC[07] = 64'h8000000000008009;
assign RC[08] = 64'h000000000000008A;
assign RC[09] = 64'h0000000000000088;
assign RC[10] = 64'h0000000080008009;
assign RC[11] = 64'h000000008000000A;
assign RC[12] = 64'h000000008000808B;
assign RC[13] = 64'h800000000000008B;
assign RC[14] = 64'h8000000000008089;
assign RC[15] = 64'h8000000000008003;
assign RC[16] = 64'h8000000000008002;
assign RC[17] = 64'h8000000000000080;
assign RC[18] = 64'h000000000000800A;
assign RC[19] = 64'h800000008000000A;
assign RC[20] = 64'h8000000080008081;
assign RC[21] = 64'h8000000000008080;
assign RC[22] = 64'h0000000080000001;
assign RC[23] = 64'h8000000080008008;

assign m3wd = m_wd;
assign m2wd = m_wd;
assign m2_stopin = m2_stopin_d;
assign m4_pushin = m4_pushin_d;
assign m4_firstin = m4_firstin_d;

always @ (*) begin
round_count_d = round_count;
wx2=0;
wy2=0;
rx2 = 0;
ry2 = 0;
rx3=0;
ry3=0;
//wx3 = 0;	//wx3=wx3_d;
//wy3 = 4;
wx3=m3wx;
wy3=m3wy;

case (PS)
reset: begin
    
		m2wr_d 	= 0;
		m3wr_d = 0;
		round_count_d = 0;
    	wx2 = 0;
    	wy2 = 0; 
		rx2 = 0;
		ry2 = 0;
		wx3 = 0;
		wy3 = 4;
		rx3 = 1;
		ry3 = 0;
		C_d = 0;
		m4_pushin_d = 0;
		m4_firstin_d = 0;
		m2_stopin_d = 0;
    NS = m2_write;
    
		end

m2_write: begin
					
					round_count_d = round_count;
					C_d = din;
					m4_pushin_d = 0;
					m4_firstin_d = 0;
					m3wr_d = 0;
					wx3 = 0;
					wy3 = 4;
					rx3 = 1;
					ry3 = 0;
					ry2 = 0;
					rx2 = 0;

		 	if(m2wx == 4 & m2wy == 4)begin
				m2wr_d = 0;
				end else begin
				m2wr_d = pushin;
				end

		if(m2wx == 4 & m2wy == 4)begin
			m2_stopin_d = 1;
			NS = Calc_C;
			end else begin
			m2_stopin_d = 0;
			NS = m2_write;
			end
  
		case({pushin,firstin})
    
      2'b11: begin
	  									
								wx2 = 0;
	      				wy2 = 0;
				
	      			end

      2'b10: begin
						
					 if (m2wx == 4 & m2wy == 4)begin
							wx2 = 0;
							end else if (m2wx == 4) begin
							wx2 = 0;
							end else begin
							wx2 = m2wx +1;
							end
		  		
	     		 if (m2wx == 4 & m2wy == 4) begin
							 wy2 = 0;
					 end else if (m2wx == 4)begin
							 wy2 = m2wy + 1;
					 end else begin
					 		 wy2 = m2wy;
					 end
		 					
								
						end
     
		 default: begin		 
								
	
								wx2 = m2wx;
								wy2 = m2wy;
						
						end
	
				endcase
		
		end


Calc_C: begin
					
					round_count_d = round_count;
					m2wr_d = 0;	
					m2_stopin_d = 1;
					rx3 = 1;
					ry3 = 0;
					wy3 = 0;
					wx2 = 0;
					wy2 = 0;
					m4_pushin_d = 0;
					m4_firstin_d = 0;

				if(m2rx == 4 & m2ry == 4)begin
					ry2 = 0;
					end else if (m2ry == 4)begin
					ry2 = 0;
					end else begin
					ry2 = m2ry +1;
					end

				if(m2rx == 4 & m2ry == 4)begin
					rx2 = 0;
					end else if(m2ry == 4)begin
					rx2 = m2rx +1;
					end else begin
					rx2 = m2rx;
					end

			if(m2ry == 0)begin
				C_d = m2rd;
				end else begin
				C_d = (m_wd ^ m2rd);
				end

			if(m2ry == 4 & m2rx == 0)begin
				m3wr_d = 1;
				wx3 = 0;
				end else if(m2ry == 4 & m2rx == 1) begin
				m3wr_d = 1;
				wx3 = 1;
				end else if(m2ry == 4 & m2rx == 2)begin
				m3wr_d = 1;
				wx3 = 2;
				end else if(m2ry == 4 & m2rx == 3)begin
				m3wr_d = 1;
				wx3 = 3;
				end else if(m2ry == 4 & m2rx == 4)begin
				m3wr_d = 1;
				wx3 = 4;
				end else begin
				m3wr_d = 0;
				wx3 = m3wx;
				end


		 wy3 = 0; 

			if(m2rx == 4 & m2ry == 4)begin
					NS = get_D;
					end else begin
					NS = Calc_C;
					end

		end

get_D: begin
			wx2 = 0;
			wy2 = 0;
			wx3 = m3wx;
			wy3 = 0;
			m2_stopin_d = 1;	
			ry3 = 0;
			m3wr_d = 0;
			m2wr_d = 0;
			m4_pushin_d = 0;
			m4_firstin_d = 0;
			round_count_d = round_count;

				if(m3rx == 1)begin
					rx3 = m3rx +3;
				end else if(m3rx == 2)begin
					rx3 = m3rx - 2;
					end else if (m3rx == 3)begin
					rx3 = m3rx - 2;
					end else if (m3rx == 4)begin
					rx3 = m3rx - 2;
					end else if (m3rx == 0)begin
					rx3 = m3rx + 3;
					end else begin
					rx3 = m3rx;
					end

				
				C_d = {m3rd[62:0],m3rd[63]};

				NS = Calc_D;
			 end

Calc_D: begin
				wx2 = 0;
				wy2 = 0;
				m2_stopin_d = 1;
				ry3 = 0;
				wy3 = 1;
				m2wr_d = 0;
				round_count_d = round_count;
				m4_pushin_d = 0;
				m4_firstin_d = 0;
        

				if(m3rx == 4)begin
					rx3 = m3rx - 2;
					end else if (m3rx == 0)begin
					rx3 = m3rx + 3;
					end else if (m3rx == 1)begin
					rx3 = m3rx+3;
					end else if (m3rx == 2)begin 
						rx3 = m3rx - 2;
						end else if (m3rx == 3)begin
						rx3 = m3rx;
						end

				C_d = m_wd ^ m3rd;	
				
				
				if(m3wx == 4 & m3wy == 1)begin
					wx3 = m3wx;
					end else if(m3wx == 4)begin
					wx3 = 0;
					end else begin
					wx3 = m3wx + 1;
					end

			if(m3wx <= 4)begin
				m3wr_d = 1;
				end else begin
				m3wr_d = 0;
				end
				
				if(m3rx == 3 & m3ry == 0)begin
							NS = Dummy;
							end else begin
							NS = get_D;
							end
				end
Dummy:begin

			ry3 = 1;
			rx3 = 0;
			rx2 = 0;
			ry2 = 0;
			wx2 = 0;
			wy2 = 0;
			wx3 = 0;
			wy3 = 0;
			m3wr_d = 0;
			m2wr_d = 0;
			C_d = m_wd;
			round_count_d = round_count;
			m2_stopin_d = 1;
			m4_pushin_d = 0;
			m4_firstin_d = 0;
			NS = Theta;

			end

Theta: begin
							
				m3wr_d = 0;
				m2_stopin_d = 1;
				round_count_d = round_count;	
				m4_pushin_d = 0;
				m4_firstin_d = 0;
						wx3 = m3wx;
						wy3 = m3wy;
				ry3 = 1;
				
				if(m2rx == 4 & m2ry == 4)begin
					rx3 = m3rx;
				end else if(m3rx == 4)begin
					rx3 = 0;
				end else begin
					rx3 = m3rx+1;
					end
			
					
				if(m2rx == 4 & m2ry == 4)begin
					rx2 = 0;
				end else if (m2rx == 4)begin
					rx2 = 0;
				end else begin
					rx2 = m2rx + 1;
				end

				if(m2rx == 4 & m2ry == 4)begin;
					ry2 = 0;
				end else if (m2rx == 4)begin
					ry2 = m2ry + 1;
				end else begin
					ry2 = m2ry;
				end

	
				C_d = m3rd^m2rd;

					m2wr_d = 1;
					wx2 = m2rx;
					wy2 = m2ry;


       if(m2rx == 4 & m2ry == 4)begin
			 	NS = Rpi;
			 end else begin
			 	NS = Theta;
			 end

				end

Rpi: begin
			
			wx2 = m2wx;
			wy2 = m2wy;
			rx3 = 2;
			ry3 = 0;

			round_count_d = round_count;
			m2_stopin_d = 1;
			m4_pushin_d = 0;
			m4_firstin_d = 0;

			m2wr_d = 0;

			if(m2rx == 4 & m2ry == 4)begin
					rx2 = 0;
				end else if (m2rx == 4)begin
					rx2 = 0;
				end else begin
					rx2 = m2rx + 1;
				end

				if(m2rx == 4 & m2ry == 4)begin;
					ry2 = 0;
				end else if (m2rx == 4)begin
					ry2 = m2ry + 1;
				end else begin
					ry2 = m2ry;
				end
	
			
			C_d = m2rd << rpi[m2ry][m2rx] | m2rd >> 64-rpi[m2ry][m2rx];
			
			wx3 = m2ry;

			case({m2ry,m2rx})

			6'b000000: wy3 = 0;
			
			6'b000001: wy3 = 2;

			6'b000010: wy3 = 4;

			6'b000011: wy3 = 1;

			6'b000100: wy3 = 3;

			6'b001000:	wy3 = 3;
					
			6'b001001: wy3 = 0;

			6'b001010: wy3 = 2;

			6'b001011: wy3 = 4;

			6'b001100: wy3 = 1;

			6'b010000: wy3 = 1;

			6'b010001: wy3 = 3;

			6'b010010: wy3 = 0;

			6'b010011: wy3 = 2;

			6'b010100: wy3 = 4;

			6'b011000: wy3 = 4;

			6'b011001: wy3 = 1;

			6'b011010: wy3 = 3;

			6'b011011: wy3 = 0;

			6'b011100: wy3 = 2;

			6'b100000: wy3 = 2;

			6'b100001: wy3 = 4;

			6'b100010: wy3 = 1;

			6'b100011: wy3 = 3;

			6'b100100: wy3 = 0;
			endcase

		m3wr_d = 1;
		 
		if(m2rx == 4 & m2ry == 4)begin
			NS = Chi1;
			end else begin
			NS = Rpi;
			end
		 
		 end

Chi1:		 	begin
			
					m3wr_d = 0;	
					m2_stopin_d = 1;
					m2wr_d = 0;
					
					wx2 = m2wx;
					wy2 = m2wy;
					wx3 = m3wx;
					wy3 = m3wy;
					
					round_count_d = round_count;

					ry3 = m3ry;
					m4_firstin_d = 0;
					m4_pushin_d = 0;
				if(m3rx == 0)begin
						rx3 = 4;
						end else begin
						rx3 = m3rx - 1;
						end
					
					C_d = m3rd;
					
					NS = Chi2;
					
					end

Chi2:     begin
					ry3 = m3ry;	
					m2_stopin_d = 1;
					m3wr_d = 0;
					m2wr_d = 0;
					round_count_d = round_count;
					m4_pushin_d = 0;
					m4_firstin_d = 0;
					wx2 = m2wx;
					wy2 = m2wy;
					wx3 = m3wx;
					wy3 = m3wy;
					if(m3rx == 0)begin
						rx3 = 4;
						end else begin
						rx3 = m3rx - 1;
						end

					C_d = ((~m3rd) & m_wd);

					NS = Chi_iota;

						end

Chi_iota: begin
          
					m2_stopin_d = 1;
					m2wr_d = 1;
					rx3 = `add(m3rx);
					m3wr_d = 0;
					m4_pushin_d = 0;
					m4_firstin_d = 0;

					wx3 = 4;
					wy3 = 0;
					if(m3rx == 4 & m3ry == 4)begin
						ry3 = m3ry;
						end else if (m3rx == 4) begin
						ry3 = m3ry + 1;
						end else begin
						ry3 = m3ry;
						end
				 
	
						if(m3rx == 0 & m3ry == 0)begin	
         
				 		C_d = (m3rd ^ m_wd ^ RC[round_count]);
						
						end else begin
            C_d = (m3rd ^ m_wd);
						end

					if(m2wx == 4 & m2wy == 4)begin
						wx2 = 0;
						end else if (m2wx == 4) begin
						wx2 = 0;
						end else begin
						wx2 = m2wx + 1;
						end
					
					if(m2wx == 4 & m2wy == 4 )begin
						wy2 = 0;
						end else if (m2wx == 4)begin
						wy2 = m2wy + 1;
						end else begin
						wy2 = m2wy;
						end

					if(m3rx == 4 & m3ry == 4)begin
						if(round_count == 23	)begin
								round_count_d = 0;
								
								NS = m2_read;
								
								end else begin 		
								
								round_count_d = round_count + 1;
								
								NS = Calc_C;
								
								end 
								end
								else begin
								
								NS = Chi1;
								
								end
							
					end

m2_read: begin
				
				m2wr_d = 0;
				m3wr_d = 0;
				m2_stopin_d = 1;
				round_count_d = round_count;
				C_d = m_wd;
				wx3 = m3wx;
				wy3 = m3wy;
				if(stopout)begin
					wx2 = m2wx;
					wy2 = m2wy;
					NS = PS;
					m4_pushin_d = 0;
					m4_firstin_d = 0;
				end else begin

					if(m2rx == 4)
						rx2 = 0;
						else 
							rx2 = m2rx + 1;

					if(m2ry == 4 & m2rx == 4)
							ry2 = 0;
							else if(m2rx == 4)
							ry2 = m2ry + 1;
							else
								ry2 = m2ry;
		
						if(m2ry == 4 & m2rx == 4)begin
							NS = idle;
							end else begin
							NS = m2_read;
							end

						if(m2ry == 0 & m2rx == 0)begin
							m4_pushin_d = 1;
							m4_firstin_d = 1;
							end else begin
							m4_pushin_d = 1;
							m4_firstin_d = 0;
							end

							end

				end	

idle: begin
		m2wr_d 	= 0;
		m3wr_d = 0;
		round_count_d = 0;
    wx2 = 0;
    wy2 = 0; 
		rx2 = 0;
		ry2 = 0;
		wx3 = 0;
		wy3 = 4;
		rx3 = 1;
		ry3 = 0;
		C_d = 0;
		m4_pushin_d = 0;
		m4_firstin_d = 0;
		m2_stopin_d = 1;
		NS = m2_write;
			end

default: begin
					
				m2wr_d 	= m2wr;
				m3wr_d = m3wr;
				round_count_d = round_count;
    		wx2 = 0;
    		wy2 = 0; 
				rx2 = 0;
				ry2 = 0;
				wx3 = 0;
				wy3 = 0;
				rx3 = 0;
				ry3 = 0;
				C_d = m_wd;
				m4_pushin_d = 0;
				m4_firstin_d = 0;
				m2_stopin_d = 1;
				NS = m2_write;
				end	
		
		endcase


end
			
always @ (posedge clk or posedge rst)begin
if (rst) begin
m2wr <= 0;
m2wx <= 0;
m2wy <= 0;
m2rx <= 0;
m2ry <= 0;

m_wd <= 0;
round_count <= 0;

m3wr <= 0;
m3wx <= 0;
m3wy <= 0;
m3rx <= 0;
m3ry <= 0;

PS <= reset;
wx3_d<=0;
wy3_d<=0;
end else begin

m2wr <= #1 m2wr_d;
m2wx <= #1 wx2;
m2wy <= #1 wy2;
m2rx <= #1 rx2;
m2ry <= #1 ry2;

m_wd <= #1 C_d;
round_count <= #1 round_count_d;

m3wr <= #1 m3wr_d;
m3wx <= #1 wx3;
m3wy <= #1 wy3;
m3rx <= #1 rx3;
m3ry <= #1 ry3;

PS <= #1 NS;
wy3_d<= #1 wy3;
wx3_d<= #1 wx3;
end
end


endmodule



