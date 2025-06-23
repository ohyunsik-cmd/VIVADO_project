`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/29 20:15:26
// Design Name: 
// Module Name: logic_gate_one_tb
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


module logic_gate_one_tb();

reg clk,D;
wire Q;

logic_gate_one U1(clk,D,Q);

initial begin
    clk<=0;
    #30 D<=0;
    #30 D<=1;
    #30 D<=0;
    #30 D<=1;
    #30 D<=0;
    #30 D<=1;
    #30 D<=0;
end

always begin
    #5 clk<=~clk;
end

endmodule
