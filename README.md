This project contain simple Viavdo exercise and elevator project with COMBO II DLD.
ELEVATOR project is on folder real_real_final_project.
![image](https://github.com/user-attachments/assets/315ce1ce-6d7d-4be3-80eb-459720e4df6f)
![image](https://github.com/user-attachments/assets/24fb2d45-678c-486a-86ba-d772058ae34a)
![image](https://github.com/user-attachments/assets/951daade-a9d9-4706-b7f6-ab927e474e15)
![image](https://github.com/user-attachments/assets/c466ea67-f85e-4b93-9c64-858bbcec7214)
![image](https://github.com/user-attachments/assets/c74a5439-50dd-4ed1-a801-e532a36b9dc4)
![image](https://github.com/user-attachments/assets/56bfeadd-9e4e-4eeb-a80b-5bc21d9bb92b)
The image obove shows how the elevator works by COMBO II DLD with this code.


I.개요

        해당 프로젝트에서는 콤보 박스의 LED, 8-array 7segment, LCD, 버튼 스위치, Dip 스위치 등을 사용하여 엘리베이터를 구현하였다.
        엘리베이터의 상태는 IDLE, MOVING, DOOR_OPEN, WAITING, CLOSING, EMERGENCY, RESET 이렇게 7개로 구성된다. 
        위 7개의 state를 통해 여러 엘리베이터의 기능을 구현하였다. 위 기능을 크게 5개로 나누면 엘리베이터 호출, 엘리베이터 이동, 엘리베이터 우선 순위, 긴급정지, 추가 기능이 있다. 
        엘리베이터 호출의 경우 Dip 1~7번 스위치를 통하여 엘리베이터를 호출할 층수를 정하고, 호출 버튼(*)를 누르면 엘리베이터가 호출이 된다. 
        이때 현재 층 수는 8 Array 7-Segment 0, 4(각각 엘리베이터 1, 2)에 표시하며, 8 Array 7-Segment 1, 5(각각 엘리베이터 1, 2)에는 엘리베이터의 이동 방향을, 8 Array 7-Segment 2, 6(각각 엘리베이터 1, 2)에는 한 층 이동 시간인 2초를 계속 카운팅한다. 
        엘리베이터가 호출한 층에 도착하게 되면 Piezo를 통해 알림음이 재생되고, 도착 2초 후 LED 4/8(각각 엘리베이터 1, 2)에 출력이 들어와 엘리베이터 Open을 보여준다.
        엘리베이터 이동의 경우 엘리베이터가 Open 상태에서 button switch로 목표 층을 입력하고 출발 스위치를 누르거나 8 Array 7-Segment 2, 6(각각 엘리베이터 1, 2)으로 4초 카운팅이 끝나면 목표한 층으로 엘리베이터가 문이 닫힌 후 8 Array 7-Segment 2, 6(각각 엘리베이터 1, 2)에서 2초 카운팅 후 이동한다. 
        층간 이동 및 도착의 경우 호출에서의 설명과 동일하게 작동한다. 또한, 엘리베이터가 open일 때 목표 층 없이 4초 카운팅이 진행되어 문이 닫히게 되면 엘리베이터는 이동하지 않고 대기 상태가 되며, 이와 같이 대기 상태에서 호출을 받으면 바로 호출 층수로 이동하며, 같은 층에서 호출한 경우 다시 DOOR_OPEN 상태가 되고 4초 카운팅을 진행한다. 
        엘리베이터가 DOOR_OPEN 상태에서 호출 받게 된다면 문이 닫히기 위한 4초 카운팅과 대기시간 2초 카운팅이 끝나야 엘리베이터가 이동하며 동일한 층에서 호출을 받게 되면 4초 카운팅을 다시 시작한다.
        엘리베이터의 우선순위의 경우 호출 신호 하나 당 엘리베이터는 하나만 호출되며, 둘 다 정지한 경우에는 더 가까운 엘리베이터가 거리가 동일할 때는 엘리베이터 1이 호출되며 엘리베이터가 하나만 이동 중인 경우 움직이지 않은 엘리베이터가 호출되며, 둘 다 이동 중이라면 대기 시간, 이동 시간, 문 open시간 등으로 모두 고려하여 먼저 올 수 있는 엘리베이터가 호출된다.
        긴급 정지의 경우 엘리베이터가 이동 중에 긴급정지가 눌리면 엘리베이터가 정지되고, 3 color LED에 불빛이 들어오고, LCD에는 “EV 1/2 OUT OF SERVICE”가 LINE 1에, “PLEASE USE EV 2/1”가 LINE2에 출력된다. 이때 한 엘리베이터만 긴급정지 시 다른 엘리베이터는 정상적인 작동을 한다.
        추가 기능으로는 8 Array 7-Segment 3, 7(각각 엘리베이터 1, 2)에 엘리베이터가 이동할 층을 표시하고, 긴급 정지가 아닌 모든 상황에서는 LCD 패널에 “ELEVATOR”가 LINE 1에, “WELCOME”이 LINE2에 출력된다.

II. 실험 결과 및 동작사항 

        앞서 말한 동작들을 구현하기 위하여 핀 설정을 아래 그림과 같이 수행하였다. 
![image](https://github.com/user-attachments/assets/5d5f4cfa-6a21-4fd4-ae2f-6f7d31966561)
![image](https://github.com/user-attachments/assets/2ea20bde-4746-4d21-9149-23d0fb392f26)


1. rst 및 clk
   
        rst 버튼은 DIP 8번 스위치에 배정하였고 clk의 경우 main clock에 배정하여 50MHz를 넣어주었다.
![image](https://github.com/user-attachments/assets/8f1b469d-2034-4aa9-b717-a93032d78225)

2. 엘리베이터 호출
 
        DIP 1~7번 스위치를 통하여  
        (1) 엘리베이터 호출

![image](https://github.com/user-attachments/assets/02060528-f8e6-48cd-b39a-fd3528c26a0e)
![image](https://github.com/user-attachments/assets/8846e526-71e2-4180-b82c-0f51b3c9633b)

        Dip 스위치를 입력하여 엘리베이터가 호출되는 것을 위 표를 통해 정리하였다.  
        Dip 스위치에서 설정한 층수에 따라 엘리베이터가 이동하는 것을 위 사진을 통해 확인할 
        수 있다.

        (2) 이동 카운팅 및 LED 

![image](https://github.com/user-attachments/assets/b17e7461-09c5-41d1-83d0-e15f15b37ecc)

        위 출력 결과 사진을 위 표를 통해 정리하였다. 
        한 층 이동할 때마다 진행되는 카운팅을 위 표를 통해서 확인할 수 있고 문이 열리면 
        LED 4 / 8(엘리베이터 1/2)가 출력되는 걸 위 표를 통해 확인할 수 있다. 엘리베이터 이동 
        방향을 다르게 설정하여 실험해서 이동방향 U와 이동방향 d가 출력되는 것을 위 표를 통
        해 확인할 수 있다.

3. 엘리베이터 이동

   1) 엘리베이터 이동

      ![image](https://github.com/user-attachments/assets/a4d19c0f-d6d9-45d6-941b-813504a56c68)

      버튼 스위치로 배정한 층수에 따라 엘리베이터가 이동한 결과를 위 표를 통하여 정리하였다. 각 층에 이동하는 엘리베이터를 실험하였고 이를 위 표를 통해 확인할 수 있다. 

   2) DOOR_OPEN

      ![image](https://github.com/user-attachments/assets/6dd415eb-14ca-40dd-a913-3fe84718a7a4)

      문이 열리고 4초 카운팅 되는 것을 위 표를 통해 확인할 수 있으며, 문이 열렸을 때 LED에 출력이 들어오는 것을 확인 가능하다. 문이 닫히고 2초 후에 출발하는 것 또한 위 표의 사진을 통해 확인할 수 있다.

4. 엘리베이터 우선 순위

   ![image](https://github.com/user-attachments/assets/ae1ba16b-8e34-4c6b-8716-51a6908cd1d2)

   위에 상황에 따라 결과를 표를 정리하였다. 사진만으로는 기능을 정확히 확인하기에는 어렵지만, 첫 번째 상황의 경우 엘리베이터 1이 이동 중이기 때문에 4층에서의 호출이 들어오자 엘리베이터 2가 호출되는 것을 확인할 수 있었다. 두 번째 상황의 경우 엘리베이터가 모두 1층에 있고 6층에서 호출하였을 때 엘리베이터 1이 호출되는 상황을 확인할 수 있었다. 마지막 상황의 경우 엘리베이터 1이 4층에 엘리베이터 2가 2층에 있고, 1층에서 호출이 들어오면 엘리베이터가 2가 움직이는 것을 확인할 수 있었다.

5. 긴급 정지

      ![image](https://github.com/user-attachments/assets/52fa74d9-8fe8-4bea-b97e-88b7d6e7f750)

   위 결과 표를 통해 긴급정지 버튼을 누르면 LCD에는 “EV 1/2 OUT OF SERVICE”가 LINE 1에, “PLEASE USE EV 2/1”가 LINE2에 출력이 되는 것을 확인할 수 있다. 또한, 사진으로는 확인하기 힘들지만 LCD에 출력된 문자는 전광판처럼 왼쪽으로 이동되는 것을 확인할 수 있었다.



6. 추가 기능

   ![image](https://github.com/user-attachments/assets/192b8e9e-e7df-4fac-a210-72d37ef85133)

   엘리베이터가 긴급 정지 상황이 아니라면 상황에서는 LCD 패널에 “ELEVATOR”가 LINE 1에, “WELCOME”이 LINE2에 출력되는 것을 위 표를 통하여 확인할 수 있다. 또한, 8 Array 7Segment 3, 7(각각 엘리베이터 1, 2)에 엘리베이터가 이동할 층을 출력하는 것을 확인할 수 있다.

   
III. 
코드 분석 
1. 메인 모듈(elevator_system) 
(1) 거리 계산  
o 현재 층과 목표 층 사이의 절대 거리 계산 
o 삼항 연산자를 사용해 방향에 상관없이 거리 계산 
8 
(2) 도착 예상 시간 계산  
IDLE 상태: 0 초 
A. 엘리베이터의 현재 상태에 따라 예상 시간 다르게 계산 
B. 
C. WAITING_INPUT 상태: 대기 시간 
D. MOVING/DOOR_OPEN 상태: 거리 * 이동 시간 + 추가 시간 
(3) 엘리베이터 선택 우선순위  
A. 비상 상태 엘리베이터 제외 
B. 
대기 중인 엘리베이터 우선 
C. 목표 층에 더 가까운 엘리베이터 선택 
2. 서브 모듈(seven_segment_ctrl) 
(1) 입력: 
 clk: 시스템 클록 
 internal_reset: 내부 리셋 신호 
 floor_ev1, floor_ev2: 각 엘리베이터의 현재 층 
 target_floor_ev1, target_floor_ev2: 각 엘리베이터의 목표 층 
 direction_ev1, direction_ev2: 각 엘리베이터의 이동 방향 (상/하) 
 timer_counter_ev1, timer_counter_ev2: 각 엘리베이터의 타이머 카운터 
(2) 출력: 
 seg_data: 7-세그먼트 데이터 (세그먼트 패턴) 
 seg_sel: 자리 선택 신호 (어떤 7-세그먼트를 활성화할지 결정) 
(3) 주요 기능 
1. 디스플레이 멀티플렉싱:  
o 8개의 7-세그먼트 디스플레이를 순차적으로 스캔 
o 각 디스플레이에 다른 정보 표시  
 EV1 현재 층 
 EV1 이동 방향 
 EV1 타이머 
 EV1 목표 층 
 EV2 현재 층 
9 
 EV2 이동 방향 
 EV2 타이머 
 EV2 목표 층 
2. 숫자 패턴 정의:  
o num_patterns 배열에 0-9 숫자의 7-세그먼트 패턴 저장 
o 특수 패턴: 'U'(위), 'd'(아래), OFF 상태 
3. 타이머 디지트 변환:  
o get_timer_digit 함수로 타이머 값을 0-9 범위로 변환 
4. 스캔 카운터:  
o 디스플레이 스캔 주파수 조절 (480Hz) 
o 8개의 디스플레이를 순환하며 각각 다른 정보 표시 
(4) 특이사항 
 액티브 로우(Active Low) 방식의 디스플레이 제어 
 50MHz 클록 사용 
 내부 리셋 지원 
 타이머가 10 이상이면 9로 고정 
3. 서브 모듈(buzz_control) 
상태를 입력 받아 엘리베이터 층 도착 시 C-E-G 순서의 음계를 재생하는 서브 모듈을 
추가하였다. 
(1) 모듈 입출력 신호 
module buzzer_control( 
input wire clk,               
input wire internal_reset,    
input wire trigger,           
input wire emergency_ev1,     
input wire emergency_ev2,     
output reg piezo_out          
); 
// 50MHz 메인 클록 
// 내부 리셋 신호 
// 층 도착 트리거 
// 비상 신호 1 (사용되지 않음) 
// 비상 신호 2 (사용되지 않음) 
// 피에조 부저 출력 
10 
(2) 클록 분주기 (Clock Divider) 
reg [5:0] clk_div;  // 6 비트 카운터 (0~49) 
wire piezo_clk; 
always @(posedge clk or posedge internal_reset) begin 
if (internal_reset) 
clk_div <= 6'd0; 
else if (clk_div >= 6'd49)  // 50 분주 
clk_div <= 6'd0; 
else  
end 
clk_div <= clk_div + 1'b1; 
assign piezo_clk = (clk_div == 6'd0);  // 1MHz 클럭 생성 
 50MHz 입력 클록을 1MHz로 분주합니다. 
 clk_div 가 0부터 49까지 카운트하여 클록을 분주합니다. 
 piezo_clk 는 clk_div 가 0일 때 1이 되어 1MHz 클록을 생성합니다. 
(3) 음계 및 지속 시간 파라미터 
parameter CLK_DIV_FREQ = 1_000_000;  // 1MHz 
parameter C4 = CLK_DIV_FREQ/261;  // 도 음계 (약 3831) 
parameter E4 = CLK_DIV_FREQ/329;  // 미 음계 (약 3040) 
parameter G4 = CLK_DIV_FREQ/392;  // 솔 음계 (약 2551) 
11 
parameter NOTE_DURATION = CLK_DIV_FREQ/5;  // 200ms 음 지속 시간 
parameter NOTE_GAP = CLK_DIV_FREQ/20;      
// 50ms 음 간격 
 C4, E4, G4 음계를 1MHz 클록 기준으로 계산했습니다. 
 NOTE_DURATION은 각 음의 지속 시간을 200ms로 설정했습니다. 
(4) 상태 머신 (FSM) 정의 
parameter IDLE = 2'b00; 
parameter PLAY_C = 2'b01; 
parameter PLAY_E = 2'b10; 
parameter PLAY_G = 2'b11; 
reg [1:0] state; 
reg [15:0] note_counter;     
// 음계 재생 카운터 
reg [19:0] duration_counter; // 음 지속시간 카운터 
 4개의 상태(IDLE, PLAY_C, PLAY_E, PLAY_G)로 구성된 유한 상태 머신입니다. 
 note_counter 와 duration_counter 로 음계와 지속 시간을 제어합니다. 
(5) 주요 상태 머신 로직 
1. trigger 신호가 활성화되면 IDLE 상태에서 PLAY_C 상태로 전환됩니다. 
2. 각 음(C, E, G)은 200ms 동안 재생됩니다. 
3. 음 재생 시 piezo_out을 토글하여 사운드를 생성합니다. 
4. 모든 음 재생 후 IDLE 상태로 복귀합니다. 
4. 서브 모듈(one_shot) 
버튼을 물리적으로 누를 때 신호가 중복해서 들어가는 것을 방지하기 위해 버튼을 이용한 
기능에는 one_shot 모듈을 추가하였다. 
module one_shot( 
12 
13 
 
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
 
5. 서브 모듈(debouncer) 
버튼을 물리적으로 누르거나 놓을 때 발생하는 급격하고 의도하지 않은 상태 변화를 효과적으로 
필터링하여 깨끗하고 단일한 상태 전환을 하기 위하여 버튼을 이용한 기능에는 위 debouncer 
모듈을 추가하였다. 
module debouncer( 
    input wire clk, 
    input wire internal_reset, 
    input wire button_in, 
    output reg button_out 
14 
 
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
15 
 
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
(1) 모듈 포트: 
 clk: 클럭 입력 (이 경우 50 MHz) 
 internal_reset: 액티브-하이 리셋 신호 
 button_in: 물리적 버튼의 원시 입력 
 button_out: 디바운스된 버튼 출력 
(2) 디바운싱 메커니즘: 
1. 동기화 단계  
o 두 개의 플립-플롭(button_ff1과 button_ff2)이 비동기 버튼 입력을 클럭과 동기화 
o 이는 메타스테이빌리티 문제를 방지하고 안정된 입력 신호를 생성 
2. 디바운스 카운터  
o 20비트 카운터가 잠재적인 버튼 상태 변화 지속 시간을 추적 
o DEBOUNCE_TIME은 250,000 클럭 사이클로 설정 (50 MHz에서 5ms) 
o 버튼이 5ms 동안 안정된 상태를 유지해야 상태 변화로 인정 
(3) 상세 동작: 
 버튼 상태가 변경되면(button_ff2 != button_out) 카운터가 증가 
 버튼 상태가 전체 디바운스 기간(250,000 사이클) 동안 안정되면 출력 업데이트 
 디바운스 기간 완료 전에 버튼 상태가 다시 변경되면 카운터 재설정 
 이는 기계적 바운싱으로 인한 빠른, 의도하지 않은 상태 변화를 방지 
(4) 핵심 설계 특징: 
 동기식 리셋 사용 
 강력한 2단계 동기화 구현 
 깨끗하고 안정된 버튼 출력 제공 
 DEBOUNCE_TIME 매개변수를 통해 디바운스 시간 구성 가능
