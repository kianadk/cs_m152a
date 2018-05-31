`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:57:57 05/31/2018 
// Design Name: 
// Module Name:    LFSR 
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
module LFSR(
    input clk,
    input [12:0] seed,
    output [12:0] rand
);

wire feedback = random[12] ^ random[3] ^ random[2] ^ random[0];

reg [12:0] random, random_next, random_done;
reg [3:0] count, count_next;

initial begin
    random <= 13'hF;
    count <= 0;
end

always @ (posedge clk) begin
    random <= random_next;
    count <= count_next;
    
    if (count == 13) begin
        count <= 0;
        random_done <= random;
    end
end

always @ (*) begin
    random_next = random;
    count_next = count;
    
    random_next = {random[11:0], feedback};
    count_next = count + 1;
end

assign rand = random_done;

endmodule
