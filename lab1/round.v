`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:10:39 04/05/2018 
// Design Name: 
// Module Name:    round 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module round(
    input [2:0] exponent,
    input [3:0] significand,
    input fifthBit,
    output [2:0] final_exponent,
    output [3:0] final_significand
    );
	 
	 always @ * begin
		if (fifthBit == 1) begin
			if (significand == 4'b111) begin
				significand = (significand >> 1); //TODO: double check logic
				exponent <= exponent + 1;	// TODO: make sure exponent doesn't overflow
			end
			
			else begin
				significand <= exponent + 1;
			end
			
			final_exponent <= exponent;
			final_significand <= significand;
		end
		
		else begin
			final_exponent <= exponent;
			final_significand <= significand;
		end
	 end


endmodule
