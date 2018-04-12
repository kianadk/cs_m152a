`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:21:07 04/05/2018 
// Design Name: 
// Module Name:    fpConvert 
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
module fpConvert(
    input [10:0] number,
    output reg [3:0] significand,
    output reg [2:0] exponent,
    output reg fifthBit
    );
	
	always @ (number) begin
		
		// 0 leading zeros
		if (number[10] != 0) begin
			significand = number[10:7];
			exponent = 7;
			fifthBit = number[6];
		end
		
		// 1 leading zeros
		else if (number[9] != 0) begin
			significand = number[9:6];
			exponent = 6;
			fifthBit = number[5];
		end
		
		// 2 leading zeros
		else if (number[8] != 0) begin
			significand = number[8:5];
			exponent = 5;
			fifthBit = number[4];
		end
		
		// 3 leading zeros
		else if (number[7] != 0) begin
			significand = number[7:4];
			exponent = 4;
			fifthBit = number[3];
		end
		
		// 4 leading zeros
		else if (number[6] != 0) begin
			significand = number[6:3];
			exponent = 3;
			fifthBit = number[2];
		end
		
		// 5 leading zeros
		else if (number[5] != 0) begin
			significand = number[5:2];
			exponent = 2;
			fifthBit = number[1];
		end
		
		// 6 leading zeros
		else if (number[4] != 0) begin
			significand = number[4:1];
			exponent = 1;
			fifthBit = number[0];
		end
		
		// 7+ leading zeros
		else begin
			significand = number[3:0];
			exponent = 0;
			fifthBit = 0;
		end
		
	end

endmodule
