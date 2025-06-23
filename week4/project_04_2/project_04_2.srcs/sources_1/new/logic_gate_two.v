`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/19 23:23:34
// Design Name: 
// Module Name: logic_gate_two
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


module logic_gate_two(a,b,c,d,x,y);

input a,b,c,d;
output x,y;
wire x,y;

assign x=c|d;
assign y=(~c&b)|d;

endmodule
