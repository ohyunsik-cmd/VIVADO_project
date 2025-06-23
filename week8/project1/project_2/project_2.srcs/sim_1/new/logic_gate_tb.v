`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/27 13:10:10
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

reg clk,rst;
reg [7:0] btn;
wire[3:0] led_signal_R;
wire[3:0] led_signal_G;
wire[3:0] led_signal_B;

logic_gate U1(clk,rst,btn,led_signal_R,led_signal_G,led_signal_B);

initial begin
    clk<=0;
    #0.5  rst<=0;
    btn<=8'b00000000;
    #1e+5 rst<=1;
    #1e+5 rst<=0;  
    #1e+6 btn<=8'b00000001;
    #1e+6 btn<=8'b00000010;
    #1e+6 btn<=8'b00000100;

end

always begin
    #0.5 clk<=~clk;
end

endmodule
