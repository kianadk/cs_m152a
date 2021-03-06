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
	 output reg [1:0] stageState,
	 input wire l_arrow,
	 input wire r_arrow,
	 input wire u_arrow,
	 input wire d_arrow,
	 input enter,
	input bclk,
	input sec_clk,
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

reg [9:0] l_score;
reg [9:0] r_score;
reg [9:0] u_score;
reg [9:0] d_score;

reg [1:0] gameState;
reg endOptionState;

reg [9:0] gameCounter;


wire [9:0] score;
assign score = l_score + r_score + u_score + d_score;

initial begin
	gameCounter <= 0;
	l_score <= 0;
	r_score <= 0;
	u_score <= 0;
	d_score <= 0;
	gameState <= startState;
	stageState <= stage1;
	endOptionState <= restart;
end

parameter restart = 0;
parameter endGame = 1;
parameter stage1 = 2'b00;
parameter stage2 = 2'b01;
parameter stage3 = 2'b10;
parameter startState = 2'b00;
parameter playState = 2'b01;
parameter endState = 2'b10;

always @ (posedge sec_clk) begin
/////////////////////////
//    Game Timeout     //
/////////////////////////
	if (gameState == playState) begin
		if (gameCounter < 300)
			gameCounter <= gameCounter + 1;
		else begin
			gameCounter <= 0;
			gameState <= endState;
		end		
	end
	else
		gameCounter <= 0;


	//left arrow
	if (l_arrow && gameState == playState) begin
		if (l_visible) begin
			if (l_bottom >= 190 && l_top <= 310)
				l_score <= l_score + 5;
			else if (l_bottom >= 165 && l_top <= 335)
				l_score <= l_score + 3;
			else if (l_bottom >= 140 && l_top <= 240)
				l_score <= l_score + 1;
		end
	end
	//right arrow
	else if (r_arrow && gameState == playState) begin
		if (r_visible) begin
			if (r_bottom >= 190 && r_top <= 310)
				r_score <= r_score + 5;
			else if (r_bottom >= 165 && r_top <= 335)
				r_score <= r_score + 3;
			else if (r_bottom >= 140 && r_top <= 240)
				r_score <= r_score + 1;
		end
	end
	//up arrow
	else if (u_arrow) begin
		if (gameState == playState) begin
			if (u_visible) begin
				if (u_bottom >= 190 && u_top <= 310)
					u_score <= u_score + 5;
				else if (u_bottom >= 165 && u_top <= 335)
					u_score <= u_score + 3;
				else if (u_bottom >= 140 && u_top <= 240)
					u_score <= u_score + 1;
			end
		end
		else if (gameState == startState) begin
			if (stageState == stage1)
				stageState <= stage3;
			else if (stageState == stage2)
				stageState <= stage1;
			else //if (stageState == stage3)
				stageState <= stage2;
		end
		else //if (gameState == endState)
			endOptionState <= ~endOptionState;
	end
	//down arrow
	else if (d_arrow) begin
		if (gameState == playState) begin
			if (d_visible) begin
				if (d_bottom >= 190 && d_top <= 310)
					d_score <= d_score + 5;
				else if (d_bottom >= 165 && d_top <= 335)
					d_score <= d_score + 3;
				else if (d_bottom >= 140 && d_top <= 240)
					d_score <= d_score + 1;
			end
		end
		else if (gameState == startState) begin
			if (stageState == stage1)
				stageState <= stage2;
			else if (stageState == stage2)
				stageState <= stage3;
			else //if (stageState == stage3)
				stageState <= stage1;
		end
		else //if (gameState == endState)
			endOptionState <= ~endOptionState;
	end
	//enter
	else if (enter) begin
		//reset score for next game
		if (gameState != playState) begin
			l_score <= 0;
			r_score <= 0;
			u_score <= 0;
			d_score <= 0;
		end
		
		if (gameState == startState)
			gameState <= playState;
		else if (gameState == endState) begin
			if (endOptionState == endGame)
				gameState <= startState;
			else //restart
				gameState <= playState;
		end
	end
end

always @ (hc, vc) begin
	//start screen
	if (gameState == startState) begin
		drawStart();
	end
	else if (gameState == endState) begin
		displayEnd();
	end
	//game mode
	else if (gameState == playState) begin
		 // arrow selection area
		if ((vc <= 205 && vc > 200) || (vc <= 290 && vc > 285)) begin
			red = 3'b111;
			green = 3'b111;
			blue = 2'b11;
		end
		else if (vc <= 450 && vc > 400) begin
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

task makeBlue;
begin
	red = 3'b000;
	green = 3'b000;
	blue = 2'b11;
end
endtask

parameter d1l = 200;
parameter d1t = 100;
parameter d2t = 150;
parameter d3t = 200;
parameter stage1_top = 300;
parameter stage2_top = 350;
parameter stage3_top = 400;
parameter stage_left = 200;
wire [9:0] start_offset;
assign start_offset = vc - ((d3t) + 45 / 2);

task drawStart;
begin
	//d(ance dance revolution)
	if (hc > d1l && hc < d1l+40 && vc > d1t && vc < d1t+45) begin
		  //middle horizontal
        if (vc > d1t+20 && vc < d1t+25 && hc > d1l && hc < d1l+30) begin
            makeWhite();
        end
		  //right top vertical
        else if (vc > d1t && vc < d1t+25 && hc > d1l+25 && hc < d1l+30) begin
            makeWhite();
        end
		  //bottom horizontal
        else if (vc > d1t+40 && vc < d1t+45 && hc > d1l && hc < d1l+30) begin
            makeWhite();
        end
		  //left bottom vertical
        else if (vc > d1t+20 && vc < d1t+45 && hc > d1l && hc < d1l+5) begin          
            makeWhite();
        end
		  //right bottom vertical
        else if (vc > d1t+20 && vc < d1t+45 && hc > d1l+25 && hc < d1l+30) begin           
				makeWhite();
        end		  
        else begin
            makeBlack();
        end	
	end
	//(d)a(nce dance revolution)
	else if (hc > d1l+40 && hc < d1l+80 && vc > d1t && vc < d1t+45) begin
		  // top horizontal
        if (vc > d1t && vc < d1t+5 && hc > d1l+40 && hc < d1l+70) begin
            makeWhite();
        end
		  //middle horizontal
        else if (vc > d1t+20 && vc < d1t+25 && hc > d1l+40 && hc < d1l+70) begin
            makeWhite();
        end
		  //left top vertical
        else if (vc > d1t && vc < d1t+25 && hc > d1l+40 && hc < d1l+45) begin
            makeWhite();
        end
		  //right top vertical
        else if (vc > d1t && vc < d1t+25 && hc > d1l+65 && hc < d1l+70) begin
            makeWhite();
        end
		  //left bottom vertical
        else if (vc > d1t+20 && vc < d1t+45 && hc > d1l+40 && hc < d1l+45) begin          
            makeWhite();
        end
		  //right bottom vertical
        else if (vc > d1t+20 && vc < d1t+45 && hc > d1l+65 && hc < d1l+70) begin           
				makeWhite();
        end		  
        else begin
            makeBlack();
        end	
	end
	// n(ce dance revolution)
	else if (hc > d1l+80 && hc < d1l+120 && vc > d1t && vc < d1t+45) begin
		  //middle horizontal
        if (vc > 120 && vc < 125 && hc > d1l+80 && hc < d1l+110) begin
            makeWhite();
        end
		  //left bottom vertical
        else if (vc > d1t+20 && vc < d1t+45 && hc > d1l+80 && hc < d1l+85) begin          
            makeWhite();
        end
		  //right bottom vertical
        else if (vc > d1t+20 && vc < d1t+45 && hc > d1l+105 && hc < d1l+110) begin           
				makeWhite();
        end		  
        else begin
            makeBlack();
        end	
	end
	//c(e dance revolution)
	else if (hc > d1l+120 && hc < d1l+160 && vc > d1t && vc < d1t+45) begin
		  // top horizontal
        if (vc > d1t && vc < d1t+5 && hc > d1l+120 && hc < d1l+150)
            makeWhite();
		  //left top vertical
        else if (vc > d1t && vc < d1t+25 && hc > d1l+120 && hc < d1l+125)
            makeWhite();
		  //bottom horizontal
        else if (vc > d1t+40 && vc < d1t+45 && hc > d1l+120 && hc < d1l+150) 
            makeWhite();
		  //left bottom vertical
        else if (vc > d1t+20 && vc < d1t+45 && hc > d1l+120 && hc < d1l+125)          
            makeWhite();	  
        else begin
            makeBlack();
        end	
	end
	//e (dance revolution)
	else if (hc > d1l+160 && hc < d1l+200 && vc > d1t && vc < d1t+45) begin
		  // top horizontal
        if (vc > d1t && vc < d1t+5 && hc > d1l+160 && hc < d1l+190)
            makeWhite();
		  //middle horizontal
        else if (vc > d1t+20 && vc < d1t+25 && hc > d1l+160 && hc < d1l+190) 
            makeWhite();
		  //left top vertical
        else if (vc > d1t && vc < d1t+25 && hc > d1l+160 && hc < d1l+165)
            makeWhite();
		  //bottom horizontal
        else if (vc > d1t+40 && vc < d1t+45 && hc > d1l+160 && hc < d1l+190) 
            makeWhite();
		  //left bottom vertical
        else if (vc > d1t+20 && vc < d1t+45 && hc > d1l+160 && hc < d1l+165)          
            makeWhite();	  
        else 
            makeBlack();	
	end
	//d(ance revolution)
	else if (hc > d1l && hc < d1l+40 && vc > d2t && vc < d2t+45) begin
		  //middle horizontal
        if (vc > d2t+20 && vc < d2t+25 && hc > d1l && hc < d1l+30) begin
            makeWhite();
        end
		  //right top vertical
        else if (vc > d2t && vc < d2t+25 && hc > d1l+25 && hc < d1l+30) begin
            makeWhite();
        end
		  //bottom horizontal
        else if (vc > d2t+40 && vc < d2t+45 && hc > d1l && hc < d1l+30) begin
            makeWhite();
        end
		  //left bottom vertical
        else if (vc > d2t+20 && vc < d2t+45 && hc > d1l && hc < d1l+5) begin          
            makeWhite();
        end
		  //right bottom vertical
        else if (vc > d2t+20 && vc < d2t+45 && hc > d1l+25 && hc < d1l+30) begin           
				makeWhite();
        end		  
        else begin
            makeBlack();
        end	
	end
	//a(nce revolution)
	else if (hc > d1l+40 && hc < d1l+80 && vc > d2t && vc < d2t+45) begin
		  // top horizontal
        if (vc > d2t && vc < d2t+5 && hc > d1l+40 && hc < d1l+70) begin
            makeWhite();
        end
		  //middle horizontal
        else if (vc > d2t+20 && vc < d2t+25 && hc > d1l+40 && hc < d1l+70) begin
            makeWhite();
        end
		  //left top vertical
        else if (vc > d2t && vc < d2t+25 && hc > d1l+40 && hc < d1l+45) begin
            makeWhite();
        end
		  //right top vertical
        else if (vc > d2t && vc < d2t+25 && hc > d1l+65 && hc < d1l+70) begin
            makeWhite();
        end
		  //left bottom vertical
        else if (vc > d2t+20 && vc < d2t+45 && hc > d1l+40 && hc < d1l+45) begin          
            makeWhite();
        end
		  //right bottom vertical
        else if (vc > d2t+20 && vc < d2t+45 && hc > d1l+65 && hc < d1l+70) begin           
				makeWhite();
        end		  
        else begin
            makeBlack();
        end	
	end
	// n(ce revolution)
	else if (hc > d1l+80 && hc < d1l+120 && vc > d2t && vc < d2t+45) begin
		  //middle horizontal
        if (vc > d2t+20 && vc < d2t+25 && hc > d1l+80 && hc < d1l+110) begin
            makeWhite();
        end
		  //left bottom vertical
        else if (vc > d2t+20 && vc < d2t+45 && hc > d1l+80 && hc < d1l+85) begin          
            makeWhite();
        end
		  //right bottom vertical
        else if (vc > d2t+20 && vc < d2t+45 && hc > d1l+105 && hc < d1l+110) begin           
				makeWhite();
        end		  
        else begin
            makeBlack();
        end	
	end
	//c(e revolution)
	else if (hc > d1l+120 && hc < d1l+160 && vc > d2t && vc < d2t+45) begin
		  // top horizontal
        if (vc > d2t && vc < d2t+5 && hc > d1l+120 && hc < d1l+150)
            makeWhite();
		  //left top vertical
        else if (vc > d2t && vc < d2t+25 && hc > d1l+120 && hc < d1l+125)
            makeWhite();
		  //bottom horizontal
        else if (vc > d2t+40 && vc < d2t+45 && hc > d1l+120 && hc < d1l+150) 
            makeWhite();
		  //left bottom vertical
        else if (vc > d2t+20 && vc < d2t+45 && hc > d1l+120 && hc < d1l+125)          
            makeWhite();	  
        else begin
            makeBlack();
        end	
	end
	//e (revolution)
	else if (hc > d1l+160 && hc < d1l+200 && vc > d2t && vc < d2t+45) begin
		  // top horizontal
        if (vc > d2t && vc < d2t+5 && hc > d1l+160 && hc < d1l+190)
            makeWhite();
		  //middle horizontal
        else if (vc > d2t+20 && vc < d2t+25 && hc > d1l+160 && hc < d1l+190) 
            makeWhite();
		  //left top vertical
        else if (vc > d2t && vc < d2t+25 && hc > d1l+160 && hc < d1l+165)
            makeWhite();
		  //bottom horizontal
        else if (vc > d2t+40 && vc < d2t+45 && hc > d1l+160 && hc < d1l+190) 
            makeWhite();
		  //left bottom vertical
        else if (vc > d2t+20 && vc < d2t+45 && hc > d1l+160 && hc < d1l+165)          
            makeWhite();	  
        else 
            makeBlack();	
	end
	//r(evolution)
	else if (hc > d1l && hc < d1l+40 && vc > d3t && vc < d3t+45) begin
 		  //middle horizontal
         if (vc > d3t+20 && vc < d3t+25 && hc > d1l && hc < d1l+30) begin
             makeWhite();
         end
 		  //left bottom vertical
         else if (vc > d3t+20 && vc < d3t+45 && hc > d1l && hc < d1l+5) begin          
             makeWhite();
         end	  
         else begin
             makeBlack();
         end	
 	end
	//e(volution)
	else if (hc > d1l+40 && hc < d1l+80 && vc > d3t && vc < d3t+45) begin
 		  // top horizontal
         if (vc > d3t && vc < d3t+5 && hc > d1l+40 && hc < d1l+70) begin
             makeWhite();
         end
 		  //middle horizontal
         else if (vc > d3t+20 && vc < d3t+25 && hc > d1l+40 && hc < d1l+70) begin
             makeWhite();
         end
 		  //left top vertical
         else if (vc > d3t && vc < d3t+25 && hc > d1l+40 && hc < d1l+45) begin
             makeWhite();
         end
 		  //bottom horizontal
         else if (vc > d3t+40 && vc < d3t+45 && hc > d1l+40 && hc < d1l+70) begin
             makeWhite();
         end
 		  //left bottom vertical
         else if (vc > d3t+20 && vc < d3t+45 && hc > d1l+40 && hc < d1l+45) begin          
             makeWhite();
         end		  
         else begin
             makeBlack();
         end	
 	end
	//v(olution)
	else if (hc > d1l+80 && hc < d1l+120 && vc > d3t && vc < d3t+45) begin
		// down arrow
			if (vc <= d3t + (45 / 2)) begin
				if (hc >= (d1l+80) + 40 / 3 && hc < (d1l+120) - 40 / 3) begin
					makeWhite();
				end
				else begin
					makeBlack();
				end
			end

			else if (hc >= (d1l+80) + start_offset && hc < (d1l+120) - start_offset) begin
				makeWhite();
			end
			
			else begin
				makeBlack();
			end
 	end
	//o(lution)
	else if (hc > d1l+120 && hc < d1l+160 && vc > d3t && vc < d3t+45) begin
 		  //middle horizontal
         if (vc > d3t+20 && vc < d3t+25 && hc > d1l+120 && hc < d1l+150) begin
             makeWhite();
         end
 		  //bottom horizontal
         else if (vc > d3t+40 && vc < d3t+45 && hc > d1l+120 && hc < d1l+150) begin
             makeWhite();
         end
 		  //left bottom vertical
         else if (vc > d3t+20 && vc < d3t+45 && hc > d1l+120 && hc < d1l+125) begin          
             makeWhite();
         end
 		  //right bottom vertical
         else if (vc > d3t+20 && vc < d3t+45 && hc > d1l+145 && hc < d1l+150) begin           
 				makeWhite();
         end		  
         else begin
             makeBlack();
         end	
 	end
	//l(ution)
	else if (hc > d1l+160 && hc < d1l+200 && vc > d3t && vc < d3t+45) begin
 		  //left top vertical
         if (vc > d3t && vc < d3t+25 && hc > d1l+160 && hc < d1l+165) begin
             makeWhite();
         end
 		  //left bottom vertical
         else if (vc > d3t+20 && vc < d3t+45 && hc > d1l+160 && hc < d1l+165) begin          
             makeWhite();
         end		  
         else begin
             makeBlack();
         end	
 	end	
	//u(tion)
	else if (hc > d1l+200 && hc < d1l+240 && vc > d3t && vc < d3t+45) begin
 		  //left top vertical
         if (vc > d3t && vc < d3t+25 && hc > d1l+200 && hc < d1l+205) begin
             makeWhite();
         end
 		  //right top vertical
         else if (vc > d3t && vc < d3t+25 && hc > d1l+225 && hc < d1l+230) begin
             makeWhite();
         end
 		  //bottom horizontal
         else if (vc > d3t+40 && vc < d3t+45 && hc > d1l+200 && hc < d1l+230) begin
             makeWhite();
         end
 		  //left bottom vertical
         else if (vc > d3t+20 && vc < d3t+45 && hc > d1l+200 && hc < d1l+205) begin          
             makeWhite();
         end
 		  //right bottom vertical
         else if (vc > d3t+20 && vc < d3t+45 && hc > d1l+225 && hc < d1l+230) begin           
 				makeWhite();
         end		  
         else begin
             makeBlack();
         end	
 	end
	//t(ion)
	else if (hc > d1l+240 && hc < d1l+280 && vc > d3t && vc < d3t+45) begin
 		  //middle horizontal
         if (vc > d3t+20 && vc < d3t+25 && hc > d1l+240 && hc < d1l+270) begin
             makeWhite();
         end
 		  //left top vertical
         else if (vc > d3t && vc < d3t+25 && hc > d1l+240 && hc < d1l+245) begin
             makeWhite();
         end
 		  //bottom horizontal
         else if (vc > d3t+40 && vc < d3t+45 && hc > d1l+240 && hc < d1l+270) begin
             makeWhite();
         end
 		  //left bottom vertical
         else if (vc > d3t+20 && vc < d3t+45 && hc > d1l+240 && hc < d1l+245) begin          
             makeWhite();
         end		  
         else begin
             makeBlack();
         end	
 	end
	//i(on)
	else if (hc > d1l+280 && hc < d1l+320 && vc > d3t && vc < d3t+45) begin
 		  //left top vertical
         if (vc > d3t && vc < d3t+25 && hc > d1l+280 && hc < d1l+285) begin
             makeWhite();
         end
 		  //left bottom vertical
         else if (vc > d3t+20 && vc < d3t+45 && hc > d1l+280 && hc < d1l+285) begin          
             makeWhite();
         end	  
         else begin
             makeBlack();
         end	
 	end
	//o(n)
	else if (hc > d1l+320 && hc < d1l+360 && vc > d3t && vc < d3t+45) begin
 		  // top horizontal
         if (vc > d3t && vc < d3t+5 && hc > d1l+320 && hc < d1l+350) begin
             makeWhite();
         end
 		  //left top vertical
         else if (vc > d3t && vc < d3t+25 && hc > d1l+320 && hc < d1l+325) begin
             makeWhite();
         end
 		  //right top vertical
         else if (vc > d3t && vc < d3t+25 && hc > d1l+345 && hc < d1l+350) begin
             makeWhite();
         end
 		  //bottom horizontal
         else if (vc > d3t+40 && vc < d3t+45 && hc > d1l+320 && hc < d1l+350) begin
             makeWhite();
         end
 		  //left bottom vertical
         else if (vc > d3t+20 && vc < d3t+45 && hc > d1l+320 && hc < d1l+325) begin          
             makeWhite();
         end
 		  //right bottom vertical
         else if (vc > d3t+20 && vc < d3t+45 && hc > d1l+345 && hc < d1l+350) begin           
 				makeWhite();
         end		  
         else begin
             makeBlack();
         end	
 	end
	//n
	else if (hc > d1l+360 && hc < d1l+400 && vc > d3t && vc < d3t+45) begin
 		  //middle horizontal
         if (vc > d3t+20 && vc < d3t+25 && hc > d1l+360 && hc < d1l+390) begin
             makeWhite();
         end
 		  //left bottom vertical
         else if (vc > d3t+20 && vc < d3t+45 && hc > d1l+360 && hc < d1l+365) begin          
             makeWhite();
         end
 		  //right bottom vertical
         else if (vc > d3t+20 && vc < d3t+45 && hc > d1l+385 && hc < d1l+390) begin           
 				makeWhite();
         end		  
         else begin
             makeBlack();
         end	
 	end
	/////////////////////////
	//draw easy-medium-hard//
	/////////////////////////
	//s(tage 1)
	else if (hc > stage_left && hc < stage_left+40 && vc > stage1_top && vc < stage1_top+45) begin
 		  // top horizontal
         if (vc > stage1_top && vc < stage1_top+5 && hc > stage_left && hc < stage_left+30) begin
             makeWhite();
         end
 		  //middle horizontal
         else if (vc > stage1_top+20 && vc < stage1_top+25 && hc > stage_left && hc < stage_left+30) begin
             makeWhite();
         end
 		  //left top vertical
         else if (vc > stage1_top && vc < stage1_top+25 && hc > stage_left && hc < stage_left+5) begin
             makeWhite();
         end
 		  //bottom horizontal
         else if (vc > stage1_top+40 && vc < stage1_top+45 && hc > stage_left && hc < stage_left+30) begin
             makeWhite();
         end
 		  //right bottom vertical
         else if (vc > stage1_top+20 && vc < stage1_top+45 && hc > stage_left+25 && hc < stage_left+30) begin           
 				makeWhite();
         end		  
         else begin
				if (stageState == stage1)
					makeBlue();
				else
					makeBlack();
         end	
 	end
	//t(age 1)
	else if (hc > stage_left+40 && hc < stage_left+80 && vc > stage1_top && vc < stage1_top+45) begin
 		  //middle horizontal
         if (vc > stage1_top+20 && vc < stage1_top+25 && hc > stage_left+40 && hc < stage_left+70) begin
             makeWhite();
         end
 		  //left top vertical
         else if (vc > stage1_top && vc < stage1_top+25 && hc > stage_left+40 && hc < stage_left+45) begin
             makeWhite();
         end
 		  //bottom horizontal
         else if (vc > stage1_top+40 && vc < stage1_top+45 && hc > stage_left+40 && hc < stage_left+70) begin
             makeWhite();
         end
 		  //left bottom vertical
         else if (vc > stage1_top+20 && vc < stage1_top+45 && hc > stage_left+40 && hc < stage_left+45) begin          
             makeWhite();
         end		  
         else begin
             if (stageState == stage1)
					makeBlue();
				else
					makeBlack();
         end	
 	end
	//a(ge 1)
	else if (hc > stage_left+80 && hc < stage_left+120 && vc > stage1_top && vc < stage1_top+45) begin
 		  // top horizontal
         if (vc > stage1_top && vc < stage1_top+5 && hc > stage_left+80 && hc < stage_left+110) begin
             makeWhite();
         end
 		  //middle horizontal
         else if (vc > stage1_top+20 && vc < stage1_top+25 && hc > stage_left+80 && hc < stage_left+110) begin
             makeWhite();
         end
 		  //left top vertical
         else if (vc > stage1_top && vc < stage1_top+25 && hc > stage_left+80 && hc < stage_left+85) begin
             makeWhite();
         end
 		  //right top vertical
         else if (vc > stage1_top && vc < stage1_top+25 && hc > stage_left+105 && hc < stage_left+110) begin
             makeWhite();
         end
 		  //left bottom vertical
         else if (vc > stage1_top+20 && vc < stage1_top+45 && hc > stage_left+80 && hc < stage_left+85) begin          
             makeWhite();
         end
 		  //right bottom vertical
         else if (vc > stage1_top+20 && vc < stage1_top+45 && hc > stage_left+105 && hc < stage_left+110) begin           
 				makeWhite();
         end		  
         else begin
             if (stageState == stage1)
					makeBlue();
				else
					makeBlack();
         end	
 	end
	//g(e 1)
	else if (hc > stage_left+120 && hc < stage_left+160 && vc > stage1_top && vc < stage1_top+45) begin
 		  // top horizontal
         if (vc > stage1_top && vc < stage1_top+5 && hc > stage_left+120 && hc < stage_left+150) begin
             makeWhite();
         end
 		  //middle horizontal
         else if (vc > stage1_top+20 && vc < stage1_top+25 && hc > stage_left+120 && hc < stage_left+150) begin
             makeWhite();
         end
 		  //left top vertical
         else if (vc > stage1_top && vc < stage1_top+25 && hc > stage_left+120 && hc < stage_left+125) begin
             makeWhite();
         end
 		  //right top vertical
         else if (vc > stage1_top && vc < stage1_top+25 && hc > stage_left+145 && hc < stage_left+150) begin
             makeWhite();
         end
 		  //bottom horizontal
         else if (vc > stage1_top+40 && vc < stage1_top+45 && hc > stage_left+120 && hc < stage_left+150) begin
             makeWhite();
         end
 		  //right bottom vertical
         else if (vc > stage1_top+20 && vc < stage1_top+45 && hc > stage_left+145 && hc < stage_left+150) begin           
 				makeWhite();
         end		  
         else begin
             if (stageState == stage1)
					makeBlue();
				else
					makeBlack();
         end	
 	end
	//e( 1)
	else if (hc > stage_left+160 && hc < stage_left+200 && vc > stage1_top && vc < stage1_top+45) begin
 		  // top horizontal
         if (vc > stage1_top && vc < stage1_top+5 && hc > stage_left+160 && hc < stage_left+190) begin
             makeWhite();
         end
 		  //middle horizontal
         else if (vc > stage1_top+20 && vc < stage1_top+25 && hc > stage_left+160 && hc < stage_left+190) begin
             makeWhite();
         end
 		  //left top vertical
         else if (vc > stage1_top && vc < stage1_top+25 && hc > stage_left+160 && hc < stage_left+165) begin
             makeWhite();
         end
 		  //bottom horizontal
         else if (vc > stage1_top+40 && vc < stage1_top+45 && hc > stage_left+160 && hc < stage_left+190) begin
             makeWhite();
         end
 		  //left bottom vertical
         else if (vc > stage1_top+20 && vc < stage1_top+45 && hc > stage_left+160 && hc < stage_left+165) begin          
             makeWhite();
         end		  
         else begin
             if (stageState == stage1)
					makeBlue();
				else
					makeBlack();
         end	
 	end
	// 1
	else if (hc > stage_left+240 && hc < stage_left+280 && vc > stage1_top && vc < stage1_top+45) begin
 		  //left top vertical
         if (vc > stage1_top && vc < stage1_top+25 && hc > stage_left+240 && hc < stage_left+245) begin
             makeWhite();
         end
 		  //left bottom vertical
         else if (vc > stage1_top+20 && vc < stage1_top+45 && hc > stage_left+240 && hc < stage_left+245) begin          
             makeWhite();
         end		  
         else begin
             if (stageState == stage1)
					makeBlue();
				else
					makeBlack();
         end	
 	end
	////////////
	//stage 2
	//////////////
	//s(tage 2)
	else if (hc > stage_left && hc < stage_left+40 && vc > stage2_top && vc < stage2_top+45) begin
 		  // top horizontal
         if (vc > stage2_top && vc < stage2_top+5 && hc > stage_left && hc < stage_left+30) begin
             makeWhite();
         end
 		  //middle horizontal
         else if (vc > stage2_top+20 && vc < stage2_top+25 && hc > stage_left && hc < stage_left+30) begin
             makeWhite();
         end
 		  //left top vertical
         else if (vc > stage2_top && vc < stage2_top+25 && hc > stage_left && hc < stage_left+5) begin
             makeWhite();
         end
 		  //bottom horizontal
         else if (vc > stage2_top+40 && vc < stage2_top+45 && hc > stage_left && hc < stage_left+30) begin
             makeWhite();
         end
 		  //right bottom vertical
         else if (vc > stage2_top+20 && vc < stage2_top+45 && hc > stage_left+25 && hc < stage_left+30) begin           
 				makeWhite();
         end		  
         else begin
             if (stageState == stage2)
					makeBlue();
				else
					makeBlack();
         end	
 	end
	//t(age 2)
	else if (hc > stage_left+40 && hc < stage_left+80 && vc > stage2_top && vc < stage2_top+45) begin
 		  //middle horizontal
         if (vc > stage2_top+20 && vc < stage2_top+25 && hc > stage_left+40 && hc < stage_left+70) begin
             makeWhite();
         end
 		  //left top vertical
         else if (vc > stage2_top && vc < stage2_top+25 && hc > stage_left+40 && hc < stage_left+45) begin
             makeWhite();
         end
 		  //bottom horizontal
         else if (vc > stage2_top+40 && vc < stage2_top+45 && hc > stage_left+40 && hc < stage_left+70) begin
             makeWhite();
         end
 		  //left bottom vertical
         else if (vc > stage2_top+20 && vc < stage2_top+45 && hc > stage_left+40 && hc < stage_left+45) begin          
             makeWhite();
         end		  
         else begin
             if (stageState == stage2)
					makeBlue();
				else
					makeBlack();
         end	
 	end
	//a(ge 2)
	else if (hc > stage_left+80 && hc < stage_left+120 && vc > stage2_top && vc < stage2_top+45) begin
 		  // top horizontal
         if (vc > stage2_top && vc < stage2_top+5 && hc > stage_left+80 && hc < stage_left+110) begin
             makeWhite();
         end
 		  //middle horizontal
         else if (vc > stage2_top+20 && vc < stage2_top+25 && hc > stage_left+80 && hc < stage_left+110) begin
             makeWhite();
         end
 		  //left top vertical
         else if (vc > stage2_top && vc < stage2_top+25 && hc > stage_left+80 && hc < stage_left+85) begin
             makeWhite();
         end
 		  //right top vertical
         else if (vc > stage2_top && vc < stage2_top+25 && hc > stage_left+105 && hc < stage_left+110) begin
             makeWhite();
         end
 		  //left bottom vertical
         else if (vc > stage2_top+20 && vc < stage2_top+45 && hc > stage_left+80 && hc < stage_left+85) begin          
             makeWhite();
         end
 		  //right bottom vertical
         else if (vc > stage2_top+20 && vc < stage2_top+45 && hc > stage_left+105 && hc < stage_left+110) begin           
 				makeWhite();
         end		  
         else begin
             if (stageState == stage2)
					makeBlue();
				else
					makeBlack();
         end	
 	end
	//g(e 2)
	else if (hc > stage_left+120 && hc < stage_left+160 && vc > stage2_top && vc < stage2_top+45) begin
 		  // top horizontal
         if (vc > stage2_top && vc < stage2_top+5 && hc > stage_left+120 && hc < stage_left+150) begin
             makeWhite();
         end
 		  //middle horizontal
         else if (vc > stage2_top+20 && vc < stage2_top+25 && hc > stage_left+120 && hc < stage_left+150) begin
             makeWhite();
         end
 		  //left top vertical
         else if (vc > stage2_top && vc < stage2_top+25 && hc > stage_left+120 && hc < stage_left+125) begin
             makeWhite();
         end
 		  //right top vertical
         else if (vc > stage2_top && vc < stage2_top+25 && hc > stage_left+145 && hc < stage_left+150) begin
             makeWhite();
         end
 		  //bottom horizontal
         else if (vc > stage2_top+40 && vc < stage2_top+45 && hc > stage_left+120 && hc < stage_left+150) begin
             makeWhite();
         end
 		  //right bottom vertical
         else if (vc > stage2_top+20 && vc < stage2_top+45 && hc > stage_left+145 && hc < stage_left+150) begin           
 				makeWhite();
         end		  
         else begin
             if (stageState == stage2)
					makeBlue();
				else
					makeBlack();
         end	
 	end
	//e( 2)
	else if (hc > stage_left+160 && hc < stage_left+200 && vc > stage2_top && vc < stage2_top+45) begin
 		  // top horizontal
         if (vc > stage2_top && vc < stage2_top+5 && hc > stage_left+160 && hc < stage_left+190) begin
             makeWhite();
         end
 		  //middle horizontal
         else if (vc > stage2_top+20 && vc < stage2_top+25 && hc > stage_left+160 && hc < stage_left+190) begin
             makeWhite();
         end
 		  //left top vertical
         else if (vc > stage2_top && vc < stage2_top+25 && hc > stage_left+160 && hc < stage_left+165) begin
             makeWhite();
         end
 		  //bottom horizontal
         else if (vc > stage2_top+40 && vc < stage2_top+45 && hc > stage_left+160 && hc < stage_left+190) begin
             makeWhite();
         end
 		  //left bottom vertical
         else if (vc > stage2_top+20 && vc < stage2_top+45 && hc > stage_left+160 && hc < stage_left+165) begin          
             makeWhite();
         end		  
         else begin
             if (stageState == stage2)
					makeBlue();
				else
					makeBlack();
         end	
 	end
	// 2
	else if (hc > stage_left+240 && hc < stage_left+280 && vc > stage2_top && vc < stage2_top+45) begin
 		  // top horizontal
         if (vc > stage2_top && vc < stage2_top+5 && hc > stage_left+240 && hc < stage_left+270) begin
             makeWhite();
         end
 		  //middle horizontal
         else if (vc > stage2_top+20 && vc < stage2_top+25 && hc > stage_left+240 && hc < stage_left+270) begin
             makeWhite();
         end
			//right top vertical
         else if (vc > stage2_top && vc < stage2_top+25 && hc > stage_left+265 && hc < stage_left+270) begin
             makeWhite();
         end
 		  //bottom horizontal
         else if (vc > stage2_top+40 && vc < stage2_top+45 && hc > stage_left+240 && hc < stage_left+270) begin
             makeWhite();
         end
 		  //left bottom vertical
         else if (vc > stage2_top+20 && vc < stage2_top+45 && hc > stage_left+240 && hc < stage_left+245) begin          
             makeWhite();
         end		  
         else begin
             if (stageState == stage2)
					makeBlue();
				else
					makeBlack();
         end	
 	end
	/////////////////////////
	//stage 3
	/////////////////
	//s(tage 3)
	else if (hc > stage_left && hc < stage_left+40 && vc > stage3_top && vc < stage3_top+45) begin
 		  // top horizontal
         if (vc > stage3_top && vc < stage3_top+5 && hc > stage_left && hc < stage_left+30) begin
             makeWhite();
         end
 		  //middle horizontal
         else if (vc > stage3_top+20 && vc < stage3_top+25 && hc > stage_left && hc < stage_left+30) begin
             makeWhite();
         end
 		  //left top vertical
         else if (vc > stage3_top && vc < stage3_top+25 && hc > stage_left && hc < stage_left+5) begin
             makeWhite();
         end
 		  //bottom horizontal
         else if (vc > stage3_top+40 && vc < stage3_top+45 && hc > stage_left && hc < stage_left+30) begin
             makeWhite();
         end
 		  //right bottom vertical
         else if (vc > stage3_top+20 && vc < stage3_top+45 && hc > stage_left+25 && hc < stage_left+30) begin           
 				makeWhite();
         end		  
         else begin
             if (stageState == stage3)
					makeBlue();
				else
					makeBlack();
         end	
 	end
	//t(age 3)
	else if (hc > stage_left+40 && hc < stage_left+80 && vc > stage3_top && vc < stage3_top+45) begin
 		  //middle horizontal
         if (vc > stage3_top+20 && vc < stage3_top+25 && hc > stage_left+40 && hc < stage_left+70) begin
             makeWhite();
         end
 		  //left top vertical
         else if (vc > stage3_top && vc < stage3_top+25 && hc > stage_left+40 && hc < stage_left+45) begin
             makeWhite();
         end
 		  //bottom horizontal
         else if (vc > stage3_top+40 && vc < stage3_top+45 && hc > stage_left+40 && hc < stage_left+70) begin
             makeWhite();
         end
 		  //left bottom vertical
         else if (vc > stage3_top+20 && vc < stage3_top+45 && hc > stage_left+40 && hc < stage_left+45) begin          
             makeWhite();
         end		  
         else begin
             if (stageState == stage3)
					makeBlue();
				else
					makeBlack();
         end	
 	end
	//a(ge 3)
	else if (hc > stage_left+80 && hc < stage_left+120 && vc > stage3_top && vc < stage3_top+45) begin
 		  // top horizontal
         if (vc > stage3_top && vc < stage3_top+5 && hc > stage_left+80 && hc < stage_left+110) begin
             makeWhite();
         end
 		  //middle horizontal
         else if (vc > stage3_top+20 && vc < stage3_top+25 && hc > stage_left+80 && hc < stage_left+110) begin
             makeWhite();
         end
 		  //left top vertical
         else if (vc > stage3_top && vc < stage3_top+25 && hc > stage_left+80 && hc < stage_left+85) begin
             makeWhite();
         end
 		  //right top vertical
         else if (vc > stage3_top && vc < stage3_top+25 && hc > stage_left+105 && hc < stage_left+110) begin
             makeWhite();
         end
 		  //left bottom vertical
         else if (vc > stage3_top+20 && vc < stage3_top+45 && hc > stage_left+80 && hc < stage_left+85) begin          
             makeWhite();
         end
 		  //right bottom vertical
         else if (vc > stage3_top+20 && vc < stage3_top+45 && hc > stage_left+105 && hc < stage_left+110) begin           
 				makeWhite();
         end		  
         else begin
             if (stageState == stage3)
					makeBlue();
				else
					makeBlack();
         end	
 	end
	//g(e 3)
	else if (hc > stage_left+120 && hc < stage_left+160 && vc > stage3_top && vc < stage3_top+45) begin
 		  // top horizontal
         if (vc > stage3_top && vc < stage3_top+5 && hc > stage_left+120 && hc < stage_left+150) begin
             makeWhite();
         end
 		  //middle horizontal
         else if (vc > stage3_top+20 && vc < stage3_top+25 && hc > stage_left+120 && hc < stage_left+150) begin
             makeWhite();
         end
 		  //left top vertical
         else if (vc > stage3_top && vc < stage3_top+25 && hc > stage_left+120 && hc < stage_left+125) begin
             makeWhite();
         end
 		  //right top vertical
         else if (vc > stage3_top && vc < stage3_top+25 && hc > stage_left+145 && hc < stage_left+150) begin
             makeWhite();
         end
 		  //bottom horizontal
         else if (vc > stage3_top+40 && vc < stage3_top+45 && hc > stage_left+120 && hc < stage_left+150) begin
             makeWhite();
         end
 		  //right bottom vertical
         else if (vc > stage3_top+20 && vc < stage3_top+45 && hc > stage_left+145 && hc < stage_left+150) begin           
 				makeWhite();
         end		  
         else begin
             if (stageState == stage3)
					makeBlue();
				else
					makeBlack();
         end	
 	end
	//e( 3)
	else if (hc > stage_left+160 && hc < stage_left+200 && vc > stage3_top && vc < stage3_top+45) begin
 		  // top horizontal
         if (vc > stage3_top && vc < stage3_top+5 && hc > stage_left+160 && hc < stage_left+190) begin
             makeWhite();
         end
 		  //middle horizontal
         else if (vc > stage3_top+20 && vc < stage3_top+25 && hc > stage_left+160 && hc < stage_left+190) begin
             makeWhite();
         end
 		  //left top vertical
         else if (vc > stage3_top && vc < stage3_top+25 && hc > stage_left+160 && hc < stage_left+165) begin
             makeWhite();
         end
 		  //bottom horizontal
         else if (vc > stage3_top+40 && vc < stage3_top+45 && hc > stage_left+160 && hc < stage_left+190) begin
             makeWhite();
         end
 		  //left bottom vertical
         else if (vc > stage3_top+20 && vc < stage3_top+45 && hc > stage_left+160 && hc < stage_left+165) begin          
             makeWhite();
         end		  
         else begin
             if (stageState == stage3)
					makeBlue();
				else
					makeBlack();
         end	
 	end
	// 3
	else if (hc > stage_left+240 && hc < stage_left+280 && vc > stage3_top && vc < stage3_top+45) begin
 		  // top horizontal
         if (vc > stage3_top && vc < stage3_top+5 && hc > stage_left+240 && hc < stage_left+270) begin
             makeWhite();
         end
 		  //middle horizontal
         else if (vc > stage3_top+20 && vc < stage3_top+25 && hc > stage_left+240 && hc < stage_left+270) begin
             makeWhite();
         end
			//right top vertical
         else if (vc > stage3_top && vc < stage3_top+25 && hc > stage_left+265 && hc < stage_left+270) begin
             makeWhite();
         end
 		  //bottom horizontal
         else if (vc > stage3_top+40 && vc < stage3_top+45 && hc > stage_left+240 && hc < stage_left+270) begin
             makeWhite();
         end
 		  //right bottom vertical
         else if (vc > stage3_top+20 && vc < stage3_top+45 && hc > stage_left+265 && hc < stage_left+270) begin          
             makeWhite();
         end		  
         else begin
             if (stageState == stage3)
					makeBlue();
				else
					makeBlack();
         end	
 	end	
	///////
	//8 at bottom leftish
	else if (hc > d1l && hc < d1l+40 && vc > d3t && vc < d3t+45) begin
 		  // top horizontal
         if (vc > d3t && vc < d3t+5 && hc > d1l && hc < d1l+30) begin
             makeWhite();
         end
 		  //middle horizontal
         else if (vc > d3t+20 && vc < d3t+25 && hc > d1l && hc < d1l+30) begin
             makeWhite();
         end
 		  //left top vertical
         else if (vc > d3t && vc < d3t+25 && hc > d1l && hc < d1l+5) begin
             makeWhite();
         end
 		  //right top vertical
         else if (vc > d3t && vc < d3t+25 && hc > d1l+25 && hc < d1l+30) begin
             makeWhite();
         end
 		  //bottom horizontal
         else if (vc > d3t+40 && vc < d3t+45 && hc > d1l && hc < d1l+30) begin
             makeWhite();
         end
 		  //left bottom vertical
         else if (vc > d3t+20 && vc < d3t+45 && hc > d1l && hc < d1l+5) begin          
             makeWhite();
         end
 		  //right bottom vertical
         else if (vc > d3t+20 && vc < d3t+45 && hc > d1l+25 && hc < d1l+30) begin           
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
	displayDigit(score / 1000, (score % 1000) / 100, (score % 100) / 10, score % 10, 280);
	
end
endtask

parameter endleft1 = 200;
parameter endleft2 = 200;
parameter endtop1 = 200;
parameter endtop2 = 250;

task displayEnd;
begin
	//restart
	//r(estart)
	if (vc > endtop1 && vc < endtop1 + 45 && hc > endleft1 && hc < endleft1 + 40) begin
		  //middle horizontal
        if (vc > endtop1+20 && vc < endtop1+25 && hc > endleft1 && hc < endleft1+30)
				makeWhite();
		  //left bottom vertical
        else if (vc > endtop1+20 && vc < endtop1+45 && hc > endleft1 && hc < endleft1 + 5) 
            makeWhite();	  
        else begin
            if (endOptionState == restart)
					makeBlue();
				else
					makeBlack();
        end	
	end
	//e(start)
	else if (vc > endtop1 && vc < endtop1 + 45 && hc > endleft1+40 && hc < endleft1 + 80) begin
		  // top horizontal
        if (vc > endtop1 && vc < endtop1+ 5 && hc > endleft1+40 && hc < endleft1 + 70)   
				makeWhite();
		  //middle horizontal
        else if (vc > endtop1+20 && vc < endtop1+25 && hc > endleft1+40 && hc < endleft1+70)
				makeWhite();
		  //left top vertical
        else if (vc > endtop1 && vc < endtop1+25 && hc > endleft1+40 && hc < endleft1 + 45)
            makeWhite();
		  //bottom horizontal
        else if (vc > endtop1+40 && vc < endtop1+45 && hc > endleft1+40 && hc < endleft1 + 70)
            makeWhite();
		  //left bottom vertical
        else if (vc > endtop1+20 && vc < endtop1+45 && hc > endleft1+40 && hc < endleft1 + 45) 
            makeWhite();		  
        else begin
            if (endOptionState == restart)
					makeBlue();
				else
					makeBlack();
        end	
	end
	//s(tart)
	else if (vc > endtop1 && vc < endtop1 + 45 && hc > endleft1+80 && hc < endleft1 + 120) begin
		  // top horizontal
        if (vc > endtop1 && vc < endtop1+ 5 && hc > endleft1+80 && hc < endleft1 + 110)   
				makeWhite();
		  //middle horizontal
        else if (vc > endtop1+20 && vc < endtop1+25 && hc > endleft1+80 && hc < endleft1+110)
				makeWhite();
		  //left top vertical
        else if (vc > endtop1 && vc < endtop1+25 && hc > endleft1+80 && hc < endleft1 + 85)
            makeWhite();
		  //bottom horizontal
        else if (vc > endtop1+40 && vc < endtop1+45 && hc > endleft1+80 && hc < endleft1 + 110)
            makeWhite();
		  //right bottom vertical
        else if (vc > endtop1+20 && vc < endtop1+45 && hc > endleft1+105 && hc < endleft1 + 110) 
            makeWhite();		  
        else begin
            if (endOptionState == restart)
					makeBlue();
				else
					makeBlack();
        end	
	end
	//t(art)
	else if (vc > endtop1 && vc < endtop1 + 45 && hc > endleft1+120 && hc < endleft1 + 160) begin
		  //middle horizontal
        if (vc > endtop1+20 && vc < endtop1+25 && hc > endleft1+120 && hc < endleft1+150)
				makeWhite();
		  //left top vertical
        else if (vc > endtop1 && vc < endtop1+25 && hc > endleft1+120 && hc < endleft1 + 125)
            makeWhite();
		  //bottom horizontal
        else if (vc > endtop1+40 && vc < endtop1+45 && hc > endleft1+120 && hc < endleft1 + 150)
            makeWhite();
		  //left bottom vertical
        else if (vc > endtop1+20 && vc < endtop1+45 && hc > endleft1+120 && hc < endleft1 + 125) 
            makeWhite();		  
        else begin
            if (endOptionState == restart)
					makeBlue();
				else
					makeBlack();
        end	
	end
	//a(rt)
	else if (vc > endtop1 && vc < endtop1 + 45 && hc > endleft1+160 && hc < endleft1 + 200) begin
		  //top horizontal
        if (vc > endtop1 && vc < endtop1+5 && hc > endleft1+160 && hc < endleft1+190)
				makeWhite();
		  //middle horizontal
        else if (vc > endtop1+20 && vc < endtop1+25 && hc > endleft1+160 && hc < endleft1+190)
				makeWhite();
		  //left top vertical
        else if (vc > endtop1 && vc < endtop1+25 && hc > endleft1+160 && hc < endleft1 + 165)
            makeWhite();
		  //right top vertical
        else if (vc > endtop1 && vc < endtop1+25 && hc > endleft1+190 && hc < endleft1 + 195)
            makeWhite();
		  //left bottom vertical
        else if (vc > endtop1+20 && vc < endtop1+45 && hc > endleft1+160 && hc < endleft1 + 165) 
            makeWhite();
		  //right bottom vertical
        else if (vc > endtop1+20 && vc < endtop1+45 && hc > endleft1+190 && hc < endleft1 + 195) 
            makeWhite();				
        else begin
            if (endOptionState == restart)
					makeBlue();
				else
					makeBlack();
        end	
	end
	//r(t)
	else if (vc > endtop1 && vc < endtop1 + 45 && hc > endleft1+200 && hc < endleft1 + 240) begin
		  //middle horizontal
        if (vc > endtop1+20 && vc < endtop1+25 && hc > endleft1+200 && hc < endleft1+230)
				makeWhite();
		  //left bottom vertical
        else if (vc > endtop1+20 && vc < endtop1+45 && hc > endleft1+200 && hc < endleft1 + 205) 
            makeWhite();				
        else begin
            if (endOptionState == restart)
					makeBlue();
				else
					makeBlack();
        end	
	end
	//t
	else if (vc > endtop1 && vc < endtop1 + 45 && hc > endleft1+240 && hc < endleft1 + 280) begin
		  //middle horizontal
        if (vc > endtop1+20 && vc < endtop1+25 && hc > endleft1+240 && hc < endleft1+270)
				makeWhite();
		  //left top vertical
        else if (vc > endtop1 && vc < endtop1+25 && hc > endleft1+240 && hc < endleft1 + 245)
            makeWhite();
		  //bottom horizontal
        else if (vc > endtop1+40 && vc < endtop1+45 && hc > endleft1+240 && hc < endleft1 + 270)
            makeWhite();
		  //left bottom vertical
        else if (vc > endtop1+20 && vc < endtop1+45 && hc > endleft1+240 && hc < endleft1 + 245) 
            makeWhite();		  
        else begin
            if (endOptionState == restart)
					makeBlue();
				else
					makeBlack();
        end	
	end
	////////////////////////
	//end
	/////////////
	//e(nd)
	else if (vc > endtop2 && vc < endtop2 + 45 && hc > endleft2 && hc < endleft2 + 40) begin
		  // top horizontal
        if (vc > endtop2 && vc < endtop2+ 5 && hc > endleft2 && hc < endleft2 + 30)   
				makeWhite();
		  //middle horizontal
        else if (vc > endtop2+20 && vc < endtop2+25 && hc > endleft2 && hc < endleft2+30)
				makeWhite();
		  //left top vertical
        else if (vc > endtop2 && vc < endtop2+25 && hc > endleft2 && hc < endleft2 + 5)
            makeWhite();
		  //bottom horizontal
        else if (vc > endtop2+40 && vc < endtop2+45 && hc > endleft2 && hc < endleft2 + 30)
            makeWhite();
		  //left bottom vertical
        else if (vc > endtop2+20 && vc < endtop2+45 && hc > endleft2 && hc < endleft2 + 5)
				makeWhite();
        else begin
            if (endOptionState == endGame)
					makeBlue();
				else
					makeBlack();
        end	
	end
	//n(d)
	else if (vc > endtop2 && vc < endtop2 + 45 && hc > endleft2+40 && hc < endleft2 + 80) begin
		  //middle horizontal
        if (vc > endtop2+20 && vc < endtop2+25 && hc > endleft2+40 && hc < endleft2+70)
				makeWhite();
		  //left bottom vertical
        else if (vc > endtop2+20 && vc < endtop2+45 && hc > endleft2+40 && hc < endleft2 + 45) 
            makeWhite();
		  //right bottom vertical
        else if (vc > endtop2+20 && vc < endtop2+45 && hc > endleft2 + 65 && hc < endleft2 + 70)
            makeWhite();		  
        else begin
            if (endOptionState == endGame)
					makeBlue();
				else
					makeBlack();
        end	
	end
	//d
	else if (vc > endtop2 && vc < endtop2 + 45 && hc > endleft2+80 && hc < endleft2 + 120) begin
		  //middle horizontal
        if (vc > endtop2+20 && vc < endtop2+25 && hc > endleft2+80 && hc < endleft2+110)
				makeWhite();
		  //right top vertical
        else if (vc > endtop2 && vc < endtop2+25 && hc > endleft2 + 105 && hc < endleft2 + 110) 
            makeWhite();
		  //bottom horizontal
        else if (vc > endtop2+40 && vc < endtop2+45 && hc > endleft2+80 && hc < endleft2 + 110)
            makeWhite();
		  //left bottom vertical
        else if (vc > endtop2+20 && vc < endtop2+45 && hc > endleft2+80 && hc < endleft2 + 85) 
            makeWhite();
		  //right bottom vertical
        else if (vc > endtop2+20 && vc < endtop2+45 && hc > endleft2 + 105 && hc < endleft2 + 110)
            makeWhite();		  
        else begin
            if (endOptionState == endGame)
					makeBlue();
				else
					makeBlack();
        end	
	end
	//////////////
	else
		displayScore(score);
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
	if (hc >left_boundary && hc < left_boundary + 40) begin
        // 0
		  // top horizontal
        if (vc > 400 && vc < 405 && hc > left_boundary && hc < left_boundary + 30 &&
				(thousand == 0 || thousand == 2 || thousand == 3 || thousand == 5 || thousand == 6 || thousand == 7 || thousand == 8 || thousand == 9)) begin
            makeWhite();
        end
		  //middle horizontal
        else if (vc > 420 && vc < 425 && hc > left_boundary && hc < left_boundary + 30 &&
		  (thousand == 2 || thousand == 3 || thousand == 4 || thousand == 5 || thousand == 6 || thousand == 8 || thousand == 9)) begin
            makeWhite();
        end
		  //left top vertical
        else if (vc > 400 && vc < 425 && hc > left_boundary && hc < left_boundary + 5 &&
		  (thousand == 0 || thousand == 1 || thousand == 4 || thousand == 5 || thousand == 6 || thousand == 8 || thousand == 9)) begin
            makeWhite();
        end
		  //right top vertical
        else if (vc > 400 && vc < 425 && hc > left_boundary + 25 && hc < left_boundary + 30 &&
		  (thousand == 0 || thousand == 2 || thousand == 3 || thousand == 4 || thousand == 7 || thousand == 8 || thousand == 9)) begin
            red = 3'b111;
            green = 3'b111;
            blue = 2'b11;
        end
		  //bottom horizontal
        else if (vc > 440 && vc < 445 && hc > left_boundary && hc < left_boundary + 30 && 
		  (thousand == 0 || thousand == 2 || thousand == 3 || thousand == 5 || thousand == 6 || thousand == 8)) begin
            makeWhite();
        end
		  //left bottom vertical
        else if (vc > 420 && vc < 445 && hc > left_boundary && hc < left_boundary + 5 &&
		  (thousand == 0 || thousand == 1 || thousand == 2 || thousand == 6 || thousand == 8)) begin
            makeWhite();
        end
		  //right bottom vertical
        else if (vc > 420 && vc < 445 && hc > left_boundary + 25 && hc < left_boundary + 30 &&
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
        if (vc > 400 && vc < 405 && hc > left_boundary + 40 && hc < left_boundary + 30 + 40 &&
			(hundred == 0 || hundred == 2 || hundred == 3 || hundred == 5 || hundred == 6 || hundred == 7 || hundred == 8 || hundred == 9)) begin
            makeWhite();
        end
		  //middle horizontal
        else if (vc > 420 && vc < 425 && hc > left_boundary + 40 && hc < left_boundary + 30 + 40 &&
		  (hundred == 2 || hundred == 3 || hundred == 4 || hundred == 5 || hundred == 6 || hundred == 8 || hundred == 9)) begin
            makeWhite();
        end
		  //left top vertical
        else if (vc > 400 && vc < 425 && hc > left_boundary + 40 && hc < 40 + left_boundary + 5 &&
		  (hundred == 0 || hundred == 1 || hundred == 4 || hundred == 5 || hundred == 6 || hundred == 8 || hundred == 9)) begin
            makeWhite();
        end
		  //right top vertical
        else if (vc > 400 && vc < 425 && hc > left_boundary + 25 + 40 && hc < 40 + left_boundary + 30 &&
		  (hundred == 0 || hundred == 2 || hundred == 3 || hundred == 4 || hundred == 7 || hundred == 8 || hundred == 9)) begin
            makeWhite();
        end
		  //bottom horizontal
        else if (vc > 440 && vc < 445 && hc > 40 + left_boundary && hc < 40 + left_boundary + 30 && 
		  (hundred == 0 || hundred == 2 || hundred == 3 || hundred == 5 || hundred == 6 || hundred == 8)) begin
            red = 3'b111;
            green = 3'b111;
            blue = 2'b11;
        end
		  //left bottom vertical
        else if (vc > 420 && vc < 445 && hc > 40 + left_boundary && hc < 40 + left_boundary + 5 &&
		  (hundred == 0 || hundred == 1 || hundred == 2 || hundred == 6 || hundred == 8)) begin
            red = 3'b111;
            green = 3'b111;
            blue = 2'b11;
        end
		  //right bottom vertical
        else if (vc > 420 && vc < 445 && hc > 40 + left_boundary + 25 && hc < 40 + left_boundary + 30 &&
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
        if (vc > 400 && vc < 405 && hc > 80 + left_boundary && hc < 80 + left_boundary + 30 &&
				(ten == 0 || ten == 2 || ten == 3 || ten == 5 || ten == 6 || ten == 7 || ten == 8 || ten == 9)) begin
            red = 3'b111;
            green = 3'b111;
            blue = 2'b11;
        end
		  //middle horizontal
        else if (vc > 420 && vc < 425 && hc > 80 + left_boundary && hc < 80 + left_boundary + 30 &&
		  (ten == 2 || ten == 3 || ten == 4 || ten == 5 || ten == 6 || ten == 8 || ten == 9)) begin
            red = 3'b111;
            green = 3'b111;
            blue = 2'b11;
        end
		  //left top vertical
        else if (vc > 400 && vc < 425 && hc > 80 + left_boundary && hc < 80 + left_boundary + 5 &&
		  (ten == 0 || ten == 1 || ten == 4 || ten == 5 || ten == 6 || ten == 8 || ten == 9)) begin
            red = 3'b111;
            green = 3'b111;
            blue = 2'b11;
        end
		  //right top vertical
        else if (vc > 400 && vc < 425 && hc > 80 + left_boundary + 25 && hc < 80 + left_boundary + 30 &&
		  (ten == 0 || ten == 2 || ten == 3 || ten == 4 || ten == 7 || ten == 8 || ten == 9)) begin
            red = 3'b111;
            green = 3'b111;
            blue = 2'b11;
        end
		  //bottom horizontal
        else if (vc > 440 && vc < 445 && hc > 80 + left_boundary && hc < 80 + left_boundary + 30 && 
		  (ten == 0 || ten == 2 || ten == 3 || ten == 5 || ten == 6 || ten == 8)) begin
            red = 3'b111;
            green = 3'b111;
            blue = 2'b11;
        end
		  //left bottom vertical
        else if (vc > 420 && vc < 445 && hc > 80 + left_boundary && hc < 80 + left_boundary + 5 &&
		  (ten == 0 || ten == 1 || ten == 2 || ten == 6 || ten == 8)) begin
            red = 3'b111;
            green = 3'b111;
            blue = 2'b11;
        end
		  //right bottom vertical
        else if (vc > 420 && vc < 445 && hc > 80 + left_boundary + 25 && hc < 80 + left_boundary + 30 &&
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
        if (vc > 400 && vc < 405 && hc > 120 + left_boundary && hc < 120 + left_boundary + 30 &&
				(number == 0 || number == 2 || number == 3 || number == 5 || number == 6 || number == 7 || number == 8 || number == 9)) begin
            red = 3'b111;
            green = 3'b111;
            blue = 2'b11;
        end
		  //middle horizontal
        else if (vc > 420 && vc < 425 && hc > 120+left_boundary && hc < 120+left_boundary + 30 &&
		  (number == 2 || number == 3 || number == 4 || number == 5 || number == 6 || number == 8 || number == 9)) begin
            red = 3'b111;
            green = 3'b111;
            blue = 2'b11;
        end
		  //left top vertical
        else if (vc > 400 && vc < 425 && hc > 120+left_boundary && hc < 120+left_boundary + 5 &&
		  (number == 0 || number == 1 || number == 4 || number == 5 || number == 6 || number == 8 || number == 9)) begin
            red = 3'b111;
            green = 3'b111;
            blue = 2'b11;
        end
		  //right top vertical
        else if (vc > 400 && vc < 425 && hc > 120+left_boundary + 25 && hc < 120+left_boundary + 30 &&
		  (number == 0 || number == 2 || number == 3 || number == 4 || number == 7 || number == 8 || number == 9)) begin
            red = 3'b111;
            green = 3'b111;
            blue = 2'b11;
        end
		  //bottom horizontal
        else if (vc > 440 && vc < 445 && hc > 120+left_boundary && hc < 120+left_boundary + 30 && 
		  (number == 0 || number == 2 || number == 3 || number == 5 || number == 6 || number == 8)) begin
            red = 3'b111;
            green = 3'b111;
            blue = 2'b11;
        end
		  //left bottom vertical
        else if (vc > 420 && vc < 445 && hc > 120+left_boundary && hc < 120+left_boundary + 5 &&
		  (number == 0 || number == 1 || number == 2 || number == 6 || number == 8)) begin
            red = 3'b111;
            green = 3'b111;
            blue = 2'b11;
        end
		  //right bottom vertical
        else if (vc > 420 && vc < 445 && hc > 120+left_boundary + 25 && hc < 120+left_boundary + 30 &&
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
