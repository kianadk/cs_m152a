`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:15:40 05/07/2018 
// Design Name: 
// Module Name:    display 
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
module display(
    input [3:0] min_ten,
    input [3:0] min_unit,
    input [2:0] sec_ten,
    input [3:0] sec_unit,
	 output reg [7:0] seg,
	 output reg [3:0] an
);

always begin
	an <= 4'b0000;
	case (sec_unit)
		4'b0000:
			seg <= 8'b11000000;
		4'b0001:
			seg <= 8'b11001111;
		4'b0010:
			seg <= 8'b10100100;
		4'b0011:
			seg <= 8'b10110000;
		4'b0100:
			seg <= 8'b10011001;
		4'b0101:
			seg <= 8'b10010010;
		4'b0110:
			seg <= 8'b10000010;
		4'b0111:
			seg <= 8'b11111000;
		4'b1000:
			seg <= 8'b10000000;
		4'b1001:
			seg <= 8'b10011000;
   	default:
			seg <= 8'b10000110;
	endcase
end

endmodule
