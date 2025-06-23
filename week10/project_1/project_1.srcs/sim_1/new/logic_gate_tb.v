`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/31 12:39:52
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

reg rst,clk;

wire LCD_E,LCD_RS,LCD_RW;
wire[7:0] LCD_DATA;
wire[7:0] LED_out;

logic_gate U1 (rst,clk,LCD_E,LCD_RS,LCD_RW,LCD_DATA,LED_out);

initial begin
    clk<=0;
    rst<=0;
    #10 rst<=1;  
    end

always begin
    #0.5 clk<=~clk;
end


endmodule
