`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:45:06 05/30/2018
// Design Name:   vga640x480
// Module Name:   C:/Users/152/Downloads/cs_m152a-master/lab4/vga_tb.v
// Project Name:  NERP_demo
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: vga640x480
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module vga_tb;

	// Inputs
	reg pclk;
	reg [2:0] decode;
    reg [12:0] d_rand;

	// Outputs
	wire hsync;
	wire vsync;
	wire [2:0] red;
	wire [2:0] green;
	wire [1:0] blue;

	// Instantiate the Unit Under Test (UUT)
	vga640x480 uut (
		.pclk(pclk), 
		.decode(decode), 
		.hsync(hsync), 
		.vsync(vsync), 
		.red(red), 
		.green(green), 
		.blue(blue),
        .d_rand(d_rand)
	);

	initial begin
		// Initialize Inputs
		pclk = 0;
		decode = 0;
        d_rand = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		decode = 3'b111;
	end
	
	always begin
	#1 pclk = !pclk;
    d_rand = $random % 13;
   end
		
endmodule

