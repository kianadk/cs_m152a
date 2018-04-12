`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    07:38:40 04/05/2018 
// Design Name: 
// Module Name:    toSgnMag 
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
module toSgnMag(
    input [11:0] twosComp,
    output reg [10:0] magnitude,
	 output reg sign
    );
	 
	 always @ (twosComp) begin
		if (twosComp[11] == 0) begin
			sign <= 0;
			magnitude <= twosComp[10:0];
		end
		
		else begin
			sign <= 1;
			
			// check for -2048 overflow
			if (twosComp[10:0] == 0) begin
				magnitude <= 2047;
			end
			
			else begin
				magnitude <= (~twosComp + 1);
			end
			
		end
	 end
	 


endmodule
