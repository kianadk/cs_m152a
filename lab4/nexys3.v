`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:20:16 05/21/2018 
// Design Name: 
// Module Name:    nexys3 
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
module nexys3(
	input clk,
	output [2:0] vgaRed,
    output [2:0] vgaGreen,
    output [1:0] vgaBlue,
	input Hsync,
	input Vsync
);

wire pixel_clk;

clock clock_(
	.clk(clk),
	.pixel_clk(pixel_clk)
);

sync sync_(
	.pixel_clk(pixel_clk),
	.Hsync(Hsync),
	.Vsync(Vsync),
    .red(vgaRed),
    .green(vgaGreen),
    .blue(vgaBlue)
);

endmodule
