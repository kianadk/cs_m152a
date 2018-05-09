`timescale 1ns / 1ps
module nexys3(
	input clk,
	input btnR,
	input btnL,
	output [7:0] seg,
	output [3:0] an
);

wire unit_clock;
wire fast_clock;
wire blink_clock;
wire [3:0] min_ten;
wire [3:0] min_unit;
wire [2:0] sec_ten;
wire [3:0] sec_unit;

//////Pause/////////////////////////////////////
wire apse_i;
wire pse;
reg [1:0] apse_ff;
reg pause;

initial begin
	pause <= 0;
end

assign apse_i = btnL;
assign pse = apse_ff[0];

always @ (posedge clk or posedge apse_i) begin
	if (apse_i)
		apse_ff <= 2'b11;
	else
		apse_ff <= {1'b0, apse_ff[1]};
end

always @ (posedge pse) begin
	pause <= !pause;
end
//////////////////////////////////////////////////

//////Reset/////////////////////////////////////
wire arst_i;
wire rst;
reg [1:0] arst_ff;

assign arst_i = btnR;
assign rst = arst_ff[0];

always @ (posedge clk or posedge arst_i) begin
	if (arst_i)
		arst_ff <= 2'b11;
	else
		arst_ff <= {1'b0, arst_ff[1]};
end
//////////////////////////////////////////////////

counter counter_(
	.pause(pause),
	.rst(rst),
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
	 .fast_clock(fast_clock),
    .min_ten(min_ten),
    .min_unit(min_unit),
    .sec_ten(sec_ten),
    .sec_unit(sec_unit),
	 .seg(seg),
	 .an(an));
	 
endmodule
