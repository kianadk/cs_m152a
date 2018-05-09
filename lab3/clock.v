`timescale 1ns / 1ps

module clock(
    input internal_clk,
    output reg unit_clock,
    output reg fast_clock,
    output reg blink_clock
    );
	 
reg [26:0] unit_count;
reg [26:0] fast_count;
reg [26:0] blink_count;

initial begin
	unit_clock <= 0;
	fast_clock <= 0;
	blink_clock <= 0;
	
	unit_count <= 0;
	fast_count <= 0;
	blink_count <= 0;
end

always @ (posedge internal_clk) begin
	if (unit_count == 50000000) begin
		unit_count <= 0;
		unit_clock = !unit_clock;
	end
	else begin
		unit_count <= unit_count + 1;
	end
end

always @ (posedge internal_clk) begin
	if (fast_count == 300000) begin
		fast_count <= 0;
		fast_clock = !fast_clock;
	end
	else begin
		fast_count <= fast_count + 1;
	end
end

always @ (posedge internal_clk) begin
	if (blink_count == 25000000) begin
		blink_count <= 0;
		blink_clock = !blink_clock;
	end
	else begin
		blink_count <= blink_count + 1;
	end
end

endmodule
