`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:28:25 03/19/2013 
// Design Name: 
// Module Name:    NERP_demo_top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module NERP_demo_top(
	input wire clk,			//master clock = 100MHz
	output wire [2:0] red,	//red vga output - 3 bits
	output wire [2:0] green,//green vga output - 3 bits
	output wire [1:0] blue,	//blue vga output - 2 bits
	output wire hsync,		//horizontal sync out
	output wire vsync,			//vertical sync out
    inout wire [7:0] JA
	);
    
wire [2:0] Decode;
wire [12:0] d_rand;
wire [12:0] u_rand;
wire [12:0] l_rand;
wire [12:0] r_rand;
wire l_arrow;
wire r_arrow;
wire u_arrow;
wire d_arrow;
wire enter;

// VGA display clock interconnect
wire pclk;
wire sclk;
wire bclk;
wire sec_clk;

// disable the 7-segment decimal points
assign dp = 1;

// generate 7-segment clock & display clock
clockdiv U1(
	.clk(clk),
	.pclk(pclk),
    .sclk(sclk),
	 .bclk(bclk),
	 .sec_clk(sec_clk)
);

// VGA controller
vga640x480 U3(
	.pclk(pclk),
	.hsync(hsync),
	.vsync(vsync),
	.red(red),
	.green(green),
	.blue(blue),
   .decode(Decode),
	.l_arrow(l_arrow),
	.r_arrow(r_arrow),
	.u_arrow(u_arrow),
	.d_arrow(d_arrow),
	.enter(enter),
   .d_rand(d_rand),
   .u_rand(u_rand),
   .l_rand(l_rand),
   .r_rand(r_rand),
	.bclk(bclk),
	.sec_clk(sec_clk)
);

debouncer e_debouncer(
	.i_sig(Decode),
	.goal_sig(3'b100),
	.clk(bclk),
	.sig(enter)
);

debouncer l_debouncer(
	.i_sig(Decode),
	.goal_sig(3'b000),
	.clk(bclk),
	.sig(l_arrow)
);

debouncer r_debouncer(
	.i_sig(Decode),
	.goal_sig(3'b001),
	.clk(bclk),
	.sig(r_arrow)
);

debouncer u_debouncer(
	.i_sig(Decode),
	.goal_sig(3'b010),
	.clk(bclk),
	.sig(u_arrow)
);

debouncer d_debouncer(
	.i_sig(Decode),
	.goal_sig(3'b011),
	.clk(bclk),
	.sig(d_arrow)
);
    
Decoder C0(
    .clk(clk),
    .Row(JA[7:4]),
	.Col(JA[3:0]),
	.DecodeOut(Decode)
);

LFSR d_LFSR(
    .clk(sclk),
    .rand(d_rand)
);

LFSR2 u_LFSR(
    .clk(sclk),
    .rand(u_rand)
);

LFSR3 l_LFSR(
    .clk(sclk),
    .rand(l_rand)
);

LFSR4 r_LFSR(
    .clk(sclk),
    .rand(r_rand)
);

endmodule
