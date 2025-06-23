//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/29 20:11:18
// Design Name: 
// Module Name: logic_gate_one
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
module logic_gate_one(clk, D, Q);

input D,clk;
output reg Q;

always @(posedge clk)
begin
 Q <= D;
end

endmodule
