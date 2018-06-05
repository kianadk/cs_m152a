`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:15:03 06/05/2018
// Design Name:   clockdiv
// Module Name:   /home/ise/m152a_shared_folder/lab4/clock_tb.v
// Project Name:  NERP_demo
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: clockdiv
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
	wire pclk;
	wire sclk;
	wire bclk;
	wire sec_clk;

	// Instantiate the Unit Under Test (UUT)
	clockdiv uut (
		.clk(clk), 
		.pclk(pclk), 
		.sclk(sclk), 
		.bclk(bclk), 
		.sec_clk(sec_clk)
	);

	initial begin
		// Initialize Inputs
		clk = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
	
	always begin
		#1 clk <= !clk;
	end
      
endmodule

