`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:44:10 05/21/2018 
// Design Name: 
// Module Name:    clock 
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
module clock(
	input clk,
	output reg pixel_clk
);

reg [3:0] pixel_count;

initial begin
	pixel_clk <= 0;
	pixel_count <= 0;
end

always @ (posedge clk) begin
	if (pixel_count == 1) begin
		pixel_count <= 0;
		pixel_clk <= !pixel_clk;
	end
	else begin
		pixel_count <= pixel_count + 1;
	end
end

endmodule
