`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:29:29 05/31/2018
// Design Name:   down_arrow
// Module Name:   C:/Users/152/Downloads/cs_m152a-master/lab4/game_tb.v
// Project Name:  NERP_demo
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: down_arrow
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module game_tb;

	// Inputs
	reg sclk;
	reg [2:0] decode;
	reg [9:0] hc;
	reg [9:0] vc;
	reg [9:0] d_top;
	reg [9:0] d_bottom;
	reg [9:0] u_top;
	reg [9:0] u_bottom;
	reg [9:0] l_top;
	reg [9:0] l_bottom;
	reg [9:0] r_top;
	reg [9:0] r_bottom;
	reg [9:0] d_vc;
	reg [9:0] top;
	reg [9:0] bottom;
	reg [9:0] u_left;
	reg [9:0] u_right;
	reg d_visible;
	reg u_visible;
	reg l_visible;
	reg r_visible;

	// Outputs
	wire [2:0] red;
	wire [2:0] green;
	wire [1:0] blue;

	// Instantiate the Unit Under Test (UUT)
	down_arrow uut (
		.sclk(sclk), 
		.decode(decode), 
		.hc(hc), 
		.vc(vc), 
		.d_top(d_top), 
		.d_bottom(d_bottom), 
		.u_top(u_top), 
		.u_bottom(u_bottom), 
		.l_top(l_top), 
		.l_bottom(l_bottom), 
		.r_top(r_top), 
		.r_bottom(r_bottom), 
		.d_vc(d_vc), 
		.top(top), 
		.bottom(bottom), 
		.u_left(u_left), 
		.u_right(u_right), 
		.d_visible(d_visible), 
		.u_visible(u_visible), 
		.l_visible(l_visible), 
		.r_visible(r_visible), 
		.red(red), 
		.green(green), 
		.blue(blue)
	);

	initial begin
		// Initialize Inputs
		sclk = 0;
		decode = 0;
		hc = 0;
		vc = 0;
		d_top = 0;
		d_bottom = 0;
		u_top = 0;
		u_bottom = 0;
		l_top = 0;
		l_bottom = 0;
		r_top = 0;
		r_bottom = 0;
		d_vc = 0;
		top = 0;
		bottom = 0;
		u_left = 0;
		u_right = 0;
		d_visible = 0;
		u_visible = 0;
		l_visible = 0;
		r_visible = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
	
	always begin
		#1 sclk = !sclk;
		#100 decode = !decode;
	end
      
endmodule

