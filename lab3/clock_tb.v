`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:41:52 05/07/2018
// Design Name:   clock
// Module Name:   /home/ise/m152a_shared_folder/lab3/clock_tb.v
// Project Name:  lab3
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
	reg internal_clk;

	// Outputs
	wire unit_clock;
	wire fast_clock;
	wire blink_clock;

	// Instantiate the Unit Under Test (UUT)
	clock uut (
		.internal_clk(internal_clk), 
		.unit_clock(unit_clock), 
		.fast_clock(fast_clock), 
		.blink_clock(blink_clock)
	);

	initial begin
		// Initialize Inputs
		internal_clk = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
	always
		#1 internal_clk = !internal_clk;
endmodule

