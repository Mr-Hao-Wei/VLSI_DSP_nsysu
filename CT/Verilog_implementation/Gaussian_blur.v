`timescale 1ns/10ps
//////////////////////////////////////////////////////////////////////////////////
// Gaussian blur 
// Kernel size: 3x3
// Kernel weight:
//          -------------------------
//          | 0.075 | 0.124 | 0.075 |
//          -------------------------
//          | 0.124 | 0.204 | 0.124 |
//          -------------------------
//          | 0.075 | 0.124 | 0.075 |
//          -------------------------
// Weight word length: 12
//        fraction length: 12
//
// Author: Abbiter Liu
//////////////////////////////////////////////////////////////////////////////////

module  Gaussian_blur(
    input  [7:0] px_1, px_2, px_3, px_4, px_5, px_6, px_7, px_8, px_9,
    output  [7:0] out
	);

/////////////////////////////////////
//            Parameter            //
/////////////////////////////////////
//Kernel
parameter Kernel_1 = 12'b000100110011, 
          Kernel_2 = 12'b000111111100, 
          Kernel_3 = 12'b000100110011, 
          Kernel_4 = 12'b000111111100,
          Kernel_5 = 12'b001101000100, 
          Kernel_6 = 12'b000111111100, 
          Kernel_7 = 12'b000100110011, 
          Kernel_8 = 12'b000111111100,
          Kernel_9 = 12'b000100110011;

/////////////////////////////////////
//          Mul & Add op           //
/////////////////////////////////////

wire  [19:0] mul_1, mul_2, mul_3, mul_4, mul_5, mul_6, mul_7, mul_8, mul_9;
wire  [19:0] add_1_1, add_1_2, add_1_3, add_1_4, add_2_1, add_2_2, add_3_1;

assign mul_1 = px_1 * Kernel_1;
assign mul_2 = px_2 * Kernel_2;
assign mul_3 = px_3 * Kernel_3;
assign mul_4 = px_4 * Kernel_4;
assign mul_5 = px_5 * Kernel_5;
assign mul_6 = px_6 * Kernel_6;
assign mul_7 = px_7 * Kernel_7;
assign mul_8 = px_8 * Kernel_8;
assign mul_9 = px_9 * Kernel_9;

assign add_1_1 = mul_1 + mul_2;
assign add_1_2 = mul_3 + mul_4;
assign add_1_3 = mul_5 + mul_6;
assign add_1_4 = mul_7 + mul_8;

assign add_2_1 = add_1_1 + add_1_2;
assign add_2_2 = add_1_3 + add_1_4;

assign add_3_1 = add_2_2 + mul_9;
assign out = (add_2_1 + add_3_1) >>> 12;

endmodule