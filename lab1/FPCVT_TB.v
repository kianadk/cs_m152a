`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:14:50 04/05/2018
// Design Name:   FPCVT
// Module Name:   /home/ise/m152a_shared_folder/lab1/converter_TB.v
// Project Name:  lab1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: FPCVT
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module FPCVT_TB;

	// Inputs
	reg signed [11:0] D;

	// Outputs
	wire S;
	wire [2:0] E;
	wire [3:0] F;

	// Instantiate the Unit Under Test (UUT)
	FPCVT uut (
		.D(D), 
		.S(S), 
		.E(E), 
		.F(F)
	);

	initial begin
		// Initialize Inputs
		D = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
	
	always begin
	
		#10 D = 0;
		#10 $display("%d converted to %d", D, $signed((-1 ** S) * F * (2 ** E)));
		
		#10 D = 1;
		#10 $display("%d converted to %d", D, $signed((-1 ** S) * F * (2 ** E)));

		#10 D = -1;
		#10 $display("%d converted to %d", D, $signed((-1 ** S) * F * (2 ** E)));

		#10 D = 2047; // largest 2's Complement number
		#10 $display("%d converted to %d", D, $signed((-1 ** S) * F * (2 ** E)));

		#10 D = -2048; // smallest 2's Complement number
		#10 $display("%d converted to %d", D, $signed((-1 ** S) * F * (2 ** E)));
		
		#10 D = 31;
		#10 $display("%d converted to %d", D, $signed((-1 ** S) * F * (2 ** E)));

	end
      
endmodule