`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/19 18:43:23
// Design Name: 
// Module Name: logic_gate
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


module logic_gate(in, out);

input [2:0] in;
output reg [7:0] out;

always @(in) begin
    out = 8'b0;
    out[in] = 1'b1;
end
endmodule
