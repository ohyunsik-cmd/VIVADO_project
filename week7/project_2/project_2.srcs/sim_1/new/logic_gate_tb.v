

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/12 15:12:39
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
`timescale 1us / 1ns

module logic_gate_tb();

reg clk,rst;
reg[7:0] btn;
wire piezo;

logic_gate P1(clk,rst,btn,piezo);

initial begin
    clk<=0;
    rst<=1;
    btn<=8'b00000000;
    #1e+6;rst<=0;
    #1e+6;rst<=1;
    #1e+6;btn<=8'b00000010;//
    #1e+6;btn<=8'b00100000;//
end

always begin
    #0.5 clk<=~clk;
end

endmodule