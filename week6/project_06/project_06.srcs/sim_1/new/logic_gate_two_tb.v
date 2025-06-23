`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/04 19:18:08
// Design Name: 
// Module Name: logic_gate_two_tb
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


module logic_gate_two_tb();

reg clk,rst;
reg A,B,C;
wire [2:0]state;
wire y;

logic_gate_two U1(clk,rst,A,B,C,state,y);

initial begin
    clk<=0;
    rst<=1;
    A<=0;
    B<=0;
    C<=0;
    #10 rst<=0;
    #10 rst<=1;
    #15 A<=1'b01;#15 A<=1'b00;
    #15 B<=1'b01;#15 B<=1'b00;
    #15 A<=1'b01;#15 A<=1'b00;
    #15 B<=1'b01;#15 B<=1'b00;
    #15 C<=1'b01;#15 C<=1'b00;
    #15 rst<=0;#15 rst<=1;
    #15 A<=1'b01;#15 A<=1'b00;
    #15 B<=1'b01;#15 B<=1'b00;
    #15 C<=1'b01;#15 C<=1'b00;
    
end

always begin
    #5 clk<=~clk;
end

endmodule
