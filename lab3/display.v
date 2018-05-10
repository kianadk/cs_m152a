`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:15:40 05/07/2018 
// Design Name: 
// Module Name:    display 
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
module display(
    input sel1,
	 input sel2,
	 input adj,
    input blink_clock,
    input fast_clock,
    input [3:0] min_ten,
    input [3:0] min_unit,
    input [2:0] sec_ten,
    input [3:0] sec_unit,
	 output reg [7:0] seg,
	 output reg [3:0] an
);

reg [1:0] state;

initial begin
	state <= 0;
end

always @ (posedge fast_clock) begin
	case (state)
		2'b00:
		begin
			state = state + 1;
			if (blink_clock && adj && sel1 && !sel2)
				an <= 4'b1111;
			else
				an <= 4'b1011;
		end
		2'b01:
		begin
			state = state + 1;
			if (blink_clock && adj && !sel1 && sel2)
				an <= 4'b1111;
			else
				an <= 4'b1101;
		end
		2'b10:
		begin
			state = state + 1;
			if (blink_clock && adj && !sel1 && !sel2)
				an <= 4'b1111;
			else
				an <= 4'b1110;
		end
		2'b11:
		begin
			state = 0;
			if (blink_clock && adj && sel1 && sel2)
				an <= 4'b1111;
			else
				an <= 4'b0111;
		end
		default:
				an <= 4'b0111;
	endcase
end

always begin
	case (an)
		4'b0111:
			case (min_ten)
				4'b0000:
					seg <= 8'b11000000;
				4'b0001:
					seg <= 8'b11111001;
				4'b0010:
					seg <= 8'b10100100;
				4'b0011:
					seg <= 8'b10110000;
				4'b0100:
					seg <= 8'b10011001;
				4'b0101:
					seg <= 8'b10010010;
				4'b0110:
					seg <= 8'b10000010;
				4'b0111:
					seg <= 8'b11111000;
				4'b1000:
					seg <= 8'b10000000;
				4'b1001:
					seg <= 8'b10011000;
				default:
					seg <= 8'b10000110;
			endcase
		4'b1011:
			case (min_unit)
				4'b0000:
					seg <= 8'b11000000;
				4'b0001:
					seg <= 8'b11111001;
				4'b0010:
					seg <= 8'b10100100;
				4'b0011:
					seg <= 8'b10110000;
				4'b0100:
					seg <= 8'b10011001;
				4'b0101:
					seg <= 8'b10010010;
				4'b0110:
					seg <= 8'b10000010;
				4'b0111:
					seg <= 8'b11111000;
				4'b1000:
					seg <= 8'b10000000;
				4'b1001:
					seg <= 8'b10011000;
				default:
					seg <= 8'b10000110;
			endcase
		4'b1101:
			case (sec_ten)
				4'b0000:
					seg <= 8'b11000000;
				4'b0001:
					seg <= 8'b11111001;
				4'b0010:
					seg <= 8'b10100100;
				4'b0011:
					seg <= 8'b10110000;
				4'b0100:
					seg <= 8'b10011001;
				4'b0101:
					seg <= 8'b10010010;
				default:
					seg <= 8'b10000110;
			endcase
		4'b1110:
			case (sec_unit)
				4'b0000:
					seg <= 8'b11000000;
				4'b0001:
					seg <= 8'b11111001;
				4'b0010:
					seg <= 8'b10100100;
				4'b0011:
					seg <= 8'b10110000;
				4'b0100:
					seg <= 8'b10011001;
				4'b0101:
					seg <= 8'b10010010;
				4'b0110:
					seg <= 8'b10000010;
				4'b0111:
					seg <= 8'b11111000;
				4'b1000:
					seg <= 8'b10000000;
				4'b1001:
					seg <= 8'b10011000;
				default:
					seg <= 8'b10000110;
			endcase	
		default:
			seg <= 8'b10000110;
	endcase
end

endmodule
