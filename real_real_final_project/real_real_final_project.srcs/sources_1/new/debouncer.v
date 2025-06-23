`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/25 04:31:43
// Design Name: 
// Module Name: debouncer
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


module debouncer(
    input wire clk,
    input wire internal_reset,
    input wire button_in,
    output reg button_out
);
    parameter DEBOUNCE_TIME = 20'd250000;  // 5ms at 50MHz
    
    reg [19:0] counter;
    reg button_ff1, button_ff2;
    
    always @(posedge clk or posedge internal_reset) begin
        if (internal_reset) begin
            button_ff1 <= 1'b0;
            button_ff2 <= 1'b0;
        end
        else begin
            button_ff1 <= button_in;
            button_ff2 <= button_ff1;
        end
    end
    
    always @(posedge clk or posedge internal_reset) begin
        if (internal_reset) begin
            counter <= 20'd0;
            button_out <= 1'b0;
        end
        else begin
            if (button_ff2 != button_out) begin
                if (counter == DEBOUNCE_TIME) begin
                    button_out <= button_ff2;
                    counter <= 20'd0;
                end
                else
                    counter <= counter + 20'd1;
            end
            else
                counter <= 20'd0;
        end
    end
endmodule
