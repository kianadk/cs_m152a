`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   07:46:51 04/05/2018
// Design Name:   toSgnMag
// Module Name:   /home/ise/Desktop/labs/lab1/toSgnMag_TB.v
// Project Name:  lab1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: toSgnMag
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module toSgnMag_TB;

	// Inputs
	reg [11:0] twosComp;

	// Outputs
	wire [10:0] magnitude;
	wire sign;

	// Instantiate the Unit Under Test (UUT)
	toSgnMag uut (
		.twosComp(twosComp), 
		.magnitude(magnitude), 
		.sign(sign)
	);

	initial begin
		// Initialize Inputs
		twosComp = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
	
	always begin
		#10 twosComp = -2048;
		#10 twosComp = -1;
		#10 twosComp = 0;
		#10 twosComp = 1;
		#10 twosComp = 2047;
	end
      
endmodule

