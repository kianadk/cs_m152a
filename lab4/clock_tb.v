`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:49:27 05/21/2018
// Design Name:   clock
// Module Name:   C:/Users/152/lab4/clock_tb.v
// Project Name:  lab4
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: clock
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module clock_tb;

	// Inputs
	reg clk;

	// Outputs
	wire pixel_clk;

	// Instantiate the Unit Under Test (UUT)
	clock uut (
		.clk(clk),
		.pixel_clk(pixel_clk)
	);

	initial begin
		// Initialize Inputs
		clk <= 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
	
	always begin
		#1 clk = !clk;
	end
      
endmodule

