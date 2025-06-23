module lcd_controller(
    input wire clk,
    input wire internal_reset,
    input wire emergency_ev1,
    input wire emergency_ev2,
    output reg lcd_rs,
    output reg lcd_rw,
    output lcd_en,    
    output reg [7:0] lcd_data
);
    // State parameters
    parameter DELAY       = 3'b000;
    parameter FUNCTION_SET = 3'b001;
    parameter ENTRY_MODE  = 3'b010;
    parameter DISP_ONOFF  = 3'b011;
    parameter LINE1       = 3'b100;
    parameter LINE2       = 3'b101;
    parameter DISP_SHIFT  = 3'b110;
    parameter DELAY_T     = 3'b111;

    reg [2:0] state;
    integer cnt;

    // Clock divider for LCD Enable
    integer clk_count;
    reg enable_clk;
    
    always @(posedge clk or posedge internal_reset) begin
        if(internal_reset) begin
            clk_count <= 0;
            enable_clk <= 1'b0;
        end
        else if(clk_count >= 3999999) begin  // 1000Hz
            clk_count <= 0;
            enable_clk <= ~enable_clk;
        end
        else
            clk_count <= clk_count + 1;
    end

    // State control
    always @(posedge enable_clk or posedge internal_reset) begin
        if(internal_reset)
            state <= DELAY;
        else begin
            case(state)
                DELAY: 
                    if(cnt >= 7) state <= FUNCTION_SET;
                FUNCTION_SET:
                    if(cnt >= 3) state <= DISP_ONOFF;
                DISP_ONOFF:
                    if(cnt >= 3) state <= ENTRY_MODE;
                ENTRY_MODE:
                    if(cnt >= 3) state <= LINE1;
                LINE1:
                    if(cnt >= 18) state <= LINE2;
                LINE2:
                    if(cnt >= 18) state <= DISP_SHIFT;
                DISP_SHIFT:
                    if(cnt >= 10) state <= DELAY_T;
                DELAY_T:
                    if(cnt >= 5) state <= LINE1;
                default: state <= DELAY;
            endcase
        end
    end

    // Counter control
    always @(posedge enable_clk or posedge internal_reset) begin
        if(internal_reset)
            cnt <= 0;
        else begin
            case(state)
                DELAY: 
                    if(cnt >= 7) cnt <= 0;
                    else cnt <= cnt + 1;
                FUNCTION_SET:
                    if(cnt >= 3) cnt <= 0;
                    else cnt <= cnt + 1;
                DISP_ONOFF:
                    if(cnt >= 3) cnt <= 0;
                    else cnt <= cnt + 1;
                ENTRY_MODE:
                    if(cnt >= 3) cnt <= 0;
                    else cnt <= cnt + 1;
                LINE1:
                    if(cnt >= 18) cnt <= 0;
                    else cnt <= cnt + 1;
                LINE2:
                    if(cnt >= 18) cnt <= 0;
                    else cnt <= cnt + 1;
                DISP_SHIFT:
                    if(cnt >= 10) cnt <= 0;
                    else cnt <= cnt + 1;
                DELAY_T:
                    if(cnt >= 5) cnt <= 0;
                    else cnt <= cnt + 1;
                default: cnt <= 0;
            endcase
        end
    end

    // LCD control and data
    always @(posedge enable_clk or posedge internal_reset) begin
        if(internal_reset) begin
            lcd_rs <= 1'b1;
            lcd_rw <= 1'b1;
            lcd_data <= 8'b0000_0000;
        end
        else begin
            case(state)
                FUNCTION_SET: begin
                    lcd_rs <= 1'b0;
                    lcd_rw <= 1'b0;
                    lcd_data <= 8'b0011_1000;  // 8-bit, 2-line, 5x8 dots
                end
                
                DISP_ONOFF: begin
                    lcd_rs <= 1'b0;
                    lcd_rw <= 1'b0;
                    lcd_data <= 8'b0000_1100;  // Display ON, cursor OFF
                end
                
                ENTRY_MODE: begin
                    lcd_rs <= 1'b0;
                    lcd_rw <= 1'b0;
                    lcd_data <= 8'b0000_0110;  // Increment mode
                end
                
                LINE1: begin
                    lcd_rw <= 1'b0;
                    case(cnt)
                        0: begin
                            lcd_rs <= 1'b0;
                            lcd_data <= 8'b10000000+1;  // First line position 0
                        end
                        default: begin
                            lcd_rs <= 1'b1;  // Data mode
                            if(emergency_ev1 || emergency_ev2) begin
                                case(cnt)
                                    1: lcd_data <= 8'b01000101;  // "E"
                                    2: lcd_data <= 8'b01010110;  // "V"
                                    3: lcd_data <= emergency_ev1 ? 8'b00110001 : 8'b00110010;  // "1/2"
                                    4: lcd_data <= 8'b00100000;  // Space
                                    5: lcd_data <= 8'b01001111;  // "O"
                                    6: lcd_data <= 8'b01010101;  // "U"
                                    7: lcd_data <= 8'b01010100;  // "T"
                                    8: lcd_data <= 8'b00100000;  // Space
                                    9: lcd_data <= 8'b01001111;  // "O"
                                    10: lcd_data <= 8'b01000110;  // "F"
                                    11: lcd_data <= 8'b00100000;  // Space
                                    12: lcd_data <= 8'b01010011;  // "S"
                                    13: lcd_data <= 8'b01000101;  // "E"
                                    14: lcd_data <= 8'b01010010;  // "R"
                                    15: lcd_data <= 8'b01010110;  // "V"
                                    16: lcd_data <= 8'b01001001;  // "I"
                                    17: lcd_data <= 8'b01000011;  // "C"
                                    18: lcd_data <= 8'b01000101;  // "E"
                                    default: lcd_data <= 8'b00100000;
                                endcase
                            end
                            else begin
                                case(cnt)
                                    1: lcd_data <= 8'b01000101;  // "E"
                                    2: lcd_data <= 8'b01001100;  // "L"
                                    3: lcd_data <= 8'b01000101;  // "E"
                                    4: lcd_data <= 8'b01010110;  // "V"
                                    5: lcd_data <= 8'b01000001;  // "A"
                                    6: lcd_data <= 8'b01010100;  // "T"
                                    7: lcd_data <= 8'b01001111;  // "O"
                                    8: lcd_data <= 8'b01010010;  // "R"
                                    default: lcd_data <= 8'b00100000;
                                endcase
                            end
                        end
                    endcase
                end
                
                LINE2: begin
                    lcd_rw <= 1'b0;
                    case(cnt)
                        0: begin
                            lcd_rs <= 1'b0;
                            lcd_data <= 8'b11000000+1;  // Second line position 0
                        end
                        default: begin
                            lcd_rs <= 1'b1;  // Data mode
                            if(emergency_ev1 || emergency_ev2) begin
                                case(cnt)
                                    1: lcd_data <= 8'b01010000;  // "P"
                                    2: lcd_data <= 8'b01001100;  // "L"
                                    3: lcd_data <= 8'b01000101;  // "E"
                                    4: lcd_data <= 8'b01000001;  // "A"
                                    5: lcd_data <= 8'b01010011;  // "S"
                                    6: lcd_data <= 8'b01000101;  // "E"
                                    7: lcd_data <= 8'b00100000;  //   Space
                                    8: lcd_data <= 8'b01010101;  // "U"
                                    9: lcd_data <= 8'b01010011;  // "S"
                                    10: lcd_data <= 8'b01000101;  // "E"
                                    11: lcd_data <= 8'b00100000;  // Space
                                    12: lcd_data <= 8'b01000101;  // "E"
                                    13: lcd_data <= 8'b01010110;  // "V"
                                    14: lcd_data <= emergency_ev1 ? 8'b00110010 : 8'b00110001;  // "2/1"
                                    default: lcd_data <= 8'b00100000;
                                endcase
                            end
                            else begin
                                case(cnt)
                                    1: lcd_data <= 8'b01010111;  // "W"
                                    2: lcd_data <= 8'b01000101;  // "E"
                                    3: lcd_data <= 8'b01001100;  // "L"
                                    4: lcd_data <= 8'b01000011;  // "C"
                                    5: lcd_data <= 8'b01001111;  // "O"
                                    6: lcd_data <= 8'b01001101;  // "M"
                                    7: lcd_data <= 8'b01000101;  // "E"
                                    default: lcd_data <= 8'b00100000;
                                endcase
                            end
                        end
                    endcase
                end

                DISP_SHIFT: begin
                    lcd_rs <= 1'b0;
                    lcd_rw <= 1'b0;
                    if(emergency_ev1 || emergency_ev2) begin
                        case(cnt)
                            0: lcd_data <= 8'b0001_1000;  // Shift left
                            default: lcd_data <= 8'b0001_1000;  // Continue shifting left
                        endcase
                    end
                    else
                        lcd_data <= 8'b0000_0010;  // Return home in normal mode
                end

                DELAY_T: begin
                    lcd_rs <= 1'b0;
                    lcd_rw <= 1'b0;
                    lcd_data <= 8'b0000_0010;  // Return home
                end

                default: begin
                    lcd_rs <= 1'b1;
                    lcd_rw <= 1'b1;
                    lcd_data <= 8'b0000_0000;
                end
            endcase
        end
    end
    assign lcd_en = enable_clk;
endmodule