`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/04 22:34:32
// Design Name: 
// Module Name: logic_gate_four_tb
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


module logic_gate_four_tb();

reg clk,rst;
reg x;
wire [2:0] state;

logic_gate_four U1(clk,rst,x,state);

always begin
    #5 clk = ~clk;
end

initial begin
    clk = 0;
    rst = 1;
    x = 0;
    #10 rst = 0;
    #10 rst = 1;
    #10 x = 1;#10 x = 0;
    #10 x = 1;#10 x = 0;
    #10 x = 1;#10 x = 0;
    #10 x = 1;#10 x = 0;
    #10 x = 1;#10 x = 0;
    #10 x = 1;#10 x = 0;
    #10 x = 1;#10 x = 0;
    #10 x = 1;#10 x = 0;
    #10 x = 1;#10 x = 0;
    #10 x = 1;#10 x = 0;
    #10 x = 1;#10 x = 0;
    #10 x = 1;#10 x = 0;
    #10 x = 1;#10 x = 0;
    #10 x = 1;#10 x = 0;
    #10 x = 1;#10 x = 0;
    #10 x = 1;#10 x = 0;
    #10 x = 1;#10 x = 0;
    #10 x = 1;#10 x = 0;
    
end

endmodule
