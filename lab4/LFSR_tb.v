`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:10:34 05/31/2018
// Design Name:   LFSR
// Module Name:   C:/Users/152/Downloads/cs_m152a-master/lab4/LFSR_tb.v
// Project Name:  NERP_demo
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: LFSR
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module LFSR_tb;

	// Inputs
	reg clk;
    reg seed;

	// Outputs
	wire [29:0] rand;

	// Instantiate the Unit Under Test (UUT)
	LFSR uut (
		.clk(clk), 
		.rand(rand)
	);

	initial begin
		// Initialize Inputs
		clk = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
    
    always begin
        #1 clk = !clk;
    end
      
endmodule

