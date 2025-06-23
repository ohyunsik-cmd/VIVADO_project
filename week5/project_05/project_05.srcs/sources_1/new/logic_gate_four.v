`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/29 23:28:39
// Design Name: 
// Module Name: logic_gate_four
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


module logic_gate_four( clk, rst, T, Q );

input T, clk, rst;
reg T_reg, T_trig;
output reg Q;

always @(negedge rst or posedge clk) begin
    if(!rst) begin
        Q <= 1'b0;
        T_reg <= 1'b0;
        T_trig <= 1'b0;
    end
    else begin
        T_trig <= T & ~T_reg;
        T_reg <= T;
        if(T_trig)
            Q <= ~Q;
    end
end

endmodule
