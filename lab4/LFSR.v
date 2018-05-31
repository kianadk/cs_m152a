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
    output [29:0] rand
);

wire feedback = random[29] ^ random[5] ^ random[3] ^ random[0];

reg [29:0] random, random_next, random_done;
reg [4:0] count, count_next;

initial begin
    random <= 30'hF;
    count <= 0;
end

always @ (posedge clk) begin
    random <= random_next;
    count <= count_next;
    
    if (count == 30) begin
        count <= 0;
        random_done <= random;
    end
end

always @ (*) begin
    random_next = random;
    count_next = count;
    
    random_next = {random[28:0], feedback};
    count_next = count + 1;
end

assign rand = random_done;

endmodule
