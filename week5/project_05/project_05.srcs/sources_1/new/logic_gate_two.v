`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/29 22:07:13
// Design Name: 
// Module Name: logic_gate_two
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


module logic_gate_two(clk,J,K,Q);

input J,K,clk;
output reg Q;

always @(posedge clk)
begin
    if(J==0&&K==0) 
    begin Q<=Q;end
    if(J==0&&K==1) 
    begin Q<=1'b0;end       
    if(J==1&&K==0) 
    begin Q<=1'b1;end    
    if(J==1&&K==1)
    begin Q<=~Q;end
end

endmodule