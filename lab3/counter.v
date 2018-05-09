`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    07:35:45 05/08/2018 
// Design Name: 
// Module Name:    counter 
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
module counter(
	input rst,
	input clock,
	output reg [3:0] min_ten,
	output reg [3:0] min_unit,
	output reg [2:0] sec_ten,
	output reg [3:0] sec_unit);
	
always @ (posedge clock or posedge rst) begin
	if (rst) begin
		sec_unit <= 0;
		sec_ten <= 0;
		min_unit <= 0;
		min_ten <= 0;
	end
	else begin
		if (sec_unit == 9) begin
			if (sec_ten == 5) begin
				if (min_unit == 9) begin
					sec_unit <= 0;
					sec_ten <= 0;
					min_unit <= 0;
					min_ten <= min_ten + 1;
				end
				else begin
					sec_unit <= 0;
					sec_ten <= 0;
					min_unit <= min_unit + 1;
				end
			end
			else begin
				sec_unit <= 0;
				sec_ten <= sec_ten + 1;
			end
		end
		else begin
			sec_unit <= sec_unit + 1;
		end
	end
end


endmodule
