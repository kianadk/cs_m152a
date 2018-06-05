`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:49:36 03/19/2013 
// Design Name: 
// Module Name:    clockdiv 
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
module clockdiv(
	input wire clk,		//master clock: 100MHz
	output wire pclk,		//pixel clock: 25MHz
    output wire sclk,
	 output wire bclk,
	 output wire sec_clk
);

initial begin
 counter <= 0;
 end

// 17-bit counter variable
reg [31:0] counter;

// Clock divider --
// Each bit in q is a clock signal that is
// only a fraction of the master clock.
always @(posedge clk)
begin
	counter <= counter + 1;
end

// 100Mhz  2^2 = 25MHz
assign pclk = counter[1];
assign sclk = counter[10];
assign bclk = counter[20];
assign sec_clk = counter[23];
endmodule
