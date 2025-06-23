//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/09 00:25:16
// Design Name: 
// Module Name: fulladder_tb
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
`timescale 1ns / 1ps

module fulladder_tb( );

reg x,y,z;
wire s,c;

fulladder U3(.x(x),.y(y),.z(z),.s(s),.c(c));

initial begin
x=0;y=0;z=0; #10;
x=0;y=0;z=1; #10;
x=0;y=1;z=0; #10;
x=0;y=1;z=1; #10;
x=1;y=0;z=0; #10;
x=1;y=0;z=1; #10;
x=1;y=1;z=0; #10;
x=1;y=1;z=1;
end

endmodule
