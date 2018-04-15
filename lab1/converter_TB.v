`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:14:50 04/05/2018
// Design Name:   converter
// Module Name:   /home/ise/m152a_shared_folder/lab1/converter_TB.v
// Project Name:  lab1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: converter
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module converter_TB;

	// Inputs
	reg signed [11:0] twosComp;

	// Outputs
	wire sign;
	wire [2:0] exponent;
	wire [3:0] significand;

	// Instantiate the Unit Under Test (UUT)
	converter uut (
		.twosComp(twosComp), 
		.sign(sign), 
		.exponent(exponent), 
		.significand(significand)
	);

	initial begin
		// Initialize Inputs
		twosComp = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
	
	always begin
	
		#10 twosComp = 0;
		#10 $display("%d converted to %d", twosComp, $signed((-1 ** sign) * significand * (2 ** exponent)));
		
		#10 twosComp = 1;
		#10 $display("%d converted to %d", twosComp, $signed((-1 ** sign) * significand * (2 ** exponent)));

		#10 twosComp = -1;
		#10 $display("%d converted to %d", twosComp, $signed((-1 ** sign) * significand * (2 ** exponent)));

		#10 twosComp = 100;
		#10 $display("%d converted to %d", twosComp, $signed((-1 ** sign) * significand * (2 ** exponent)));

		#10 twosComp = 2047; // largest 2's Complement number
		#10 $display("%d converted to %d", twosComp, $signed((-1 ** sign) * significand * (2 ** exponent)));
		
		#10 twosComp = 2046;
		#10 $display("%d converted to %d", twosComp, $signed((-1 ** sign) * significand * (2 ** exponent)));
		
		#10 twosComp = -2048; // smallest 2's Complement number
		#10 $display("%d converted to %d", twosComp, $signed((-1 ** sign) * significand * (2 ** exponent)));
		
		#10 twosComp = -2047;
		#10 $display("%d converted to %d", twosComp, $signed((-1 ** sign) * significand * (2 ** exponent)));
	end
      
endmodule

