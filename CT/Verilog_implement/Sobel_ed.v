`timescale 1ns/10ps
//////////////////////////////////////////////////////////////////////////////////
// Sobel filter
// Kernel size: 3x3
// Kernel weight:
//    Gx:   --------------------     Gy:  -------------------
//          | -1  |  0  |  1  |           |  1  |  2  |  1  |
//          --------------------          -------------------
//          | -2  |  0  |  2  |           |  0  |  0  |  0  |
//          --------------------          -------------------
//          | -1  |  0  |  1  |           | -1  | -2  | -1  |
//          --------------------          -------------------
//
// Author: Abbiter Liu
//////////////////////////////////////////////////////////////////////////////////

module  Sobel_ed(
    input  [7:0] px_1, px_2, px_3, px_4, px_5, px_6, px_7, px_8, px_9,
    output  [16:0] out
	);

/////////////////////////////////////
//            Parameter            //
/////////////////////////////////////
//Kernel Gx
parameter signed Kernel_x_1 = -3'd1, 
                 Kernel_x_2 = 3'd0, 
                 Kernel_x_3 = 3'd1, 
                 Kernel_x_4 = -3'd2,
		         Kernel_x_5 = 3'd0, 
                 Kernel_x_6 = 3'd2, 
                 Kernel_x_7 = -3'd1, 
                 Kernel_x_8 = 3'd0,
                 Kernel_x_9 = 3'd1;
//Kernel Gy
parameter signed Kernel_y_1 = 3'd1, 
                 Kernel_y_2 = 3'd2, 
                 Kernel_y_3 = 3'd1, 
                 Kernel_y_4 = 3'd0,
                 Kernel_y_5 = 3'd0, 
                 Kernel_y_6 = 3'd0, 
                 Kernel_y_7 = -3'd1, 
                 Kernel_y_8 = -3'd2,
                 Kernel_y_9 = -3'd1;

/////////////////////////////////////
//          Mul & Add op           //
/////////////////////////////////////


wire signed [8:0] px_1_s, px_2_s, px_3_s, px_4_s, px_5_s, px_6_s, px_7_s, px_8_s, px_9_s;

assign px_1_s = {1'b0,px_1};
assign px_2_s = {1'b0,px_2};
assign px_3_s = {1'b0,px_3};
assign px_4_s = {1'b0,px_4};
assign px_5_s = {1'b0,px_5};
assign px_6_s = {1'b0,px_6};
assign px_7_s = {1'b0,px_7};
assign px_8_s = {1'b0,px_8};
assign px_9_s = {1'b0,px_9};

// Gx
wire signed [11:0] mul_x_1, mul_x_2, mul_x_3, mul_x_4, mul_x_5, mul_x_6, mul_x_7, mul_x_8, mul_x_9;
wire signed [12:0] add_x_1_1, add_x_1_2, add_x_1_3, add_x_1_4; 
wire signed [13:0] add_x_2_1, add_x_2_2; 
wire signed [14:0] add_x_3_1;
wire signed [15:0] Gx, Gx_abs;

assign mul_x_1 = px_1_s * Kernel_x_1;
assign mul_x_2 = px_2_s * Kernel_x_2;
assign mul_x_3 = px_3_s * Kernel_x_3;
assign mul_x_4 = px_4_s * Kernel_x_4;
assign mul_x_5 = px_5_s * Kernel_x_5;
assign mul_x_6 = px_6_s * Kernel_x_6;
assign mul_x_7 = px_7_s * Kernel_x_7;
assign mul_x_8 = px_8_s * Kernel_x_8;
assign mul_x_9 = px_9_s * Kernel_x_9;

assign add_x_1_1 = mul_x_1 + mul_x_2;
assign add_x_1_2 = mul_x_3 + mul_x_4;
assign add_x_1_3 = mul_x_5 + mul_x_6;
assign add_x_1_4 = mul_x_7 + mul_x_8;

assign add_x_2_1 = add_x_1_1 + add_x_1_2;
assign add_x_2_2 = add_x_1_3 + add_x_1_4;

assign add_x_3_1 = add_x_2_2 + mul_x_9;
assign Gx = add_x_2_1 + add_x_3_1;

assign Gx_abs = (Gx[15]==1'b1)? -Gx:Gx;

// Gy
wire signed [11:0] mul_y_1, mul_y_2, mul_y_3, mul_y_4, mul_y_5, mul_y_6, mul_y_7, mul_y_8, mul_y_9;
wire signed [12:0] add_y_1_1, add_y_1_2, add_y_1_3, add_y_1_4; 
wire signed [13:0] add_y_2_1, add_y_2_2; 
wire signed [14:0] add_y_3_1;
wire signed [15:0] Gy, Gy_abs;

assign mul_y_1 = px_1_s * Kernel_y_1;
assign mul_y_2 = px_2_s * Kernel_y_2;
assign mul_y_3 = px_3_s * Kernel_y_3;
assign mul_y_4 = px_4_s * Kernel_y_4;
assign mul_y_5 = px_5_s * Kernel_y_5;
assign mul_y_6 = px_6_s * Kernel_y_6;
assign mul_y_7 = px_7_s * Kernel_y_7;
assign mul_y_8 = px_8_s * Kernel_y_8;
assign mul_y_9 = px_9_s * Kernel_y_9;

assign add_y_1_1 = mul_y_1 + mul_y_2;
assign add_y_1_2 = mul_y_3 + mul_y_4;
assign add_y_1_3 = mul_y_5 + mul_y_6;
assign add_y_1_4 = mul_y_7 + mul_y_8;

assign add_y_2_1 = add_y_1_1 + add_y_1_2;
assign add_y_2_2 = add_y_1_3 + add_y_1_4;

assign add_y_3_1 = add_y_2_2 + mul_y_9;
assign Gy = add_y_2_1 + add_y_3_1;

assign Gy_abs = (Gy[15]==1'b1)? -Gy:Gy;

// out
assign out = Gx_abs + Gy_abs;

endmodule