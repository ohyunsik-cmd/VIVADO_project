`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/20 00:07:08
// Design Name: 
// Module Name: logic_gate_three
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


module logic_gate_three(I0,I1,I2,I3,I4,I5,I6,I7,S0,S1,S2,Y);

output [3:0]Y;
input [3:0]I0,I1,I2,I3,I4,I5,I6,I7;
input S0,S1,S2;
wire [3:0]A1,A2;

mux_4to1 U1(.I0(I0),.I1(I1),.I2(I2),.I3(I3),.S0(S0),.S1(S1),.Y(A1));
mux_4to1 U2(.I0(I4),.I1(I5),.I2(I6),.I3(I7),.S0(S0),.S1(S1),.Y(A2));
mux_2to1 U3(.I0(A1),.I1(A2),.S(S2),.Y(Y));

endmodule
