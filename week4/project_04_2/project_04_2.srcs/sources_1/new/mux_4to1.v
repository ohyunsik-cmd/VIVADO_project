`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/21 11:26:21
// Design Name: 
// Module Name: mux_4to1
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


module mux_4to1(I0,I1,I2,I3,S0,S1,Y);

output [3:0] Y;
input [3:0] I0,I1,I2,I3;
input S0,S1;

assign Y=S1?(S0?I3:I2):(S0?I1:I0);

endmodule
