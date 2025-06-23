`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/29 22:48:58
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

reg clk,J,K;
wire Q;

logic_gate_two U1(clk,J,K,Q);

initial begin
    clk<=0;
    #20 J<=0;K<=0;
    #20 J<=0;K<=1;
    #20 J<=0;K<=0;
    #20 J<=1;K<=0;
    #20 J<=0;K<=0;
    #20 J<=1;K<=1;
    #20 J<=0;K<=0;
end

always begin
    #5 clk<=~clk;
end

endmodule
