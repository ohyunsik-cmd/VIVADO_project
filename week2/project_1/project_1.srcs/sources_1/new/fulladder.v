`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/09 00:13:09
// Design Name: 
// Module Name: fulladder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fulladder(x, y, z, s, c);

input x,y,z;
output s,c;

wire s1,c1,c2;

halfadder U1(x,y,s1,c1);
halfadder U2(z,s1,s,c2);

assign c=c1|c2;

endmodule
