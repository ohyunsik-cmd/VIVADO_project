module logic_gate (a, b, q, w, x, y, z);

input  a, b;

output q, w, x, y, z;

wire q, w, x, y, z;

assign q = a & b;

assign w = a | b;

assign x = a ^ b;

assign y = ~(a | b);

assign z = ~(a & b);

endmodule

