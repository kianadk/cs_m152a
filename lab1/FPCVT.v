`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:34:50 04/05/2018 
// Design Name: 
// Module Name:    FPCVT 
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
module FPCVT(
    input [11:0] D,
    output S,
    output [2:0] E,
    output [3:0] F
    );
	 
	wire [10:0] mag;
	wire fifthBit;
	wire [3:0] ip_significand;
	wire [2:0] ip_exponent;
	
	toSgnMag mod1(
		.twosComp(D),
		.magnitude(mag),
		.sign(S)
	);
	
	fpConvert mod2(
		.number(mag),
		.significand(ip_significand),
		.exponent(ip_exponent),
		.fifthBit(fifthBit)
	);
	
	round mod3(
		.exponent(ip_exponent),
		.significand(ip_significand),
		.fifthBit(fifthBit),
		.final_exponent(E),
		.final_significand(F)
	);
endmodule
