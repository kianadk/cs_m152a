`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:27:51 05/22/2018 
// Design Name: 
// Module Name:    down_arrow 
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
module down_arrow(
    input [2:0] decode,
	input [9:0] hc,
	input [9:0] vc,
	input [9:0] fc,
	input [9:0] d_left,
	input [9:0] d_right,
	input [9:0] u_left,
	input [9:0] u_right,
	input [9:0] l_left,
	input [9:0] l_right,
	input [9:0] r_left,
	input [9:0] r_right,
	input [9:0] top,
	input [9:0] bottom,
	output reg [2:0] red,
	output reg [2:0] green,
	output reg [1:0] blue
);

wire [9:0] width;
assign width = d_right - d_left;
wire [9:0] height;
assign height = top - bottom;
wire [9:0] offset;
assign offset = vc - (bottom + height / 2);
wire [9:0] h_offset;
assign h_offset = hc - (l_left + width / 2);
wire [9:0] r_offset;
assign r_offset = hc - (r_left + width / 2);

always @ (hc, vc) begin
	if ((vc <= 405 && vc > 400) || (vc <= 490 && vc > 485)) begin
		red = 3'b111;
		green = 3'b111;
		blue = 2'b11;
	end
	// down arrow
	else if (hc >= d_left && hc < d_right && vc >= bottom && vc < top) begin
	
		if (vc <= bottom + (height / 2)) begin
			if (hc >= d_left + width / 3 && hc < d_right - width / 3) begin
                if (decode == 3'b011) begin
                    red = 3'b111;
                    green = 3'b000;
                    blue = 2'b11;
                end
                else begin
                    red = 3'b111;
                    green = 3'b111;
                    blue = 2'b11;
                end
			end
			else begin
				red = 3'b000;
				green = 3'b000;
				blue = 2'b00;
			end
		end

	   else if (hc >= d_left + offset && hc < d_right - offset) begin
            if (decode == 3'b011) begin
                red = 3'b111;
                green = 3'b000;
                blue = 2'b11;
            end
            else begin
                red = 3'b111;
                green = 3'b111;
                blue = 2'b11;
            end
		end
		
		else begin
			red = 3'b000;
			green = 3'b000;
			blue = 2'b00;
		end

	end
	// up arrow
	else if (hc >= u_left && hc < u_right && vc >= bottom && vc < top) begin
	
		if (vc >= bottom + (height / 2)) begin
			if (hc >= u_left + width / 3 && hc < u_right - width / 3) begin
                if (decode == 3'b010) begin
                    red = 3'b000;
                    green = 3'b111;
                    blue = 2'b00;
                end
                else begin
                    red = 3'b111;
                    green = 3'b111;
                    blue = 2'b11;
                end
			end
			else begin
				red = 3'b000;
				green = 3'b000;
				blue = 2'b00;
			end
		end

	   else if (hc >= u_left - offset && hc < u_right + offset) begin
            if (decode == 3'b010) begin
                red = 3'b000;
                green = 3'b111;
                blue = 2'b00;
            end
            else begin
                red = 3'b111;
                green = 3'b111;
                blue = 2'b11;
            end
		end
		
		else begin
			red = 3'b000;
			green = 3'b000;
			blue = 2'b00;
		end

	end
	// left arrow
	else if (hc >= l_left && hc < l_right && vc >= bottom && vc < top) begin
	
		// draw arrow stick
		if (hc >= l_left + (width / 2)) begin
			if (vc >= bottom + height / 3 && vc < top - height / 3) begin
                if (decode == 3'b000) begin
                    red = 3'b000;
                    green = 3'b000;
                    blue = 2'b11;
                end
                else begin
                    red = 3'b111;
                    green = 3'b111;
                    blue = 2'b11;
                end
			end
			else begin
				red = 3'b000;
				green = 3'b000;
				blue = 2'b00;
			end
		end

		// draw arrow point
	   else if (vc >= bottom - h_offset && vc < top + h_offset) begin
            if (decode == 3'b000) begin
                red = 3'b000;
                green = 3'b000;
                blue = 2'b11;
            end
            else begin
                red = 3'b111;
                green = 3'b111;
                blue = 2'b11;
            end
		end
		
		else begin
			red = 3'b000;
			green = 3'b000;
			blue = 2'b00;
		end

	end
	// right arrow
	else if (hc >= r_left && hc < r_right && vc >= bottom && vc < top) begin
	
		// draw arrow stick
		if (hc <= r_left + (width / 2)) begin
			if (vc >= bottom + height / 3 && vc < top - height / 3) begin
                if (decode == 3'b001) begin
                    red = 3'b111;
                    green = 3'b000;
                    blue = 2'b00;
                end
                else begin
                    red = 3'b111;
                    green = 3'b111;
                    blue = 2'b11;
                end
			end
			else begin
				red = 3'b000;
				green = 3'b000;
				blue = 2'b00;
			end
		end

		// draw arrow point
	   else if (vc >= bottom + r_offset && vc < top - r_offset) begin
            if (decode == 3'b001) begin
                red = 3'b111;
                green = 3'b000;
                blue = 2'b00;
            end
            else begin
                red = 3'b111;
                green = 3'b111;
                blue = 2'b11;
            end
		end
		
		else begin
			red = 3'b000;
			green = 3'b000;
			blue = 2'b00;
		end

	end
	else begin
			red = 3'b000;
			green = 3'b000;
			blue = 2'b00;
	end
end

endmodule
