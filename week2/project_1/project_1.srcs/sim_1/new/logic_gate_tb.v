`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/08 23:13:23
// Design Name: 
// Module Name: logic_gate_tb
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


module logic_gate_tb();
reg a,b; 

wire q,w,x,y,z;

logic_gate U1(.a(a),.b(b),.q(q),.w(w),.x(x),.y(y),.z(z));

initial begin
a=0;b=0;#10
a=0;b=1;#10
a=1;b=0;#10
a=1;b=1;
end
endmodule
