module perm_blk (input clk, input rst, input pushin, output reg stopin,
input firstin, input [63:0] din,
output reg [2:0] m1rx, output reg [2:0] m1ry,
input [63:0] m1rd,
output reg [2:0] m1wx, output reg [2:0] m1wy,output reg m1wr,
output reg [63:0] m1wd,
output reg [2:0] m2rx, output reg [2:0] m2ry,
input [63:0] m2rd,
output reg [2:0] m2wx, output reg [2:0] m2wy,output reg m2wr,
output reg [63:0] m2wd,
output reg [2:0] m3rx, output reg [2:0] m3ry,
input [63:0] m3rd,
output reg [2:0] m3wx, output reg [2:0] m3wy,output reg m3wr,
output reg [63:0] m3wd,
output reg [2:0] m4rx, output reg [2:0] m4ry,
input [63:0] m4rd,
output reg [2:0] m4wx, output reg [2:0] m4wy,output reg m4wr,
output reg [63:0] m4wd,
output reg pushout, input stopout, output reg firstout, output reg [63:0] dout);

reg m2_pushin,m2_firstin,m4_firstin,m4_pushin;
reg full;
reg stopin_d,m1wr_d;
wire m2stopin,m4stopin;

in in1(.clk(clk),.rst(rst),.pushin(pushin),.firstin(firstin),.din(din),.m1wx(m1wx),.m1wy(m1wy),.m1wd(m1wd),.stopin(stopin),.m1wr(m1wr), .m1rx(m1rx),.m1ry(m1ry),.m2_pushin(m2_pushin), .m2_firstin(m2_firstin),.m1_stopout(m2stopin));

rounds r1(.clk(clk),.rst(rst),.din(m1rd), .pushin(m2_pushin), .firstin(m2_firstin), .m2_stopin(m2stopin),
							.m2rd(m2rd), .m2wd(m2wd), .m2wr(m2wr), .m2wx(m2wx),
							.m2wy(m2wy), .m2rx(m2rx), .m2ry(m2ry),.m3rd(m3rd), 
							.m3wd(m3wd), .m3wr(m3wr), .m3wx(m3wx), .m3wy(m3wy),
							.m3rx(m3rx), .m3ry(m3ry),.stopout(m4stopin),.m4_pushin(m4_pushin),.m4_firstin(m4_firstin));

 

 out out1(.clk(clk),.rst(rst), .pushin(m4_pushin),.firstin(m4_firstin),.din(m2rd), .m4wx(m4wx),
.m4wy(m4wy),.m4wd(m4wd),.m4_stopin(m4stopin),.m4wr(m4wr),.m4rx(m4rx),.m4ry(m4ry), .pushout(pushout),.firstout(firstout),.stopout(stopout));


assign dout = m4rd;


endmodule
`include "./in.sv"
`include "./out.sv"
`include "./rounds.sv"

