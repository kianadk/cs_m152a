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
    output reg [2:0] final_exponent,
    output reg [3:0] final_significand
    );
	 
	 always @ * begin
		if (fifthBit == 1) begin
			if (significand == 4'b1111) begin
			$display("hi");
				if (exponent == 3'b111) begin
					final_significand <= significand;
					final_exponent <= exponent;
				end
				else begin
					final_significand = (significand >> 1);
					final_exponent <= exponent + 1;
				end
			end
			
			else begin
				final_significand <= significand + 1;
				final_exponent <= exponent;
			end
		end
		
		else begin
			final_exponent <= exponent;
			final_significand <= significand;
		end
	 end


endmodule
