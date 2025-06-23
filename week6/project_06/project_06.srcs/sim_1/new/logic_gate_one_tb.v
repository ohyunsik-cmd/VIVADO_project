`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/04 00:25:51
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


module logic_gate_one_tb( );

reg clk,rst,x;
wire [1:0] state;
wire y;

logic_gate_one U1(clk,rst,x,y,state);

 initial begin
    clk<=0;
    rst<=1;
    #10 rst<=0;
    #10 rst<=1;
    x=1'b01;//1易帚
    
    #10 x=1'b00;//2易帚
    
    #10 x=1'b01;
    #10 x=1'b01;//3易帚

    #10 x=1'b01;
    #10 x=1'b00;//4易帚 
    
    #10 x=1'b01;
    #10 x=1'b01;
    #10 x=1'b01;
    #10 x=1'b01;//5易帚 
    
    #10 x=1'b00;
    #10 x=1'b01;
    #10 x=1'b01;
    #10 x=1'b00;//6易帚    
end

always begin
    #5 clk<=~clk;
end

endmodule
