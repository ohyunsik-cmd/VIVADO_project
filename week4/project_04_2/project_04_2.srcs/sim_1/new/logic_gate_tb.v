`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/19 19:00:22
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


module logic_gate_tb( );

reg [2:0] in;
wire [7:0] out;

logic_gate U3(.in(in),.out(out));
initial begin 
in=3'b000; #100;
in=3'b001; #100;
in=3'b010; #100;
in=3'b011; #100;
in=3'b100; #100;
in=3'b101; #100;
in=3'b110; #100;
in=3'b111;
end
endmodule

