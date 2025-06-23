`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/25 04:29:37
// Design Name: 
// Module Name: emergency_led_ctrl
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


module emergency_led_ctrl(
   input wire clk,
   input wire internal_reset,
   input wire emergency_ev1,
   input wire emergency_ev2,
   output reg [3:0] rgb_r,     // Red LED
   output reg [3:0] rgb_g,     // Green LED
   output reg [3:0] rgb_b      // Blue LED
);
   // PWM ????? (8???)
   reg [7:0] pwm_counter;
   
   // RGB LED ??? ??????
   parameter RED = 8'd255;    // 100% ??????
   parameter OFF = 8'd0;      // 0%

   // PWM ?????
   always @(posedge clk or posedge internal_reset) begin
       if (internal_reset)
           pwm_counter <= 8'd0;
       else
           pwm_counter <= pwm_counter + 1;
   end

   // RGB LED PWM ????
   always @(posedge clk or posedge internal_reset) begin
       if (internal_reset) begin
           rgb_r <= 4'b0000;
           rgb_g <= 4'b0000;
           rgb_b <= 4'b0000;
       end
       else begin
           if (emergency_ev1 || emergency_ev2) begin
               // ?????? LED PWM???? ????
               rgb_r <= (pwm_counter < RED) ? 4'b1111 : 4'b0000;
               rgb_g <= 4'b0000;
               rgb_b <= 4'b0000;
           end
           else begin
               // ????? ??? ???? ??? LED OFF
               rgb_r <= 4'b0000;
               rgb_g <= 4'b0000;
               rgb_b <= 4'b0000;
           end
       end
   end
endmodule
