`timescale 1ns / 1ps
module nexys3(
	input clk,
	output [7:0] seg,
	output [3:0] an,
	output unit_clock,
	output fast_clock,
	output blink_clock
);

wire [3:0] min_ten;
wire [3:0] min_unit;
wire [2:0] sec_ten;
wire [3:0] sec_unit;
	

counter counter_(
	.clock(unit_clock),
	.min_ten(min_ten),
	.min_unit(min_unit),
	.sec_ten(sec_ten),
	.sec_unit(sec_unit));

clock clock_(
    .internal_clk(clk),
    .unit_clock(unit_clock),
    .fast_clock(fast_clock),
    .blink_clock(blink_clock));
	 
display display_(
    .min_ten(min_ten),
    .min_unit(min_unit),
    .sec_ten(sec_ten),
    .sec_unit(sec_unit),
	 .seg(seg),
	 .an(an));
	 
endmodule
