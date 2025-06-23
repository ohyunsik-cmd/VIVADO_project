`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/29 22:54:49
// Design Name: 
// Module Name: logic_gate_three
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


module logic_gate_three( clk,rst,T,Q );

input T,clk,rst;
output reg Q;

always @(posedge clk or negedge rst)
begin
    if(!rst)
        Q<=1'b0;
    else if(T)
        Q<=~Q;
end 

endmodule
