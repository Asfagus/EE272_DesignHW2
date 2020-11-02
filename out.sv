//temp bugs fix
typedef enum bit [1:0] {Reset,m4_write,m4_read,out_idle} out_state ;
module out(input clk,input rst,input pushin,input firstin,input [63:0] din, output reg [2:0] m4wx,
output reg [2:0] m4wy,output reg [63:0] m4wd,output reg m4_stopin,output reg m4wr,output reg [2:0] m4rx, output reg[2:0] m4ry, output reg pushout,output reg firstout, input stopout);

reg [4:0] count, count_d;
reg [2:0] wx4,wy4,wx4_d,wy4_d;
reg [2:0] rx4,ry4;
reg stopin_d,data_loaded_d;
reg m4wr_d;
reg pushout_d,m4_stopin_d,firstout_d;

out_state PS,NS;

assign m4_stopin = m4_stopin_d;
//assign pushout = pushout_d;
//assign firstout = firstout_d; //make a flip flop

always @ (*) begin
case (PS)
Reset: begin
    m4wr_d = 0;
    wx4 = 0;
    wy4 = 0;
rx4 = 0;
ry4 = 0;
m4_stopin_d = 0;
pushout_d = 0;
firstout_d = 0;
    NS = m4_write;
    end

m4_write: begin

ry4 = 0;
rx4 = 0;
//pushout_d = 0;
//firstout_d = 0;

if(m4wx == 4 & m4wy == 4)begin
m4wr_d = 0;
end else begin
m4wr_d = pushin;
end

if(m4wx == 4 & m4wy == 4)begin
m4_stopin_d = 1;
pushout_d = 1;
firstout_d = 1;
NS = m4_read;
end else begin
pushout_d = 0;
firstout_d = 0;
m4_stopin_d = 0;
NS = m4_write;
end


case({pushin,firstin})
   
      2'b11: begin
wx4 = 0;
      wy4 = 0;

      end

      2'b10: begin

if (m4wx == 4 & m4wy == 4)begin
wx4 = m4wx;
end else if (m4wx == 4) begin
wx4 = 0;
end else begin
wx4 = m4wx +1;
end
 
    if (m4wx == 4 & m4wy == 4) begin
wy4 = m4wy;
end else if (m4wx == 4)begin
wy4 = m4wy + 1;
end else begin
wy4 = m4wy;
end

end
     
default: begin

wx4 = m4wx;
wy4 = m4wy;

end

endcase

end

m4_read: begin

m4_stopin_d = 1;
wx4 = 0;
wy4 = 0;
m4wr_d = 0;

if(stopout)begin
rx4 = m4rx;
ry4 = m4ry;
NS = PS;
pushout_d = pushout;
firstout_d = firstout;
end else begin

if(m4rx == 4)
rx4 = 0;
else
rx4 = m4rx + 1;

if(m4ry == 4 & m4rx == 4)
ry4 = 0;
else if(m4rx == 4)
ry4 = m4ry + 1;
else
ry4 = m4ry;


pushout_d = 1;
firstout_d = 0;

if(m4ry == 4 & m4rx == 4)begin
NS = out_idle;
pushout_d = 0;
end else begin
NS = m4_read;
end
/*if(m4ry == 0 & m4rx == 0)begin
pushout_d = 1;
firstout_d = 1;
end else begin
pushout_d = 1;
firstout_d = 0;
end*/

end
end

out_idle: begin

rx4 = 0;
ry4 = 0;
wx4 = 0;
wy4 = 0;
m4wr_d = 0;
m4_stopin_d = 1;
pushout_d = 0;
firstout_d = 0;
NS = m4_write;

end

endcase
end

always @ (posedge clk or posedge rst)begin
    if(rst)begin
      m4wr <= 0;
      m4wx <= 0;
      m4wy <= 0;
m4rx <= 0;
m4ry <= 0;
m4wd <= 0;
      PS  <= Reset;
      firstout<=0;
      pushout<= 0;
    end else begin
      m4wr <= #1 m4wr_d;
      m4wx <= #1 wx4;
      m4wy <= #1 wy4;
m4rx <= #1 rx4;
m4ry <= #1 ry4;
m4wd <= #1 din;
      PS <= #1  NS;
      firstout<= #1 firstout_d;
      pushout<= #1 pushout_d;
   
   end
end

endmodule
