`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/22 23:56:50
// Design Name: 
// Module Name: logic_gate_four
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


module logic_gate_five(i0,i1,i2,i3,s0,s1,y);


output [1:0] y;
input [1:0] i0,i1,i2,i3;
input s0,s1;

assign y=s1?(s0?i3:i2):(s0?i1:i0);

endmodule


