`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:23:32 05/31/2018 
// Design Name: 
// Module Name:    debouncer 
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
module debouncer(
	input i_sig,
	input clk,
	output reg sig
);

wire asig_i;
wire sig;
reg [1:0] asig_ff;

assign asig_i = !i_sig;
assign sig = asig_ff[0];

always @ (posedge clk or posedge asig_i) begin
	if (asig_i)
		asig_ff <= 2'b11;
	else
		asig_ff <= {1'b0, asig_ff[1]};
end

always @ (posedge sig) begin
	score <= score + 1;
end

endmodule
