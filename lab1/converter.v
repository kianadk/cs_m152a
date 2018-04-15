`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:34:50 04/05/2018 
// Design Name: 
// Module Name:    converter 
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
module converter(
    input [11:0] twosComp,
    output sign,
    output [2:0] exponent,
    output [3:0] significand
    );
	 
	wire [10:0] mag;
	wire fifthBit;
	wire [3:0] ip_significand;
	wire [2:0] ip_exponent;
	
	toSgnMag mod1(
		.twosComp(twosComp),
		.magnitude(mag),
		.sign(sign)
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
		.final_exponent(exponent),
		.final_significand(significand)
	);
endmodule
