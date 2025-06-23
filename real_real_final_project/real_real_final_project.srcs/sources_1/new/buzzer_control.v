`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/25 04:30:13
// Design Name: 
// Module Name: buzzer_control
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


module buzzer_control(
    input wire clk,               // 50MHz main clock
    input wire internal_reset,
    input wire trigger,           // Floor arrival trigger
    input wire emergency_ev1,
    input wire emergency_ev2,
    output reg piezo_out
);
    // Clock divider for 1MHz (50MHz/50 = 1MHz)
    reg [5:0] clk_div;  // 6비트 카운터 (0~49)
    wire piezo_clk;
    
    always @(posedge clk or posedge internal_reset) begin
        if (internal_reset)
            clk_div <= 6'd0;
        else if (clk_div >= 6'd49)  // 50분주
            clk_div <= 6'd0;
        else 
            clk_div <= clk_div + 1'b1;
    end
    
    assign piezo_clk = (clk_div == 6'd0);  // 1MHz 클럭 생성
    
    // Parameters for musical notes (1MHz 기준)
    parameter CLK_DIV_FREQ = 1_000_000;  // 1MHz
    parameter C4 = CLK_DIV_FREQ/261;  // 도 (약 3831)
    parameter E4 = CLK_DIV_FREQ/329;  // 미 (약 3040)
    parameter G4 = CLK_DIV_FREQ/392;  // 솔 (약 2551)
    
    parameter NOTE_DURATION = CLK_DIV_FREQ/5;  // 200ms
    parameter NOTE_GAP = CLK_DIV_FREQ/20;      // 50ms
    
    // State definition
    parameter IDLE = 2'b00;
    parameter PLAY_C = 2'b01;
    parameter PLAY_E = 2'b10;
    parameter PLAY_G = 2'b11;
    
    // Internal registers
    reg [1:0] state;
    reg [15:0] note_counter;     // 음계 재생 카운터
    reg [19:0] duration_counter; // 음 지속시간 카운터 (1MHz에서 더 큰 비트 폭 필요)
    
    // FSM for note generation
    always @(posedge clk or posedge internal_reset) begin
        if (internal_reset) begin
            state <= IDLE;
            note_counter <= 16'd0;
            duration_counter <= 20'd0;
            piezo_out <= 1'b0;
        end
        else if (piezo_clk) begin  // 1MHz 클럭에서만 동작
            case (state)
                IDLE: begin
                    if (trigger) begin
                        state <= PLAY_C;
                        note_counter <= 16'd0;
                        duration_counter <= 20'd0;
                    end
                    piezo_out <= 1'b0;
                end
                
                PLAY_C: begin
                    if (duration_counter >= NOTE_DURATION) begin
                        state <= PLAY_E;
                        note_counter <= 16'd0;
                        duration_counter <= 20'd0;
                        piezo_out <= 1'b0;
                    end
                    else begin
                        duration_counter <= duration_counter + 1'b1;
                        if (note_counter >= C4) begin
                            note_counter <= 16'd0;
                            piezo_out <= ~piezo_out;
                        end
                        else
                            note_counter <= note_counter + 1'b1;
                    end
                end
                
                PLAY_E: begin
                    if (duration_counter >= NOTE_DURATION) begin
                        state <= PLAY_G;
                        note_counter <= 16'd0;
                        duration_counter <= 20'd0;
                        piezo_out <= 1'b0;
                    end
                    else begin
                        duration_counter <= duration_counter + 1'b1;
                        if (note_counter >= E4) begin
                            note_counter <= 16'd0;
                            piezo_out <= ~piezo_out;
                        end
                        else
                            note_counter <= note_counter + 1'b1;
                    end
                end
                
                PLAY_G: begin
                    if (duration_counter >= NOTE_DURATION) begin
                        state <= IDLE;
                        note_counter <= 16'd0;
                        duration_counter <= 20'd0;
                        piezo_out <= 1'b0;
                    end
                    else begin
                        duration_counter <= duration_counter + 1'b1;
                        if (note_counter >= G4) begin
                            note_counter <= 16'd0;
                            piezo_out <= ~piezo_out;
                        end
                        else
                            note_counter <= note_counter + 1'b1;
                    end
                end
                
                default: state <= IDLE;
            endcase
        end
    end
    
endmodule
