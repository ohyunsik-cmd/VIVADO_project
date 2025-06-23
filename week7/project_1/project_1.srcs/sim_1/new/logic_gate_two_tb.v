`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/12 12:44:23
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


module logic_gate_two_tb( );

reg clk,rst;
reg btn;
wire [7:0] seg_data;
wire [7:0] seg_sel;

logic_gate_two U3(clk,rst,btn,seg_data,seg_sel);

always begin
    #2 clk = ~clk;
end

initial begin
    clk = 0;
    rst = 1;
    btn = 0;
    #10 rst = 0;
    #10 rst = 1;
    #20 btn=1;#5 btn=0;//1
    #27 btn=1;#5 btn=0;//2
    #27 btn=1;#5 btn=0;//3
    #27 btn=1;#5 btn=0;//4
    #27 btn=1;#5 btn=0;//5
    #27 btn=1;#5 btn=0;//6
    #27 btn=1;#5 btn=0;//7
    #27 btn=1;#5 btn=0;//8
    #27 btn=1;#5 btn=0;//9
    
    #27 btn=1;#5 btn=0;//10
    #27 btn=1;#5 btn=0;//11
    #27 btn=1;#5 btn=0;//12
    #27 btn=1;#5 btn=0;//13
    #27 btn=1;#5 btn=0;//14
    #27 btn=1;#5 btn=0;//15
    #27 btn=1;#5 btn=0;//0
    #27 btn=1;#5 btn=0;//1     
end

endmodule
