`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:56:50 05/23/2018 
// Design Name: 
// Module Name:    up_arrow 
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
module up_arrow(
	input [9:0] hc,
	input [9:0] vc,
	input [9:0] fc,
	input [9:0] left,
	input [9:0] right,
	input [9:0] top,
	input [9:0] bottom,
	output reg [2:0] red,
	output reg [2:0] green,
	output reg [1:0] blue
);

wire [9:0] width;
assign width = right - left;
wire [9:0] height;
assign height = top - bottom;
wire [9:0] offset;
assign offset = vc - (bottom + height / 2);

always @ (hc, vc) begin
	if (hc >= left && hc < right && vc >= bottom && vc < top) begin
	
		if (vc <= bottom + (height / 2)) begin
			if (hc >= left + width / 3 && hc < right - width / 3) begin
				red = 3'b111;
				green = 3'b111;
				blue = 2'b11;
			end
			else begin
				red = 3'b000;
				green = 3'b000;
				blue = 2'b00;
			end
		end

	   else if (hc >= left + offset && hc < right - offset) begin
			red = 3'b111;
			green = 3'b111;
			blue = 2'b11;
		end
		
		else begin
			red = 3'b000;
			green = 3'b000;
			blue = 2'b00;
		end

	end
	else begin
			red = 3'b000;
			green = 3'b000;
			blue = 2'b00;
	end
end

endmodule
