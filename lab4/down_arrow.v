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
	 input wire l_arrow,
	 input wire r_arrow,
	 input wire u_arrow,
	 input wire d_arrow,
	 input enter,
	input bclk,
   input [2:0] decode,
	input [9:0] hc,
	input [9:0] vc,
	input [9:0] d_top,
	input [9:0] d_bottom,
	input [9:0] u_top,
	input [9:0] u_bottom, 
	input [9:0] l_top,
	input [9:0] l_bottom,
	input [9:0] r_top,
	input [9:0] r_bottom,     
	input [9:0] d_vc,
	input [9:0] top,
	input [9:0] bottom,
	input [9:0] u_left,
	input [9:0] u_right,
    input d_visible,
    input u_visible,
    input l_visible,
    input r_visible,
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
wire [9:0] d_offset;
assign d_offset = vc - (d_bottom + height / 2);
wire [9:0] u_offset;
assign u_offset = vc - (u_bottom + height / 2);
wire [9:0] h_offset;
assign h_offset = hc - (l_left + width / 2);
wire [9:0] r_offset;
assign r_offset = hc - (r_left + width / 2);

reg [3:0] l_score;
reg [3:0] r_score;
reg [3:0] u_score;
reg [3:0] d_score;

reg gameState;


wire [3:0] score;
assign score = l_score + r_score + u_score + d_score;

initial begin
	l_score <= 0;
	r_score <= 0;
	u_score <= 0;
	d_score <= 0;
	gameState <= 0;
end

always @ (posedge enter) begin
	gameState <= ~gameState;
end

always @ (posedge l_arrow) begin
	l_score <= l_score + 1;
end

always @ (posedge r_arrow) begin
	r_score <= r_score + 1;
end

always @ (posedge u_arrow) begin
	u_score <= u_score + 1;
end

always @ (posedge d_arrow) begin
	d_score <= d_score + 1;
end

always @ (hc, vc) begin
	//start screen
	if (gameState == 0) begin
		drawStart();
	end
	//game mode
	else begin
		 // arrow selection area
		if ((vc <= 205 && vc > 200) || (vc <= 290 && vc > 285)) begin
			red = 3'b111;
			green = 3'b111;
			blue = 2'b11;
		end
		else if (vc <= 350 && vc > 300) begin
			displayScore(score);
		end
		// down arrow
		else if (hc >= d_left && hc < d_right && vc >= d_bottom && vc < d_top) begin
			  if (!d_visible) begin
					makeBlack();
			  end
			else if (vc <= d_bottom + (height / 2)) begin
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
					makeBlack();
				end
			end

			 else if (hc >= d_left + d_offset && hc < d_right - d_offset) begin
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
		else if (hc >= u_left && hc < u_right && vc >= u_bottom && vc < u_top) begin
			  if (!u_visible) begin
					makeBlack();
			  end
			else if (vc >= u_bottom + (height / 2)) begin
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

			else if (hc >= u_left - u_offset && hc < u_right + u_offset) begin
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
		else if (hc >= l_left && hc < l_right && vc >= l_bottom && vc < l_top) begin
			  if (!l_visible) begin
					makeBlack();
			  end
			// draw arrow stick
			else if (hc >= l_left + (width / 2)) begin
				if (vc >= l_bottom + height / 3 && vc < l_top - height / 3) begin
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
			else if (vc >= l_bottom - h_offset && vc < l_top + h_offset) begin
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
				makeBlack();
			end

		end
		// right arrow
		else if (hc >= r_left && hc < r_right && vc >= r_bottom && vc < r_top) begin
			  if (!r_visible) begin
					makeBlack();
			  end
			// draw arrow stick
			else if (hc <= r_left + (width / 2)) begin
				if (vc >= r_bottom + height / 3 && vc < r_top - height / 3) begin
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
					makeBlack();
				end
			end

			// draw arrow point
			else if (vc >= r_bottom + r_offset && vc < r_top - r_offset) begin
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
				makeBlack();
			end

		end
		else begin
				makeBlack();
		end
	end
end

task makeWhite;
begin
	red = 3'b111;
	green = 3'b111;
	blue = 2'b11;
end
endtask

task makeBlack;
begin
	red = 3'b000;
	green = 3'b000;
	blue = 2'b00;
end
endtask

task drawStart;
begin
	//d(ance dance revolution)
	if (hc > 200 && hc < 240 && vc > 100 && vc < 145) begin
		  //middle horizontal
        if (vc > 120 && vc < 125 && hc > 200 && hc < 230) begin
            makeWhite();
        end
		  //right top vertical
        else if (vc > 100 && vc < 125 && hc > 225 && hc < 230) begin
            makeWhite();
        end
		  //bottom horizontal
        else if (vc > 140 && vc < 145 && hc > 200 && hc < 230) begin
            makeWhite();
        end
		  //left bottom vertical
        else if (vc > 120 && vc < 145 && hc > 200 && hc < 205) begin          
            makeWhite();
        end
		  //right bottom vertical
        else if (vc > 120 && vc < 145 && hc > 225 && hc < 230) begin           
				makeWhite();
        end		  
        else begin
            makeBlack();
        end	
	end
	//(d)a(nce dance revolution)
	else if (hc > 240 && hc < 280 && vc > 100 && vc < 145) begin
		  // top horizontal
        if (vc > 100 && vc < 105 && hc > 240 && hc < 270) begin
            makeWhite();
        end
		  //middle horizontal
        else if (vc > 120 && vc < 125 && hc > 240 && hc < 270) begin
            makeWhite();
        end
		  //left top vertical
        else if (vc > 100 && vc < 125 && hc > 240 && hc < 245) begin
            makeWhite();
        end
		  //right top vertical
        else if (vc > 100 && vc < 125 && hc > 265 && hc < 270) begin
            makeWhite();
        end
		  //left bottom vertical
        else if (vc > 120 && vc < 145 && hc > 240 && hc < 245) begin          
            makeWhite();
        end
		  //right bottom vertical
        else if (vc > 120 && vc < 145 && hc > 265 && hc < 270) begin           
				makeWhite();
        end		  
        else begin
            makeBlack();
        end	
	end
	// n(ce dance revolution)
	else if (hc > 280 && hc < 320 && vc > 100 && vc < 145) begin
		  //middle horizontal
        if (vc > 120 && vc < 125 && hc > 280 && hc < 310) begin
            makeWhite();
        end
		  //left bottom vertical
        else if (vc > 120 && vc < 145 && hc > 280 && hc < 285) begin          
            makeWhite();
        end
		  //right bottom vertical
        else if (vc > 120 && vc < 145 && hc > 305 && hc < 310) begin           
				makeWhite();
        end		  
        else begin
            makeBlack();
        end	
	end
	//c(e dance revolution)
	else if (hc > 320 && hc < 360 && vc > 100 && vc < 145) begin
		  // top horizontal
        if (vc > 100 && vc < 105 && hc > 320 && hc < 350)
            makeWhite();
		  //left top vertical
        else if (vc > 100 && vc < 125 && hc > 320 && hc < 325)
            makeWhite();
		  //bottom horizontal
        else if (vc > 140 && vc < 145 && hc > 320 && hc < 350) 
            makeWhite();
		  //left bottom vertical
        else if (vc > 120 && vc < 145 && hc > 320 && hc < 325)          
            makeWhite();	  
        else begin
            makeBlack();
        end	
	end
	//e (dance revolution)
	else if (hc > 360 && hc < 400 && vc > 100 && vc < 145) begin
		  // top horizontal
        if (vc > 100 && vc < 105 && hc > 320 && hc < 350)
            makeWhite();
		  //middle horizontal
        else if (vc > 120 && vc < 125 && hc > 360 && hc < 390) 
            makeWhite();
		  //left top vertical
        else if (vc > 100 && vc < 125 && hc > 360 && hc < 365)
            makeWhite();
		  //bottom horizontal
        else if (vc > 140 && vc < 145 && hc > 360 && hc < 390) 
            makeWhite();
		  //left bottom vertical
        else if (vc > 120 && vc < 145 && hc > 360 && hc < 365)          
            makeWhite();	  
        else 
            makeBlack();	
	end
	//d(ance revolution)
	else if (hc > 200 && hc < 240 && vc > 150 && vc < 195) begin
		  //middle horizontal
        if (vc > 170 && vc < 175 && hc > 200 && hc < 230) begin
            makeWhite();
        end
		  //right top vertical
        else if (vc > 150 && vc < 175 && hc > 225 && hc < 230) begin
            makeWhite();
        end
		  //bottom horizontal
        else if (vc > 190 && vc < 195 && hc > 200 && hc < 230) begin
            makeWhite();
        end
		  //left bottom vertical
        else if (vc > 170 && vc < 195 && hc > 200 && hc < 205) begin          
            makeWhite();
        end
		  //right bottom vertical
        else if (vc > 170 && vc < 195 && hc > 225 && hc < 230) begin           
				makeWhite();
        end		  
        else begin
            makeBlack();
        end	
	end
	//a(nce revolution)
	else if (hc > 240 && hc < 280 && vc > 150 && vc < 195) begin
		  // top horizontal
        if (vc > 150 && vc < 155 && hc > 240 && hc < 270) begin
            makeWhite();
        end
		  //middle horizontal
        else if (vc > 170 && vc < 175 && hc > 240 && hc < 270) begin
            makeWhite();
        end
		  //left top vertical
        else if (vc > 150 && vc < 175 && hc > 240 && hc < 245) begin
            makeWhite();
        end
		  //right top vertical
        else if (vc > 150 && vc < 175 && hc > 265 && hc < 270) begin
            makeWhite();
        end
		  //left bottom vertical
        else if (vc > 170 && vc < 195 && hc > 240 && hc < 245) begin          
            makeWhite();
        end
		  //right bottom vertical
        else if (vc > 170 && vc < 195 && hc > 265 && hc < 270) begin           
				makeWhite();
        end		  
        else begin
            makeBlack();
        end	
	end
	// n(ce revolution)
	else if (hc > 280 && hc < 320 && vc > 150 && vc < 195) begin
		  //middle horizontal
        if (vc > 170 && vc < 175 && hc > 280 && hc < 310) begin
            makeWhite();
        end
		  //left bottom vertical
        else if (vc > 170 && vc < 175 && hc > 280 && hc < 285) begin          
            makeWhite();
        end
		  //right bottom vertical
        else if (vc > 170 && vc < 195 && hc > 305 && hc < 310) begin           
				makeWhite();
        end		  
        else begin
            makeBlack();
        end	
	end
	//c(e revolution)
	else if (hc > 320 && hc < 360 && vc > 150 && vc < 195) begin
		  // top horizontal
        if (vc > 150 && vc < 155 && hc > 320 && hc < 350)
            makeWhite();
		  //left top vertical
        else if (vc > 150 && vc < 175 && hc > 320 && hc < 325)
            makeWhite();
		  //bottom horizontal
        else if (vc > 190 && vc < 195 && hc > 320 && hc < 350) 
            makeWhite();
		  //left bottom vertical
        else if (vc > 170 && vc < 195 && hc > 320 && hc < 325)          
            makeWhite();	  
        else begin
            makeBlack();
        end	
	end
	//e (revolution)
	else if (hc > 360 && hc < 400 && vc > 150 && vc < 195) begin
		  // top horizontal
        if (vc > 150 && vc < 155 && hc > 320 && hc < 350)
            makeWhite();
		  //middle horizontal
        else if (vc > 170 && vc < 175 && hc > 360 && hc < 390) 
            makeWhite();
		  //left top vertical
        else if (vc > 150 && vc < 175 && hc > 360 && hc < 365)
            makeWhite();
		  //bottom horizontal
        else if (vc > 190 && vc < 195 && hc > 360 && hc < 390) 
            makeWhite();
		  //left bottom vertical
        else if (vc > 170 && vc < 195 && hc > 360 && hc < 365)          
            makeWhite();	  
        else 
            makeBlack();	
	end
	// currently just an 8 at the bottom left ish
	else if (hc > 200 && hc < 240 && vc > 300 && vc < 345) begin
        // 0
		  // top horizontal
        if (vc > 300 && vc < 305 && hc > 200 && hc < 230) begin
            makeWhite();
        end
		  //middle horizontal
        else if (vc > 320 && vc < 325 && hc > 200 && hc < 230) begin
            makeWhite();
        end
		  //left top vertical
        else if (vc > 300 && vc < 325 && hc > 200 && hc < 205) begin
            makeWhite();
        end
		  //right top vertical
        else if (vc > 300 && vc < 325 && hc > 225 && hc < 230) begin
            makeWhite();
        end
		  //bottom horizontal
        else if (vc > 340 && vc < 345 && hc > 200 && hc < 230) begin
            makeWhite();
        end
		  //left bottom vertical
        else if (vc > 320 && vc < 345 && hc > 200 && hc < 205) begin          
            makeWhite();
        end
		  //right bottom vertical
        else if (vc > 320 && vc < 345 && hc > 225 && hc < 230) begin           
				makeWhite();
        end		  
        else begin
            makeBlack();
        end	
	end
	else begin
		makeBlack();
	end
end
endtask

task displayScore;
input [9:0] score;
begin
	displayDigit(score / 1000, score / 100, score / 10, score % 10, 280);
	
end
endtask

task displayDigit;
input [3:0] thousand;
input [3:0] hundred;
input [3:0] ten;
input [3:0] number;
input [9:0] left_boundary;
begin
	//thousands
	if (hc > 200 && hc < left_boundary + 40) begin
        // 0
		  // top horizontal
        if (vc > 300 && vc < 305 && hc > left_boundary && hc < left_boundary + 30 &&
				(thousand == 0 || thousand == 2 || thousand == 3 || thousand == 5 || thousand == 6 || thousand == 7 || thousand == 8 || thousand == 9)) begin
            makeWhite();
        end
		  //middle horizontal
        else if (vc > 320 && vc < 325 && hc > left_boundary && hc < left_boundary + 30 &&
		  (thousand == 2 || thousand == 3 || thousand == 4 || thousand == 5 || thousand == 6 || thousand == 8 || thousand == 9)) begin
            makeWhite();
        end
		  //left top vertical
        else if (vc > 300 && vc < 325 && hc > left_boundary && hc < left_boundary + 5 &&
		  (thousand == 0 || thousand == 1 || thousand == 4 || thousand == 5 || thousand == 6 || thousand == 8 || thousand == 9)) begin
            makeWhite();
        end
		  //right top vertical
        else if (vc > 300 && vc < 325 && hc > left_boundary + 25 && hc < left_boundary + 30 &&
		  (thousand == 0 || thousand == 2 || thousand == 3 || thousand == 4 || thousand == 7 || thousand == 8 || thousand == 9)) begin
            red = 3'b111;
            green = 3'b111;
            blue = 2'b11;
        end
		  //bottom horizontal
        else if (vc > 340 && vc < 345 && hc > left_boundary && hc < left_boundary + 30 && 
		  (thousand == 0 || thousand == 2 || thousand == 3 || thousand == 5 || thousand == 6 || thousand == 8)) begin
            makeWhite();
        end
		  //left bottom vertical
        else if (vc > 320 && vc < 345 && hc > left_boundary && hc < left_boundary + 5 &&
		  (thousand == 0 || thousand == 1 || thousand == 2 || thousand == 6 || thousand == 8)) begin
            makeWhite();
        end
		  //right bottom vertical
        else if (vc > 320 && vc < 345 && hc > left_boundary + 25 && hc < left_boundary + 30 &&
		  (thousand == 0 || thousand == 3 || thousand == 4 || thousand == 5 || thousand == 6 || thousand == 7 || thousand == 8 || thousand == 9)) begin
            makeWhite();
        end		  
        else begin
            makeBlack();
        end	
	end
	//hundreds
	else if (hc > left_boundary + 40 && hc < left_boundary + 80) begin
        // 0
		  // top horizontal
        if (vc > 300 && vc < 305 && hc > left_boundary + 40 && hc < left_boundary + 30 + 40 &&
			(hundred == 0 || hundred == 2 || hundred == 3 || hundred == 5 || hundred == 6 || hundred == 7 || hundred == 8 || hundred == 9)) begin
            makeWhite();
        end
		  //middle horizontal
        else if (vc > 320 && vc < 325 && hc > left_boundary + 40 && hc < left_boundary + 30 + 40 &&
		  (hundred == 2 || hundred == 3 || hundred == 4 || hundred == 5 || hundred == 6 || hundred == 8 || hundred == 9)) begin
            makeWhite();
        end
		  //left top vertical
        else if (vc > 300 && vc < 325 && hc > left_boundary + 40 && hc < 40 + left_boundary + 5 &&
		  (hundred == 0 || hundred == 1 || hundred == 4 || hundred == 5 || hundred == 6 || hundred == 8 || hundred == 9)) begin
            makeWhite();
        end
		  //right top vertical
        else if (vc > 300 && vc < 325 && hc > left_boundary + 25 + 40 && hc < 40 + left_boundary + 30 &&
		  (hundred == 0 || hundred == 2 || hundred == 3 || hundred == 4 || hundred == 7 || hundred == 8 || hundred == 9)) begin
            makeWhite();
        end
		  //bottom horizontal
        else if (vc > 340 && vc < 345 && hc > 40 + left_boundary && hc < 40 + left_boundary + 30 && 
		  (hundred == 0 || hundred == 2 || hundred == 3 || hundred == 5 || hundred == 6 || hundred == 8)) begin
            red = 3'b111;
            green = 3'b111;
            blue = 2'b11;
        end
		  //left bottom vertical
        else if (vc > 320 && vc < 345 && hc > 40 + left_boundary && hc < 40 + left_boundary + 5 &&
		  (hundred == 0 || hundred == 1 || hundred == 2 || hundred == 6 || hundred == 8)) begin
            red = 3'b111;
            green = 3'b111;
            blue = 2'b11;
        end
		  //right bottom vertical
        else if (vc > 320 && vc < 345 && hc > 40 + left_boundary + 25 && hc < 40 + left_boundary + 30 &&
		  (hundred == 0 || hundred == 3 || hundred == 4 || hundred == 5 || hundred == 6 || hundred == 7 || hundred == 8 || hundred == 9)) begin
            red = 3'b111;
            green = 3'b111;
            blue = 2'b11;
        end		  
        else begin
            makeBlack();
        end	
	end
	//tens
	else if (hc > left_boundary + 80 && hc < left_boundary + 120) begin
        // 0
		  // top horizontal
        if (vc > 300 && vc < 305 && hc > 80 + left_boundary && hc < 80 + left_boundary + 30 &&
				(ten == 0 || ten == 2 || ten == 3 || ten == 5 || ten == 6 || ten == 7 || ten == 8 || ten == 9)) begin
            red = 3'b111;
            green = 3'b111;
            blue = 2'b11;
        end
		  //middle horizontal
        else if (vc > 320 && vc < 325 && hc > 80 + left_boundary && hc < 80 + left_boundary + 30 &&
		  (ten == 2 || ten == 3 || ten == 4 || ten == 5 || ten == 6 || ten == 8 || ten == 9)) begin
            red = 3'b111;
            green = 3'b111;
            blue = 2'b11;
        end
		  //left top vertical
        else if (vc > 300 && vc < 325 && hc > 80 + left_boundary && hc < 80 + left_boundary + 5 &&
		  (ten == 0 || ten == 1 || ten == 4 || ten == 5 || ten == 6 || ten == 8 || ten == 9)) begin
            red = 3'b111;
            green = 3'b111;
            blue = 2'b11;
        end
		  //right top vertical
        else if (vc > 300 && vc < 325 && hc > 80 + left_boundary + 25 && hc < 80 + left_boundary + 30 &&
		  (ten == 0 || ten == 2 || ten == 3 || ten == 4 || ten == 7 || ten == 8 || ten == 9)) begin
            red = 3'b111;
            green = 3'b111;
            blue = 2'b11;
        end
		  //bottom horizontal
        else if (vc > 340 && vc < 345 && hc > 80 + left_boundary && hc < 80 + left_boundary + 30 && 
		  (ten == 0 || ten == 2 || ten == 3 || ten == 5 || ten == 6 || ten == 8)) begin
            red = 3'b111;
            green = 3'b111;
            blue = 2'b11;
        end
		  //left bottom vertical
        else if (vc > 320 && vc < 345 && hc > 80 + left_boundary && hc < 80 + left_boundary + 5 &&
		  (ten == 0 || ten == 1 || ten == 2 || ten == 6 || ten == 8)) begin
            red = 3'b111;
            green = 3'b111;
            blue = 2'b11;
        end
		  //right bottom vertical
        else if (vc > 320 && vc < 345 && hc > 80 + left_boundary + 25 && hc < 80 + left_boundary + 30 &&
		  (ten == 0 || ten == 3 || ten == 4 || ten == 5 || ten == 6 || ten == 7 || ten == 8 || ten == 9)) begin
            red = 3'b111;
            green = 3'b111;
            blue = 2'b11;
        end		  
        else begin
            makeBlack();
        end	
	end
	//ones
	else if (hc > left_boundary + 120 && hc < left_boundary + 160) begin
        // 0
		  // top horizontal
        if (vc > 300 && vc < 305 && hc > 120 + left_boundary && hc < 120 + left_boundary + 30 &&
				(number == 0 || number == 2 || number == 3 || number == 5 || number == 6 || number == 7 || number == 8 || number == 9)) begin
            red = 3'b111;
            green = 3'b111;
            blue = 2'b11;
        end
		  //middle horizontal
        else if (vc > 320 && vc < 325 && hc > 120+left_boundary && hc < 120+left_boundary + 30 &&
		  (number == 2 || number == 3 || number == 4 || number == 5 || number == 6 || number == 8 || number == 9)) begin
            red = 3'b111;
            green = 3'b111;
            blue = 2'b11;
        end
		  //left top vertical
        else if (vc > 300 && vc < 325 && hc > 120+left_boundary && hc < 120+left_boundary + 5 &&
		  (number == 0 || number == 1 || number == 4 || number == 5 || number == 6 || number == 8 || number == 9)) begin
            red = 3'b111;
            green = 3'b111;
            blue = 2'b11;
        end
		  //right top vertical
        else if (vc > 300 && vc < 325 && hc > 120+left_boundary + 25 && hc < 120+left_boundary + 30 &&
		  (number == 0 || number == 2 || number == 3 || number == 4 || number == 7 || number == 8 || number == 9)) begin
            red = 3'b111;
            green = 3'b111;
            blue = 2'b11;
        end
		  //bottom horizontal
        else if (vc > 340 && vc < 345 && hc > 120+left_boundary && hc < 120+left_boundary + 30 && 
		  (number == 0 || number == 2 || number == 3 || number == 5 || number == 6 || number == 8)) begin
            red = 3'b111;
            green = 3'b111;
            blue = 2'b11;
        end
		  //left bottom vertical
        else if (vc > 320 && vc < 345 && hc > 120+left_boundary && hc < 120+left_boundary + 5 &&
		  (number == 0 || number == 1 || number == 2 || number == 6 || number == 8)) begin
            red = 3'b111;
            green = 3'b111;
            blue = 2'b11;
        end
		  //right bottom vertical
        else if (vc > 320 && vc < 345 && hc > 120+left_boundary + 25 && hc < 120+left_boundary + 30 &&
		  (number == 0 || number == 3 || number == 4 || number == 5 || number == 6 || number == 7 || number == 8 || number == 9)) begin
            red = 3'b111;
            green = 3'b111;
            blue = 2'b11;
        end		  
        else begin
            makeBlack();
        end	
	end
	else begin
		makeBlack();
	end;
end
endtask

endmodule
