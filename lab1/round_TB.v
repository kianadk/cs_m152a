`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:53:50 04/05/2018
// Design Name:   round
// Module Name:   /home/ise/m152a_shared_folder/lab1/round_TB.v
// Project Name:  lab1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: round
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module round_TB;

	// Inputs
	reg [2:0] exponent;
	reg [3:0] significand;
	reg fifthBit;

	// Outputs
	wire [2:0] final_exponent;
	wire [3:0] final_significand;

	// Instantiate the Unit Under Test (UUT)
	round uut (
		.exponent(exponent), 
		.significand(significand), 
		.fifthBit(fifthBit), 
		.final_exponent(final_exponent), 
		.final_significand(final_significand)
	);

	initial begin
		// Initialize Inputs
		exponent = 0;
		significand = 0;
		fifthBit = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
	end
	
	always begin
		#10 fifthBit = 0; //no rounding
		#10 fifthBit = 1;	// just increment significand
		#10 significand = 15; //significand overflows => shift & increment significand, increment exponent
		#10 exponent = 7; // exponent and significand overflow => use largest possible floating point
	end
      
endmodule

