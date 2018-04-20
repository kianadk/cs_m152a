`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   08:47:54 04/05/2018
// Design Name:   fpConvert
// Module Name:   /home/ise/Desktop/labs/lab1/fpConvert_TB.v
// Project Name:  lab1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: fpConvert
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module fpConvert_TB;

	// Inputs
	reg [10:0] number;

	// Outputs
	wire [3:0] significand;
	wire [2:0] exponent;
	wire fifthBit;

	// Instantiate the Unit Under Test (UUT)
	fpConvert uut (
		.number(number), 
		.significand(significand), 
		.exponent(exponent), 
		.fifthBit(fifthBit)
	);

	initial begin
		// Initialize Inputs
		number = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
	
	always begin
		#10 number = 8;
		#10 number = 16;
		#10 number = 32;
		#10 number = 64;
		#10 number = 128;
		#10 number = 256;
		#10 number = 512;
		#10 number = 1024;
	end
      
endmodule

