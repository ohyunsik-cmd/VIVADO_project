`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/25 04:28:23
// Design Name: 
// Module Name: seven_segment_ctrl
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


module seven_segment_ctrl(
    input wire clk,
    input wire internal_reset,
    input wire [2:0] floor_ev1,
    input wire [2:0] floor_ev2,
    input wire [2:0] target_floor_ev1,    // 추가
    input wire [2:0] target_floor_ev2,    // 추가
    input wire direction_ev1,
    input wire direction_ev2,
    input wire [31:0] timer_counter_ev1,
    input wire [31:0] timer_counter_ev2,
    output reg [7:0] seg_data,    // A~G, DP
    output reg [7:0] seg_sel      // S0~S7
);
    // Parameters for digit selection timing
    parameter SCAN_FREQ = 480;  // Hz
    parameter CLK_FREQ = 50_000_000;  // 50MHz
    parameter SCAN_COUNT = CLK_FREQ / (SCAN_FREQ * 8);

    // ???? 0-9?? ???? 7-segment ???? (active low)
    // ????: ABCDEFG,DP
    reg [7:0] num_patterns [0:9];
    initial begin
    num_patterns[0] = 8'b00111111;  // 0
    num_patterns[1] = 8'b00000110;  // 1
    num_patterns[2] = 8'b01011011;  // 2
    num_patterns[3] = 8'b01001111;  // 3
    num_patterns[4] = 8'b01100110;  // 4
    num_patterns[5] = 8'b01101101;  // 5
    num_patterns[6] = 8'b01111101;  // 6
    num_patterns[7] = 8'b00000111;  // 7
    num_patterns[8] = 8'b01111111;  // 8
    num_patterns[9] = 8'b01101111;  // 9
    end

    // Special patterns
    parameter PATTERN_U = 8'b00111110;  // U
    parameter PATTERN_D = 8'b01011110;  // d
    parameter PATTERN_OFF = 8'b00000000; // All segments off

    // Internal registers
    reg [19:0] scan_counter;
    reg [2:0] digit_select;
    
    // Scan counter for digit multiplexing
    always @(posedge clk or posedge internal_reset) begin
        if (internal_reset) begin
            scan_counter <= 20'd0;
            digit_select <= 3'd0;
        end
        else begin
            if (scan_counter >= SCAN_COUNT - 1) begin
                scan_counter <= 20'd0;
                digit_select <= digit_select + 1'b1;
            end
            else begin
                scan_counter <= scan_counter + 1'b1;
            end
        end
    end

    // Convert timer values to display digits (0-9 range)
    function [3:0] get_timer_digit;
        input [31:0] timer_value;
        begin
            get_timer_digit = (timer_value >= 10) ? 4'd9 : timer_value[3:0];
        end
    endfunction

    // Display multiplexing logic
    always @(posedge clk or posedge internal_reset) begin
        if (internal_reset) begin
            seg_data <= PATTERN_OFF;
            seg_sel <= 8'hFF;
        end
        else begin
            case (digit_select)
                3'd0: begin  // EV1 ??????
                    seg_data <= num_patterns[floor_ev1];
                    seg_sel <= 8'b11111110;
                end
                3'd1: begin  // EV1 ????
                    seg_data <= direction_ev1 ? PATTERN_U : PATTERN_D;
                    seg_sel <= 8'b11111101;
                end
                3'd2: begin  // EV1 ????
                    seg_data <= num_patterns[get_timer_digit(timer_counter_ev1)];
                    seg_sel <= 8'b11111011;
                end
                3'd3: begin  // ?? ???
                    seg_data <= num_patterns[target_floor_ev1];
                    seg_sel <= 8'b11110111;
                end
                3'd4: begin  // EV2 ??????
                    seg_data <= num_patterns[floor_ev2];
                    seg_sel <= 8'b11101111;
                end
                3'd5: begin  // EV2 ????
                    seg_data <= direction_ev2 ? PATTERN_U : PATTERN_D;
                    seg_sel <= 8'b11011111;
                end
                3'd6: begin  // EV2 ????
                    seg_data <= num_patterns[get_timer_digit(timer_counter_ev2)];
                    seg_sel <= 8'b10111111;
                end
                3'd7: begin  // ?? ???
                    seg_data <= num_patterns[target_floor_ev2];
                    seg_sel <= 8'b01111111;
                end
                default: begin
                    seg_data <= PATTERN_OFF;
                    seg_sel <= 8'hFF;
                end
            endcase
        end
    end

endmodule
