`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:19:46 05/21/2018 
// Design Name: 
// Module Name:    sync 
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
module sync(
	input pixel_clk,
    output reg [2:0] red,
    output reg [2:0] green,
    output reg [1:0] blue,
	output Vsync,
	output Hsync
);

reg [9:0] h_count;
reg [9:0] v_count;

initial begin
	h_count <= 0;
	v_count <= 0;
end

always @ (posedge pixel_clk) begin
	if (h_count == 799) begin
		h_count <= 0;
        if (v_count == 520) begin
            v_count <= 0;
        end
        else begin
            v_count <= v_count + 1;
        end
	end
	else begin
		h_count <= h_count + 1;
	end
end

assign Hsync = (h_count < 96 ? 0 : 1);
assign Vsync = (v_count < 2 ? 0 : 1);

always @ (h_count, v_count) begin
    if (v_count >= 31 && v_count < 511) begin
        if (h_count >= 144 && h_count < 784) begin
            red <= 3'b111;
            green <= 3'b000;
            blue <= 2'b00;
        end
        else begin // outside horizontal active range
            red <= 3'b000;
            green <= 3'b000;
            blue <= 2'b00;
        end
    end
    else begin // outside vertical active range
        red <= 3'b000;
        green <= 3'b000;
        blue <= 2'b00;
    end
end

endmodule
