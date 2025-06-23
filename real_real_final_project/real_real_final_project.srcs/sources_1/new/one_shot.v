`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/25 04:30:47
// Design Name: 
// Module Name: one_shot
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


module one_shot(
    input wire clk,
    input wire internal_reset,
    input wire signal,
    output wire tick
);
    reg signal_delay;
    
    always @(posedge clk or posedge internal_reset) begin
        if (internal_reset)
            signal_delay <= 1'b0;
        else
            signal_delay <= signal;
    end
    
    assign tick = signal & ~signal_delay;
endmodule


