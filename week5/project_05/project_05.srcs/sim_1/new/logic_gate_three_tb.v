`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/29 23:08:16
// Design Name: 
// Module Name: logic_gate_three_tb
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


module logic_gate_three_tb();

reg clk,rst,T;
wire Q;

logic_gate_three U1(clk,rst,T,Q);

initial begin
    clk<=0;
    rst<=1;
    #10 rst<=0;
    #10 rst<=1;
    #80 T<=0;
    #80 T<=1;
    #80 T<=0;
    #80 T<=1;    
    #80 T<=0;
    #80 T<=1;
    #80 T<=0;
end

always begin
    #5 clk<=~clk;
end

endmodule
