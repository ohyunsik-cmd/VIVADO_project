`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/25 04:27:42
// Design Name: 
// Module Name: elevator_system
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


module elevator_system(
   input wire clk,              
   input wire [7:0] dip_sw,     // dip_sw[7]: reset, dip_sw[6:0]: ??? ??
   input wire [6:0] floor_btn,  // ???? ?? ???? ???
   input wire call_btn,         // ??? ???
   input wire start_btn1,       // EV1 ??? ???
   input wire start_btn2,       // EV2 ??? ???
   input wire emergency_btn1,   // EV1 ??? ???
   input wire emergency_btn2,   // EV2 ??? ???
   output wire [7:0] seg_data,  // 7-segment data (A-G,DP)
   output wire [7:0] seg_sel,   // 7-segment select (S0-S7)
   output wire [3:0] rgb_r,     // RGB LED Red
   output wire [3:0] rgb_g,     // RGB LED Green
   output wire [3:0] rgb_b,     // RGB LED Blue
   output wire [1:0] door_led,  // ?? ???? LED
   output wire lcd_rs,          
   output wire lcd_rw,          
   output wire lcd_en,          
   output wire [7:0] lcd_data,  
   output wire piezo_out        
);

   // Parameters
   parameter FLOOR_COUNT = 7;
   parameter WAIT_TIME = 4;     // 4?? ???
   parameter MOVE_TIME = 2;     // 2?? ???/???
   parameter DOOR_TIME = 2;     // ?? ???? 2??

   // State definitions
   parameter IDLE          = 4'b0000;
   parameter MOVING        = 4'b0001;
   parameter DOOR_OPEN     = 4'b0010;
   parameter WAITING_INPUT = 4'b0011;  
   parameter CLOSING       = 4'b0100;
   parameter EMERGENCY     = 4'b0101;
   parameter RESET        = 4'b0110;

 function should_use_ev1;
    input [6:0] call_floor;
    input [2:0] current_floor_ev1;
    input [2:0] current_floor_ev2;
    reg [2:0] target_floor;
    reg [3:0] time_ev1, time_ev2;
    reg [2:0] dist_ev1, dist_ev2;
    begin
        target_floor = get_target_floor(call_floor);
        
        // 각 엘리베이터와의 거리 계산
        if (current_floor_ev1 > target_floor)
            dist_ev1 = current_floor_ev1 - target_floor;
        else
            dist_ev1 = target_floor - current_floor_ev1;
            
        if (current_floor_ev2 > target_floor)
            dist_ev2 = current_floor_ev2 - target_floor;
        else
            dist_ev2 = target_floor - current_floor_ev2;

        // EV1 도착 예상 시간 계산
        time_ev1 = (current_state_ev1 == IDLE) ? 0 :                     // 정지 상태
                   (current_state_ev1 == WAITING_INPUT) ? WAIT_TIME :     // 문 열림 상태
                   (current_state_ev1 == MOVING || current_state_ev1 == DOOR_OPEN) ?   // 이동 중
                   ((current_floor_ev1 > target_floor ? 
                     (current_floor_ev1 - target_floor) : 
                     (target_floor - current_floor_ev1)) * MOVE_TIME + MOVE_TIME + WAIT_TIME) : 0;

        // EV2 도착 예상 시간 계산
        time_ev2 = (current_state_ev2 == IDLE) ? 0 :                     // 정지 상태
                   (current_state_ev2 == WAITING_INPUT) ? WAIT_TIME :     // 문 열림 상태
                   (current_state_ev2 == MOVING || current_state_ev2 == DOOR_OPEN) ?   // 이동 중
                   ((current_floor_ev2 > target_floor ? 
                     (current_floor_ev2 - target_floor) : 
                     (target_floor - current_floor_ev2)) * MOVE_TIME + MOVE_TIME + WAIT_TIME) : 0;

        // 엘리베이터 선택 로직
        if (current_state_ev2 == EMERGENCY || current_state_ev2 == RESET)
            should_use_ev1 = 1'b1;  // EV2가 비상상태면 EV1 사용
        else if (current_state_ev1 == EMERGENCY || current_state_ev1 == RESET)
            should_use_ev1 = 1'b0;  // EV1이 비상상태면 EV2 사용
        else if (current_state_ev1 == IDLE && current_state_ev2 == IDLE) begin
            // 두 엘리베이터 모두 정지 상태일 때
            if (dist_ev1 == dist_ev2)
                should_use_ev1 = 1'b1;  // 거리가 같으면 EV1 선택
            else
                should_use_ev1 = (dist_ev1 < dist_ev2);  // 가까운 엘리베이터 선택
        end
        else if (current_state_ev1 == IDLE && current_state_ev2 != IDLE)
            should_use_ev1 = 1'b1;  // EV1만 정지상태면 EV1 사용
        else if (current_state_ev2 == IDLE && current_state_ev1 != IDLE)
            should_use_ev1 = 1'b0;  // EV2만 정지상태면 EV2 사용
        else begin
            // 두 엘리베이터 모두 이동 중일 때 도착 예상 시간 비교
            should_use_ev1 = (time_ev1 <= time_ev2);
        end
    end
endfunction

    // get_target_floor 함수 수정
    function [2:0] get_target_floor;
        input [6:0] btn;
        reg [2:0] floor;
        begin
            floor = 3'd1;  // 기본값
            if (btn[0]) floor = 3'd1;
            else if (btn[1]) floor = 3'd2;
            else if (btn[2]) floor = 3'd3;
            else if (btn[3]) floor = 3'd4;
            else if (btn[4]) floor = 3'd5;
            else if (btn[5]) floor = 3'd6;
            else if (btn[6]) floor = 3'd7;
            get_target_floor = floor;
        end
    endfunction

   // Internal signals
   wire internal_reset;
   assign internal_reset = dip_sw[7];

   // Clock divider and timer signals
   reg [31:0] clk_div;
   wire second_tick;
   reg [31:0] timer_counter_ev1;
   reg [31:0] timer_counter_ev2;
   reg set_timer_ev1;
   reg set_timer_ev2;
   reg [31:0] timer_value_ev1;
   reg [31:0] timer_value_ev2;

   // Debounced signals
   wire call_btn_debounced;
   wire [6:0] floor_btn_debounced;
   wire start_btn1_debounced, start_btn2_debounced;
   wire emergency_btn1_debounced, emergency_btn2_debounced;

   // One shot trigger signals
   wire call_trigger;
   wire [6:0] floor_trigger;
   wire start_trigger1, start_trigger2;
   wire emergency_trigger1, emergency_trigger2;

   // State and control signals for EV1
   reg [3:0] current_state_ev1, next_state_ev1;
   reg [2:0] current_floor_ev1;
   reg [2:0] target_floor_ev1;
   reg [2:0] selected_floor_ev1;
   reg door_open_ev1;
   reg moving_up_ev1;
   reg emergency_ev1;
   reg floor_selected_ev1;

   // State and control signals for EV2
   reg [3:0] current_state_ev2, next_state_ev2;
   reg [2:0] current_floor_ev2;
   reg [2:0] target_floor_ev2;
   reg [2:0] selected_floor_ev2;
   reg door_open_ev2;
   reg moving_up_ev2;
   reg emergency_ev2;
   reg floor_selected_ev2;
   wire [2:0] target_floor_display_ev1;
   wire [2:0] target_floor_display_ev2;

   assign target_floor_display_ev1 = target_floor_ev1;
   assign target_floor_display_ev2 = target_floor_ev2;
   
   
// Clock divider and second tick generation
  always @(posedge clk or posedge internal_reset) begin
    if (internal_reset)
        clk_div <= 32'd0;
    else begin
        if (clk_div >= 32'd49_999_999)  // 50MHz 기준, 1초
            clk_div <= 32'd0;
        else
            clk_div <= clk_div + 1;
    end
end

assign second_tick = (clk_div == 32'd49_999_999);  // 정확한 1초 틱 생성

   // Timer counter control
   always @(posedge clk or posedge internal_reset) begin
       if (internal_reset) begin
           timer_counter_ev1 <= 32'd0;
           timer_counter_ev2 <= 32'd0;
       end
       else begin
           // EV1 ???? ???????
           if (set_timer_ev1)
               timer_counter_ev1 <= timer_value_ev1;
           else if (second_tick && timer_counter_ev1 > 0)
               timer_counter_ev1 <= timer_counter_ev1 - 1;

           // EV2 ???? ???????
           if (set_timer_ev2)
               timer_counter_ev2 <= timer_value_ev2;
           else if (second_tick && timer_counter_ev2 > 0)
               timer_counter_ev2 <= timer_counter_ev2 - 1;
       end
   end

   // Arrival signal for buzzer
   wire arrival_trigger;
   assign arrival_trigger = 
       ((current_state_ev1 == MOVING && current_floor_ev1 == target_floor_ev1) ||
        (current_state_ev2 == MOVING && current_floor_ev2 == target_floor_ev2));

   // Debouncer instances
   debouncer call_deb(
       .clk(clk),
       .internal_reset(internal_reset),
       .button_in(call_btn),
       .button_out(call_btn_debounced)
   );

   // Start buttons
   debouncer start_deb1(
       .clk(clk),
       .internal_reset(internal_reset),
       .button_in(start_btn1),
       .button_out(start_btn1_debounced)
   );

   debouncer start_deb2(
       .clk(clk),
       .internal_reset(internal_reset),
       .button_in(start_btn2),
       .button_out(start_btn2_debounced)
   );

   // Emergency buttons
   debouncer emergency_deb1(
       .clk(clk),
       .internal_reset(internal_reset),
       .button_in(emergency_btn1),
       .button_out(emergency_btn1_debounced)
   );

   debouncer emergency_deb2(
       .clk(clk),
       .internal_reset(internal_reset),
       .button_in(emergency_btn2),
       .button_out(emergency_btn2_debounced)
   );

   // Floor buttons
   generate
       for (genvar i = 0; i < 7; i = i + 1) begin : floor_debounce
           debouncer floor_deb(
               .clk(clk),
               .internal_reset(internal_reset),
               .button_in(floor_btn[i]),
               .button_out(floor_btn_debounced[i])
           );
       end
   endgenerate

   // One shot instances
   one_shot call_os(
       .clk(clk),
       .internal_reset(internal_reset),
       .signal(call_btn_debounced),
       .tick(call_trigger)
   );

   one_shot start_os1(
       .clk(clk),
       .internal_reset(internal_reset),
       .signal(start_btn1_debounced),
       .tick(start_trigger1)
   );

   one_shot start_os2(
       .clk(clk),
       .internal_reset(internal_reset),
       .signal(start_btn2_debounced),
       .tick(start_trigger2)
   );

   one_shot emergency_os1(
       .clk(clk),
       .internal_reset(internal_reset),
       .signal(emergency_btn1_debounced),
       .tick(emergency_trigger1)
   );

   one_shot emergency_os2(
       .clk(clk),
       .internal_reset(internal_reset),
       .signal(emergency_btn2_debounced),
       .tick(emergency_trigger2)
   );

   // Floor button one shots
   generate
       for (genvar i = 0; i < 7; i = i + 1) begin : floor_oneshot
           one_shot floor_os(
               .clk(clk),
               .internal_reset(internal_reset),
               .signal(floor_btn_debounced[i]),
               .tick(floor_trigger[i])
           );
       end
   endgenerate
// EV1 State Machine
   always @(posedge clk or posedge dip_sw[7]) begin
       if (dip_sw[7]) begin
           current_state_ev1 <= IDLE;
           current_floor_ev1 <= 3'd1;
           door_open_ev1 <= 1'b0;
           moving_up_ev1 <= 1'b0;
           emergency_ev1 <= 1'b0;
           target_floor_ev1 <= 3'd1;
           next_state_ev1 <= IDLE;
           selected_floor_ev1 <= 3'd0;
           floor_selected_ev1 <= 1'b0;
           set_timer_ev1 <= 1'b0;
           timer_value_ev1 <= 32'd0;
       end
       else begin
           set_timer_ev1 <= 1'b0;
           
           case (current_state_ev1)
              IDLE: begin
    door_open_ev1 <= 1'b0;  // IDLE 상태에서는 항상 LED OFF
    floor_selected_ev1 <= 1'b0;
    
    if (call_trigger && !emergency_ev1) begin
        if (should_use_ev1(dip_sw[6:0], current_floor_ev1, current_floor_ev2)) begin
            target_floor_ev1 <= get_target_floor(dip_sw[6:0]);
            if (current_floor_ev1 != get_target_floor(dip_sw[6:0])) begin
                next_state_ev1 <= MOVING;
                moving_up_ev1 <= (get_target_floor(dip_sw[6:0]) > current_floor_ev1);
                set_timer_ev1 <= 1'b1;
                timer_value_ev1 <= MOVE_TIME;
            end
            else begin  // 같은 층 호출
                next_state_ev1 <= WAITING_INPUT;
                door_open_ev1 <= 1'b1;  // 같은 층 호출 시에만 LED ON
                set_timer_ev1 <= 1'b1;
                timer_value_ev1 <= WAIT_TIME;
            end
        end
    end
end

 MOVING: begin
    if (emergency_trigger1) begin
        next_state_ev1 <= EMERGENCY;
        emergency_ev1 <= 1'b1;
    end
    else if (current_floor_ev1 == target_floor_ev1) begin
        next_state_ev1 <= DOOR_OPEN;
        set_timer_ev1 <= 1'b1;
        timer_value_ev1 <= MOVE_TIME;  // 도착 후 2초 대기
    end
    else if (second_tick && timer_counter_ev1 == 0) begin
        if (moving_up_ev1 && current_floor_ev1 < FLOOR_COUNT) begin
            current_floor_ev1 <= current_floor_ev1 + 1;
        end
        else if (!moving_up_ev1 && current_floor_ev1 > 1) begin
            current_floor_ev1 <= current_floor_ev1 - 1;
        end
        set_timer_ev1 <= 1'b1;
        timer_value_ev1 <= MOVE_TIME;
        next_state_ev1 <= MOVING;
    end
end

// DOOR_OPEN 상태 수정
DOOR_OPEN: begin
    if (timer_counter_ev1 == 0) begin  // 2초 대기 완료
        door_open_ev1 <= 1'b1;  // LED ON
        next_state_ev1 <= WAITING_INPUT;
        set_timer_ev1 <= 1'b1;
        timer_value_ev1 <= WAIT_TIME;  // 4초 대기
        floor_selected_ev1 <= 1'b0;    // 층 선택 상태 초기화
    end
end

WAITING_INPUT: begin
    if (|floor_trigger) begin
        selected_floor_ev1 <= get_target_floor(floor_trigger);
        floor_selected_ev1 <= 1'b1;
    end
    
    if (start_trigger1 && floor_selected_ev1) begin
        next_state_ev1 <= CLOSING;  // MOVING이 아닌 CLOSING으로 변경
        door_open_ev1 <= 1'b0;  // LED OFF
        target_floor_ev1 <= selected_floor_ev1;
        set_timer_ev1 <= 1'b1;
        timer_value_ev1 <= DOOR_TIME;  // 문 닫히는 시간 2초
    end
    else if (timer_counter_ev1 == 0) begin  // 4초 대기 완료
        door_open_ev1 <= 1'b0;  // LED OFF
        if (floor_selected_ev1) begin
            next_state_ev1 <= CLOSING;  // MOVING이 아닌 CLOSING으로 변경
            target_floor_ev1 <= selected_floor_ev1;
            set_timer_ev1 <= 1'b1;
            timer_value_ev1 <= DOOR_TIME;  // 문 닫히는 시간 2초
        end
        else begin
            next_state_ev1 <= IDLE;
        end
    end
end

// CLOSING 상태 수정
CLOSING: begin
    if (timer_counter_ev1 == 0) begin  // 2초 대기 완료
        next_state_ev1 <= MOVING;
        moving_up_ev1 <= (selected_floor_ev1 > current_floor_ev1);
        target_floor_ev1 <= selected_floor_ev1;
        set_timer_ev1 <= 1'b1;
        timer_value_ev1 <= MOVE_TIME;
    end
end


               EMERGENCY: begin
                   if (emergency_trigger1) begin
                       next_state_ev1 <= RESET;
                   end
               end

               RESET: begin
                   current_floor_ev1 <= 3'd1;
                   door_open_ev1 <= 1'b0;
                   moving_up_ev1 <= 1'b0;
                   emergency_ev1 <= 1'b0;
                   target_floor_ev1 <= 3'd1;
                   selected_floor_ev1 <= 3'd0;
                   floor_selected_ev1 <= 1'b0;
                   next_state_ev1 <= IDLE;
               end

               default: next_state_ev1 <= IDLE;
           endcase

           current_state_ev1 <= next_state_ev1;
       end
   end

   // EV2 State Machine (EV1?? ?????? ????)
   always @(posedge clk or posedge dip_sw[7]) begin
       if (dip_sw[7]) begin
           current_state_ev2 <= IDLE;
           current_floor_ev2 <= 3'd1;
           door_open_ev2 <= 1'b0;
           moving_up_ev2 <= 1'b0;
           emergency_ev2 <= 1'b0;
           target_floor_ev2 <= 3'd1;
           next_state_ev2 <= IDLE;
           selected_floor_ev2 <= 3'd0;
           floor_selected_ev2 <= 1'b0;
           set_timer_ev2 <= 1'b0;
           timer_value_ev2 <= 32'd0;
       end
       else begin
           set_timer_ev2 <= 1'b0;
           
           case (current_state_ev2)
              IDLE: begin
    door_open_ev2 <= 1'b0;
    floor_selected_ev2 <= 1'b0;
    if (call_trigger && !emergency_ev2) begin
        if (!should_use_ev1(dip_sw[6:0], current_floor_ev1, current_floor_ev2)) begin
            target_floor_ev2 <= get_target_floor(dip_sw[6:0]);
            if (current_floor_ev2 != get_target_floor(dip_sw[6:0])) begin
                next_state_ev2 <= MOVING;
                moving_up_ev2 <= (get_target_floor(dip_sw[6:0]) > current_floor_ev2);
                set_timer_ev2 <= 1'b1;
                timer_value_ev2 <= MOVE_TIME;
            end
            else begin  // 같은 층 호출
                door_open_ev2 <= 1'b1;  // 즉시 LED ON
                next_state_ev2 <= WAITING_INPUT;
                set_timer_ev2 <= 1'b1;
                timer_value_ev2 <= WAIT_TIME;  // 4초 대기
            end
        end
    end
end

              // EV2 State Machine
 MOVING: begin
    if (emergency_trigger2) begin
        next_state_ev2 <= EMERGENCY;
        emergency_ev2 <= 1'b1;
    end
    else if (current_floor_ev2 == target_floor_ev2) begin
        next_state_ev2 <= DOOR_OPEN;
        set_timer_ev2 <= 1'b1;
        timer_value_ev2 <= MOVE_TIME;  // 도착 후 2초 대기
    end
    else if (second_tick && timer_counter_ev2 == 0) begin
        if (moving_up_ev2 && current_floor_ev2 < FLOOR_COUNT) begin
            current_floor_ev2 <= current_floor_ev2 + 1;
        end
        else if (!moving_up_ev2 && current_floor_ev2 > 1) begin
            current_floor_ev2 <= current_floor_ev2 - 1;
        end
        set_timer_ev2 <= 1'b1;
        timer_value_ev2 <= MOVE_TIME;
        next_state_ev2 <= MOVING;
    end
end

// DOOR_OPEN 상태 수정
DOOR_OPEN: begin
    if (timer_counter_ev2 == 0) begin  // 2초 대기 완료
        door_open_ev2 <= 1'b1;  // LED ON
        next_state_ev2 <= WAITING_INPUT;
        set_timer_ev2 <= 1'b1;
        timer_value_ev2 <= WAIT_TIME;  // 4초 대기
        floor_selected_ev2 <= 1'b0;    // 층 선택 상태 초기화
    end
end

// WAITING_INPUT 상태 수정
WAITING_INPUT: begin
    if (|floor_trigger) begin
        selected_floor_ev2 <= get_target_floor(floor_trigger);
        floor_selected_ev2 <= 1'b1;
    end
    
    if (start_trigger2 && floor_selected_ev2) begin
        next_state_ev2 <= CLOSING;
        door_open_ev2 <= 1'b0;
        set_timer_ev2 <= 1'b1;
        timer_value_ev2 <= MOVE_TIME;
    end
    else if (timer_counter_ev2 == 0) begin
        door_open_ev2 <= 1'b0;
        if (floor_selected_ev2) begin
            next_state_ev2 <= CLOSING;
            set_timer_ev2 <= 1'b1;
            timer_value_ev2 <= MOVE_TIME;
        end
        else begin
            next_state_ev2 <= IDLE;
        end
    end
end

// CLOSING 상태 수정
CLOSING: begin
    if (timer_counter_ev2 == 0) begin
        next_state_ev2 <= MOVING;
        moving_up_ev2 <= (selected_floor_ev2 > current_floor_ev2);
        target_floor_ev2 <= selected_floor_ev2;
        set_timer_ev2 <= 1'b1;
        timer_value_ev2 <= MOVE_TIME;
    end
end


               EMERGENCY: begin
                   if (emergency_trigger2) begin
                       next_state_ev2 <= RESET;
                   end
               end

               RESET: begin
                   current_floor_ev2 <= 3'd1;
                   door_open_ev2 <= 1'b0;
                   moving_up_ev2 <= 1'b0;
                   emergency_ev2 <= 1'b0;
                   target_floor_ev2 <= 3'd1;
                   selected_floor_ev2 <= 3'd0;
                   floor_selected_ev2 <= 1'b0;
                   next_state_ev2 <= IDLE;
               end

               default: next_state_ev2 <= IDLE;
           endcase

           current_state_ev2 <= next_state_ev2;
       end
   end

   // Controller instances
   buzzer_control buzzer(
       .clk(clk),
       .internal_reset(internal_reset),
       .trigger(arrival_trigger),
       .emergency_ev1(emergency_ev1),
       .emergency_ev2(emergency_ev2),
       .piezo_out(piezo_out)
   );

   lcd_controller lcd_ctrl(
       .clk(clk),
       .internal_reset(internal_reset),
       .emergency_ev1(emergency_ev1),
       .emergency_ev2(emergency_ev2),
       .lcd_rs(lcd_rs),
       .lcd_rw(lcd_rw),
       .lcd_en(lcd_en),
       .lcd_data(lcd_data)
   );

   seven_segment_ctrl seg_ctrl(
       .clk(clk),
       .internal_reset(internal_reset),
       .floor_ev1(current_floor_ev1),
       .floor_ev2(current_floor_ev2),
       .target_floor_ev1(target_floor_display_ev1),    // 추가
       .target_floor_ev2(target_floor_display_ev2),    // 추가
       .direction_ev1(moving_up_ev1),
       .direction_ev2(moving_up_ev2),
       .timer_counter_ev1(timer_counter_ev1),
       .timer_counter_ev2(timer_counter_ev2),
       .seg_data(seg_data),
       .seg_sel(seg_sel)
   );

   emergency_led_ctrl led_ctrl(
       .clk(clk),
       .internal_reset(internal_reset),
       .emergency_ev1(emergency_ev1),
       .emergency_ev2(emergency_ev2),
       .rgb_r(rgb_r),
       .rgb_g(rgb_g),
       .rgb_b(rgb_b)
   );

   // Door LED control
   assign door_led = {door_open_ev2, door_open_ev1};

endmodule


