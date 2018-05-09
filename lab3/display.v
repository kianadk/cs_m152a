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
    input min_ten,
    input min_unit,
    input sec_ten,
    input sec_unit,
	 output reg [7:0] seg,
	 output reg [3:0] an
);

initial begin
	seg[0] = 1;
	an[0] = 1;
end

endmodule
