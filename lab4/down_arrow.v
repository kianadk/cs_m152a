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
	input [9:0] top,
	input [9:0] bottom,
	input [9:0] u_left,
	input [9:0] u_right,
	output reg [2:0] red,
	output reg [2:0] green,
	output reg [1:0] blue
);

// video structure constants
parameter hpixels = 800;// horizontal pixels per line
parameter vlines = 521; // vertical lines per frame
parameter frames = 800; // number of frames for video
parameter hpulse = 96; 	// hsync pulse length
parameter vpulse = 2; 	// vsync pulse length
parameter hbp = 144; 	// end of horizontal back porch
parameter hfp = 784; 	// beginning of horizontal front porch
parameter vbp = 31; 		// end of vertical back porch
parameter vfp = 511; 	// beginning of vertical front porch
// active horizontal video is therefore: 784 - 144 = 640
// active vertical video is therefore: 511 - 31 = 480

parameter screenWidth = hfp - hbp;
parameter laneWidth = screenWidth / 4;
parameter arrowWidth = 80;
parameter marginWidth = (laneWidth - arrowWidth) / 2;
parameter d_left = hbp + marginWidth;
parameter d_right = d_left + arrowWidth;
//parameter u_left = hbp+340;
//parameter u_right = hbp+420;
parameter l_left = hbp + 2 * laneWidth + marginWidth;
parameter l_right = l_left + arrowWidth;
parameter r_left = hbp + 3 * laneWidth + marginWidth;
parameter r_right = r_left + arrowWidth;

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

reg [2:0] score;

initial begin
	score <= 0;
end

always @ (decode) begin
	if (decode == 3'b000 && bottom <= 290 && bottom >= 205)
		score <= score + 1;
end

always @ (hc, vc) begin
    // arrow selection area
	if ((vc <= 205 && vc > 200) || (vc <= 290 && vc > 285)) begin
		red = 3'b111;
		green = 3'b111;
		blue = 2'b11;
	end
   else if (vc <= 350 && vc > 300) begin
		displayDigit(score);
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
                    makeWhite();
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
                makeWhite();
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
                    makeWhite();
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
                makeWhite();
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
                    makeWhite();
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
                makeWhite();
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
                    makeWhite();
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
                makeWhite();
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

task makeWhite;
begin
	red = 3'b111;
	green = 3'b111;
	blue = 2'b11;
end
endtask

task displayDigit;
input [3:0] number;
begin
        // 0
		  // top horizontal
        if (vc > 300 && vc < 305 && hc > 200 && hc < 230 &&
				(number == 0 || number == 2 || number == 3 || number == 5 || number == 6 || number == 7 || number == 8 || number == 9)) begin
            red = 3'b111;
            green = 3'b111;
            blue = 2'b11;
        end
		  //middle horizontal
        else if (vc > 320 && vc < 325 && hc > 200 && hc < 230 &&
		  (number == 2 || number == 3 || number == 4 || number == 5 || number == 6 || number == 8 || number == 9)) begin
            red = 3'b111;
            green = 3'b111;
            blue = 2'b11;
        end
		  //left top vertical
        else if (vc > 300 && vc < 325 && hc > 200 && hc < 205 &&
		  (number == 0 || number == 1 || number == 4 || number == 5 || number == 6 || number == 8 || number == 9)) begin
            red = 3'b111;
            green = 3'b111;
            blue = 2'b11;
        end
		  //right top vertical
        else if (vc > 300 && vc < 325 && hc > 225 && hc < 230 &&
		  (number == 0 || number == 2 || number == 3 || number == 4 || number == 7 || number == 8 || number == 9)) begin
            red = 3'b111;
            green = 3'b111;
            blue = 2'b11;
        end
		  //bottom horizontal
        else if (vc > 340 && vc < 345 && hc > 200 && hc < 230 && 
		  (number == 0 || number == 2 || number == 3 || number == 5 || number == 6 || number == 8)) begin
            red = 3'b111;
            green = 3'b111;
            blue = 2'b11;
        end
		  //left bottom vertical
        else if (vc > 320 && vc < 345 && hc > 200 && hc < 205 &&
		  (number == 0 || number == 1 || number == 2 || number == 6 || number == 8)) begin
            red = 3'b111;
            green = 3'b111;
            blue = 2'b11;
        end
		  //right bottom vertical
        else if (vc > 320 && vc < 345 && hc > 225 && hc < 230 &&
		  (number == 0 || number == 3 || number == 4 || number == 5 || number == 6 || number == 7 || number == 8 || number == 9)) begin
            red = 3'b111;
            green = 3'b111;
            blue = 2'b11;
        end		  
        else begin
            red = 3'b000;
            green = 3'b000;
            blue = 2'b00;
        end	
end
endtask

endmodule
