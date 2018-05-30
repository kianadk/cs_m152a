`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:30:38 03/19/2013 
// Design Name: 
// Module Name:    vga640x480 
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
module vga640x480(
	input wire pclk,			//pixel clock: 25MHz
    input wire [2:0] decode,
	output wire hsync,		//horizontal sync out
	output wire vsync,		//vertical sync out
	output wire [2:0] red,	//red vga output
	output wire [2:0] green, //green vga output
	output wire [1:0] blue	//blue vga output
	);

// video structure constants
parameter hpixels = 800;// horizontal pixels per line
parameter vlines = 521; // vertical lines per frame
parameter frames = 600; // number of frames for video
parameter hpulse = 96; 	// hsync pulse length
parameter vpulse = 2; 	// vsync pulse length
parameter hbp = 144; 	// end of horizontal back porch
parameter hfp = 784; 	// beginning of horizontal front porch
parameter vbp = 31; 		// end of vertical back porch
parameter vfp = 511; 	// beginning of vertical front porch
// active horizontal video is therefore: 784 - 144 = 640
// active vertical video is therefore: 511 - 31 = 480

// registers for storing the horizontal & vertical counters
reg [9:0] hc;
reg [9:0] vc;

// register for storing the frame counter
reg [7:0] fc;
reg [7:0] d_fc;
reg [25:0] d_rand;
reg d_visible;
reg [9:0] d_vc;
reg [9:0] d_hc;

initial begin
	d_visible <= 0;
	d_rand <= 1;
	vc <= 0;
	hc <= 0;
end

// Counters --
always @(posedge pclk)
begin
	// keep counting until the end of the line
	if (hc < hpixels - 1)
		hc <= hc + 1;
	else
	// When we hit the end of the line, reset the horizontal
	// counter and increment the vertical counter.
	// If vertical counter is at the end of the frame, then
	// reset that one too.
	begin
		hc <= 0;
		if (vc < vlines - 1)
			vc <= vc + 1;
		else begin
			vc <= 0;
			if (fc < frames - 1)
				fc <= fc + 1;
			else
				fc <= 0;
		end
	end
end

always @ (posedge pclk) begin
	d_rand <= d_rand + 1;
end

always @ (posedge pclk) begin
	// d_rand <= $random % 2;
	if (d_visible == 1 && vc == d_vc && hc == d_hc) begin
		$display("incrementing");
		$display(hc);
		if (d_fc < frames - 1)
			d_fc <= d_fc + 1;
		else begin
			d_visible <= 0;
		end
	end	

	if (d_rand == 0 && d_visible == 0) begin
		$display("triggered");
		d_visible <= 1;
		d_fc <= 0;
		d_vc <= vc;
		d_hc <= hc;
	end
end

// generate sync pulses (active low)
// ----------------
// "assign" statements are a quick way to
// give values to variables of type: wire
assign hsync = (hc < hpulse) ? 0:1;
assign vsync = (vc < vpulse) ? 0:1;

down_arrow _down_arrow(
    .decode(decode),
	.hc(hc),
	.vc(vc),
	.u_left(344),
	.u_right(424),
	.d_top(vbp+d_fc+80),
	.d_bottom(vbp+d_fc),
	.top(vbp+fc+80),
	.bottom(vbp+fc),
	.red(red),
	.green(green),
	.blue(blue)
);

endmodule
