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
	input [2:0] i_sig,
	input [2:0] goal_sig,
	input clk,
	output sig
);

wire asig_i;
reg [1:0] asig_ff;

assign asig_i = (i_sig == goal_sig);
assign sig = asig_ff[0];

always @ (posedge clk or posedge asig_i) begin
	if (asig_i)
		asig_ff <= 2'b11;
	else
		asig_ff <= {1'b0, asig_ff[1]};
end

endmodule
