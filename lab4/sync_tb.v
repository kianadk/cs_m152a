`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:21:34 05/21/2018
// Design Name:   sync
// Module Name:   C:/Users/152/lab4/sync_tb.v
// Project Name:  lab4
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: sync
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module sync_tb;

	// Inputs
	reg pixel_clk;

	// Outputs
	wire Vsync;
	wire Hsync;
    wire [2:0] red;
    wire [2:0] green;
    wire [1:0] blue;

	// Instantiate the Unit Under Test (UUT)
	sync uut (
		.pixel_clk(pixel_clk), 
		.Vsync(Vsync), 
		.Hsync(Hsync),
        .red(red),
        .green(green),
        .blue(blue)
	);

	initial begin
		// Initialize Inputs
		pixel_clk = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
	
always begin
	#1 pixel_clk = !pixel_clk;
end
      
endmodule

