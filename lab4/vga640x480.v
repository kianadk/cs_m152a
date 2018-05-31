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
    input wire [12:0] d_rand,
    input wire [12:0] u_rand,
    input wire [12:0] l_rand,
    input wire [12:0] r_rand,
	 input bclk,
	output wire hsync,		//horizontal sync out
	output wire vsync,		//vertical sync out
	output wire [2:0] red,	//red vga output
	output wire [2:0] green, //green vga output
	output wire [1:0] blue	//blue vga output
	);

// video structure constants
parameter hpixels = 800;// horizontal pixels per line
parameter vlines = 521; // vertical lines per frame
parameter frames = 200; // number of frames for video
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
reg d_visible;
reg [9:0] d_vc;
reg [9:0] d_hc;

reg [7:0] u_fc, l_fc, r_fc;
reg u_visible, l_visible, r_visible;
reg [9:0] u_vc, l_vc, r_vc;
reg [9:0] u_hc, l_hc, r_hc;

initial begin
	d_visible <= 0;
    u_visible <= 0;
    l_visible <= 0;
    r_visible <= 0;
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
	if (d_visible == 1 && vc == d_vc && hc == d_hc) begin
		if (d_fc < frames - 1)
			d_fc <= d_fc + 4;
		else begin
			d_visible <= 0;
		end
	end	

	if (d_rand == 5 && d_visible == 0) begin
		d_visible <= 1;
		d_fc <= 0;
		d_vc <= vc;
		d_hc <= hc;
	end
end

always @ (posedge pclk) begin
	if (u_visible == 1 && vc == u_vc && hc == u_hc) begin
		if (u_fc < frames - 1)
			u_fc <= u_fc + 1;
		else begin
			u_visible <= 0;
		end
	end	

	if (u_rand == 5 && u_visible == 0) begin
		u_visible <= 1;
		u_fc <= 0;
		u_vc <= vc;
		u_hc <= hc;
	end
end

//left
always @ (posedge pclk) begin
	if (l_visible == 1 && vc == l_vc && hc == l_hc) begin
		if (l_fc < frames - 1)
			l_fc <= l_fc + 1;
		else begin
			l_visible <= 0;
		end
	end	

	if (l_rand == 5 && l_visible == 0) begin
		l_visible <= 1;
		l_fc <= 0;
		l_vc <= vc;
		l_hc <= hc;
	end
end

//right
always @ (posedge pclk) begin
	if (r_visible == 1 && vc == r_vc && hc == r_hc) begin
		if (r_fc < frames - 1)
			r_fc <= r_fc + 1;
		else begin
			r_visible <= 0;
		end
	end	

	if (r_rand == 5 && r_visible == 0) begin
		r_visible <= 1;
		r_fc <= 0;
		r_vc <= vc;
		r_hc <= hc;
	end
end
// generate sync pulses (active low)
// ----------------
// "assign" statements are a quick way to
// give values to variables of type: wire
assign hsync = (hc < hpulse) ? 0:1;
assign vsync = (vc < vpulse) ? 0:1;

down_arrow _down_arrow(
	.bclk(bclk),
    .decode(decode),
	.hc(hc),
	.vc(vc),
	.u_left(344),
	.u_right(424),
	.d_top(vbp+d_fc+80),
	.d_bottom(vbp+d_fc),
	.u_top(vbp+u_fc+80),
	.u_bottom(vbp+u_fc),
    .l_top(vbp+l_fc+80),
	.l_bottom(vbp+l_fc),
    .r_top(vbp+r_fc+80),
	.r_bottom(vbp+r_fc),
	.top(vbp+fc+80),
	.bottom(vbp+fc),
	.red(red),
	.green(green),
	.blue(blue),
    .d_visible(d_visible),
    .u_visible(u_visible),
    .l_visible(l_visible),
    .r_visible(r_visible)
);

endmodule
