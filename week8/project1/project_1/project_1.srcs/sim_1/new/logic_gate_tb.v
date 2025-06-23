`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/27 12:13:00
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


module logic_gate_tb(  );

reg clk,rst;
reg [7:0]bin;

wire [7:0] seg_data;
wire [7:0] seg_sel;
wire led_signal;

logic_gate U1(clk,rst,bin,seg_data,seg_sel,led_signal);

initial begin
    clk<=0;
  #0.5  rst<=0;
    #10 bin<=8'b00000000;
    #1e+5 rst<=1;
    #1e+5 rst<=0;  
    #1e+6; bin<=8'b01000000;
    #1e+6; bin<=8'b10000000;
    #1e+6; bin<=8'b11000000;
    #1e+6; bin<=8'b11111111;
end

always begin
    #0.5 clk<=~clk;
end

endmodule
