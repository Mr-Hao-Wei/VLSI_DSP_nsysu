`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// 11-point FFT with pipline
// Structure: 11 point FFT with full combinational circuit
//
// Author: Abbiter Liu and JY Chen
//////////////////////////////////////////////////////////////////////////////////


module FFT_11_point_pipe
#(parameter WL=9, WL_out=34)
(   input clk, reset, load,
    input signed [WL-1:0] x0_r, x1_r, x2_r, x3_r, x4_r, x5_r, x6_r, x7_r, x8_r, x9_r, x10_r,
    input signed [WL-1:0] x0_i, x1_i, x2_i, x3_i, x4_i, x5_i, x6_i, x7_i, x8_i, x9_i, x10_i,
    output reg valid,
    output signed [WL_out-1:0] X0_r, X1_r, X2_r, X3_r, X4_r, X5_r, X6_r, X7_r, X8_r, X9_r, X10_r,
    output signed [WL_out-1:0] X0_i, X1_i, X2_i, X3_i, X4_i, X5_i, X6_i, X7_i, X8_i, X9_i, X10_i
    );

/////////////////////////////////////
//        First stage adder        //
/////////////////////////////////////

// first stage adder output
wire signed [9:0] a_n1_s1_r, a_n2_s1_r, a_n3_s1_r, a_n4_s1_r, a_n5_s1_r, a_n6_s1_r, a_n7_s1_r, a_n8_s1_r, a_n9_s1_r, a_n10_s1_r;
wire signed [9:0] a_n1_s1_i, a_n2_s1_i, a_n3_s1_i, a_n4_s1_i, a_n5_s1_i, a_n6_s1_i, a_n7_s1_i, a_n8_s1_i, a_n9_s1_i, a_n10_s1_i;

// first stage adder input inverse
wire signed [8:0] x10_r_inv, x2_r_inv, x7_r_inv, x8_r_inv, x6_r_inv;
wire signed [8:0] x10_i_inv, x2_i_inv, x7_i_inv, x8_i_inv, x6_i_inv;

assign x10_r_inv = -x10_r;
assign x2_r_inv = -x2_r;
assign x7_r_inv = -x7_r;
assign x8_r_inv = -x8_r;
assign x6_r_inv = -x6_r;

assign x10_i_inv = -x10_i;
assign x2_i_inv = -x2_i;
assign x7_i_inv = -x7_i;
assign x8_i_inv = -x8_i;
assign x6_i_inv = -x6_i;

// first stage adder
ComplexAdder #(.WL(9), .WL_out(10)) A_n1_s1 (
    .ar(x1_r), .ai(x1_i), .br(x10_r), .bi(x10_i),
    .cr(a_n1_s1_r), .ci(a_n1_s1_i)
);
ComplexAdder #(.WL(9), .WL_out(10)) A_n2_s1 (
    .ar(x9_r), .ai(x9_i), .br(x2_r), .bi(x2_i),
    .cr(a_n2_s1_r), .ci(a_n2_s1_i)
);
ComplexAdder #(.WL(9), .WL_out(10)) A_n3_s1 (
    .ar(x4_r), .ai(x4_i), .br(x7_r), .bi(x7_i),
    .cr(a_n3_s1_r), .ci(a_n3_s1_i)
);
ComplexAdder #(.WL(9), .WL_out(10)) A_n4_s1 (
    .ar(x3_r), .ai(x3_i), .br(x8_r), .bi(x8_i),
    .cr(a_n4_s1_r), .ci(a_n4_s1_i)
);
ComplexAdder #(.WL(9), .WL_out(10)) A_n5_s1 (
    .ar(x5_r), .ai(x5_i), .br(x6_r), .bi(x6_i),
    .cr(a_n5_s1_r), .ci(a_n5_s1_i)
);
ComplexAdder #(.WL(9), .WL_out(10)) A_n6_s1 (
    .ar(x1_r), .ai(x1_i), .br(x10_r_inv), .bi(x10_i_inv),
    .cr(a_n6_s1_r), .ci(a_n6_s1_i)
);
ComplexAdder #(.WL(9), .WL_out(10)) A_n7_s1 (
    .ar(x9_r), .ai(x9_i), .br(x2_r_inv), .bi(x2_i_inv),
    .cr(a_n7_s1_r), .ci(a_n7_s1_i)
);
ComplexAdder #(.WL(9), .WL_out(10)) A_n8_s1 (
    .ar(x4_r), .ai(x4_i), .br(x7_r_inv), .bi(x7_i_inv),
    .cr(a_n8_s1_r), .ci(a_n8_s1_i)
);
ComplexAdder #(.WL(9), .WL_out(10)) A_n9_s1 (
    .ar(x3_r), .ai(x3_i), .br(x8_r_inv), .bi(x8_i_inv),
    .cr(a_n9_s1_r), .ci(a_n9_s1_i)
);
ComplexAdder #(.WL(9), .WL_out(10)) A_n10_s1 (
    .ar(x5_r), .ai(x5_i), .br(x6_r_inv), .bi(x6_i_inv),
    .cr(a_n10_s1_r), .ci(a_n10_s1_i)
);

/////////////////////////////////////
//       Second stage adder        //
/////////////////////////////////////

// second stage adder tree output
wire signed [10:0] a_n1_1_s2_r, a_n1_2_s2_r, a_n2_1_s2_r, a_n2_2_s2_r;
wire signed [10:0] a_n1_1_s2_i, a_n1_2_s2_i, a_n2_1_s2_i, a_n2_2_s2_i;
wire signed [11:0] a_n1_3_s2_r, a_n2_3_s2_r;
wire signed [11:0] a_n1_3_s2_i, a_n2_3_s2_i;
wire signed [12:0] a_n1_4_s2_r, a_n2_4_s2_r;
wire signed [12:0] a_n1_4_s2_i, a_n2_4_s2_i;

// second stage adder output
wire signed [10:0] a_n3_s2_r, a_n4_s2_r, a_n5_s2_r, a_n6_s2_r, a_n7_s2_r, a_n8_s2_r, a_n9_s2_r, a_n10_s2_r;
wire signed [10:0] a_n3_s2_i, a_n4_s2_i, a_n5_s2_i, a_n6_s2_i, a_n7_s2_i, a_n8_s2_i, a_n9_s2_i, a_n10_s2_i;

// second stage adder input inverse
wire signed [9:0] a_n5_s1_r_inv, a_n10_s1_r_inv;
wire signed [9:0] a_n5_s1_i_inv, a_n10_s1_i_inv;

assign a_n5_s1_r_inv = -a_n5_s1_r;
assign a_n10_s1_r_inv = -a_n10_s1_r;

assign a_n5_s1_i_inv = -a_n5_s1_i;
assign a_n10_s1_i_inv = -a_n10_s1_i;


// second stage adder tree
ComplexAdder #(.WL(10), .WL_out(11)) A_n1_1_s2 (
    .ar(a_n1_s1_r), .ai(a_n1_s1_i), .br(a_n2_s1_r), .bi(a_n2_s1_i),
    .cr(a_n1_1_s2_r), .ci(a_n1_1_s2_i)
);
ComplexAdder #(.WL(10), .WL_out(11)) A_n1_2_s2 (
    .ar(a_n3_s1_r), .ai(a_n3_s1_i), .br(a_n4_s1_r), .bi(a_n4_s1_i),
    .cr(a_n1_2_s2_r), .ci(a_n1_2_s2_i)
);

ComplexAdder #(.WL(10), .WL_out(11)) A_n2_1_s2 (
    .ar(a_n6_s1_r), .ai(a_n6_s1_i), .br(a_n7_s1_r), .bi(a_n7_s1_i),
    .cr(a_n2_1_s2_r), .ci(a_n2_1_s2_i)
);
ComplexAdder #(.WL(10), .WL_out(11)) A_n2_2_s2 (
    .ar(a_n8_s1_r), .ai(a_n8_s1_i), .br(a_n9_s1_r), .bi(a_n9_s1_i),
    .cr(a_n2_2_s2_r), .ci(a_n2_2_s2_i)
);

//A_n1_3_s2 A_n1_4_s2 A_n2_3_s2 A_n2_4_s2 are moved after pipline stage 01


// second stage adder
ComplexAdder #(.WL(10), .WL_out(11)) A_n3_s2 (
    .ar(a_n1_s1_r), .ai(a_n1_s1_i), .br(a_n5_s1_r_inv), .bi(a_n5_s1_i_inv),
    .cr(a_n3_s2_r), .ci(a_n3_s2_i)
);
ComplexAdder #(.WL(10), .WL_out(11)) A_n4_s2 (
    .ar(a_n2_s1_r), .ai(a_n2_s1_i), .br(a_n5_s1_r_inv), .bi(a_n5_s1_i_inv),
    .cr(a_n4_s2_r), .ci(a_n4_s2_i)
);
ComplexAdder #(.WL(10), .WL_out(11)) A_n5_s2 (
    .ar(a_n3_s1_r), .ai(a_n3_s1_i), .br(a_n5_s1_r_inv), .bi(a_n5_s1_i_inv),
    .cr(a_n5_s2_r), .ci(a_n5_s2_i)
);
ComplexAdder #(.WL(10), .WL_out(11)) A_n6_s2 (
    .ar(a_n4_s1_r), .ai(a_n4_s1_i), .br(a_n5_s1_r_inv), .bi(a_n5_s1_i_inv),
    .cr(a_n6_s2_r), .ci(a_n6_s2_i)
);
ComplexAdder #(.WL(10), .WL_out(11)) A_n7_s2 (
    .ar(a_n9_s1_r), .ai(a_n9_s1_i), .br(a_n10_s1_r_inv), .bi(a_n10_s1_i_inv),
    .cr(a_n7_s2_r), .ci(a_n7_s2_i)
);
ComplexAdder #(.WL(10), .WL_out(11)) A_n8_s2 (
    .ar(a_n8_s1_r), .ai(a_n8_s1_i), .br(a_n10_s1_r_inv), .bi(a_n10_s1_i_inv),
    .cr(a_n8_s2_r), .ci(a_n8_s2_i)
);
ComplexAdder #(.WL(10), .WL_out(11)) A_n9_s2 (
    .ar(a_n7_s1_r), .ai(a_n7_s1_i), .br(a_n10_s1_r_inv), .bi(a_n10_s1_i_inv),
    .cr(a_n9_s2_r), .ci(a_n9_s2_i)
);
ComplexAdder #(.WL(10), .WL_out(11)) A_n10_s2 (
    .ar(a_n6_s1_r), .ai(a_n6_s1_i), .br(a_n10_s1_r_inv), .bi(a_n10_s1_i_inv),
    .cr(a_n10_s2_r), .ci(a_n10_s2_i)
);

/////////////////////////////////////
//        Pipeline stage 01        //
/////////////////////////////////////
// Pipeline output  Stage01
reg signed [10:0] a_n3_s2_r_d, a_n4_s2_r_d, a_n5_s2_r_d, a_n6_s2_r_d, a_n7_s2_r_d, a_n8_s2_r_d, a_n9_s2_r_d, a_n10_s2_r_d;
reg signed [10:0] a_n3_s2_i_d, a_n4_s2_i_d, a_n5_s2_i_d, a_n6_s2_i_d, a_n7_s2_i_d, a_n8_s2_i_d, a_n9_s2_i_d, a_n10_s2_i_d;
reg signed [10:0] a_n1_1_s2_r_d, a_n1_2_s2_r_d, a_n2_1_s2_r_d, a_n2_2_s2_r_d;
reg signed [10:0] a_n1_1_s2_i_d, a_n1_2_s2_i_d, a_n2_1_s2_i_d, a_n2_2_s2_i_d;
reg signed [9:0] a_n5_s1_r_d, a_n10_s1_r_d;
reg signed [9:0] a_n5_s1_i_d, a_n10_s1_i_d;
reg signed [WL-1:0] x0_r_d;
reg signed [WL-1:0] x0_i_d;

always @ (posedge clk) begin
    if (reset) begin
        a_n3_s2_r_d <= 0;
        a_n4_s2_r_d <= 0;
        a_n5_s2_r_d <= 0;
        a_n6_s2_r_d <= 0;
        a_n7_s2_r_d <= 0;
        a_n8_s2_r_d <= 0;
        a_n9_s2_r_d <= 0;
        a_n10_s2_r_d <= 0;
        a_n3_s2_i_d <= 0;
        a_n4_s2_i_d <= 0;
        a_n5_s2_i_d <= 0;
        a_n6_s2_i_d <= 0;
        a_n7_s2_i_d <= 0;
        a_n8_s2_i_d <= 0;
        a_n9_s2_i_d <= 0;
        a_n10_s2_i_d <= 0;
        a_n1_1_s2_r_d <= 0;
        a_n1_2_s2_r_d <= 0;
        a_n2_1_s2_r_d <= 0;
        a_n2_2_s2_r_d <= 0;
        a_n1_1_s2_i_d <= 0;
        a_n1_2_s2_i_d <= 0;
        a_n2_1_s2_i_d <= 0;
        a_n2_2_s2_i_d <= 0;
        a_n5_s1_r_d <= 0;
        a_n10_s1_r_d <= 0;
        a_n5_s1_i_d <= 0;
        a_n10_s1_i_d <= 0;
        x0_r_d <= 0;
        x0_i_d <= 0;
    end
    else begin
        a_n3_s2_r_d <= a_n3_s2_r;
        a_n4_s2_r_d <= a_n4_s2_r;
        a_n5_s2_r_d <= a_n5_s2_r;
        a_n6_s2_r_d <= a_n6_s2_r;
        a_n7_s2_r_d <= a_n7_s2_r;
        a_n8_s2_r_d <= a_n8_s2_r;
        a_n9_s2_r_d <= a_n9_s2_r;
        a_n10_s2_r_d <= a_n10_s2_r;
        a_n3_s2_i_d <= a_n3_s2_i;
        a_n4_s2_i_d <= a_n4_s2_i;
        a_n5_s2_i_d <= a_n5_s2_i;
        a_n6_s2_i_d <= a_n6_s2_i;
        a_n7_s2_i_d <= a_n7_s2_i;
        a_n8_s2_i_d <= a_n8_s2_i;
        a_n9_s2_i_d <= a_n9_s2_i;
        a_n10_s2_i_d <= a_n10_s2_i;
        a_n1_1_s2_r_d <= a_n1_1_s2_r;
        a_n1_2_s2_r_d <= a_n1_2_s2_r;
        a_n2_1_s2_r_d <= a_n2_1_s2_r;
        a_n2_2_s2_r_d <= a_n2_2_s2_r;
        a_n1_1_s2_i_d <= a_n1_1_s2_i;
        a_n1_2_s2_i_d <= a_n1_2_s2_i;
        a_n2_1_s2_i_d <= a_n2_1_s2_i;
        a_n2_2_s2_i_d <= a_n2_2_s2_i;
        a_n5_s1_r_d <= a_n5_s1_r;
        a_n10_s1_r_d <= a_n10_s1_r;
        a_n5_s1_i_d <= a_n5_s1_i;
        a_n10_s1_i_d <= a_n10_s1_i;
        x0_r_d <= x0_r;
        x0_i_d <= x0_i;
    end
end



ComplexAdder #(.WL(11), .WL_out(12)) A_n1_3_s2 (
    .ar(a_n1_1_s2_r_d), .ai(a_n1_1_s2_i_d), .br(a_n1_2_s2_r_d), .bi(a_n1_2_s2_i_d),
    .cr(a_n1_3_s2_r), .ci(a_n1_3_s2_i)
);
ComplexAdder #(.WL(12), .WL_out(13)) A_n1_4_s2 (
    .ar(a_n1_3_s2_r), .ai(a_n1_3_s2_i), .br({{2{a_n5_s1_r_d[9]}},a_n5_s1_r_d}), .bi({{2{a_n5_s1_i_d[9]}},a_n5_s1_i_d}),
    .cr(a_n1_4_s2_r), .ci(a_n1_4_s2_i)
);
ComplexAdder #(.WL(11), .WL_out(12)) A_n2_3_s2 (
    .ar(a_n2_1_s2_r_d), .ai(a_n2_1_s2_i_d), .br(a_n2_2_s2_r_d), .bi(a_n2_2_s2_i_d),
    .cr(a_n2_3_s2_r), .ci(a_n2_3_s2_i)
);
ComplexAdder #(.WL(12), .WL_out(13)) A_n2_4_s2 (
    .ar(a_n2_3_s2_r), .ai(a_n2_3_s2_i), .br({{2{a_n10_s1_r_d[9]}},a_n10_s1_r_d}), .bi({{2{a_n10_s1_i_d[9]}},a_n10_s1_i_d}),
    .cr(a_n2_4_s2_r), .ci(a_n2_4_s2_i)
);

/////////////////////////////////////
//        Third stage adder        //
/////////////////////////////////////

// third stage adder output
wire signed [11:0] a_n1_s3_r, a_n2_s3_r, a_n3_s3_r, a_n4_s3_r;
wire signed [11:0] a_n1_s3_i, a_n2_s3_i, a_n3_s3_i, a_n4_s3_i;

// third stage adder
ComplexAdder #(.WL(11), .WL_out(12)) A_n1_s3 (
    .ar(a_n3_s2_r_d), .ai(a_n3_s2_i_d), .br(a_n5_s2_r_d), .bi(a_n5_s2_i_d),
    .cr(a_n1_s3_r), .ci(a_n1_s3_i)
);
ComplexAdder #(.WL(11), .WL_out(12)) A_n2_s3 (
    .ar(a_n4_s2_r_d), .ai(a_n4_s2_i_d), .br(a_n6_s2_r_d), .bi(a_n6_s2_i_d),
    .cr(a_n2_s3_r), .ci(a_n2_s3_i)
);
ComplexAdder #(.WL(11), .WL_out(12)) A_n3_s3 (
    .ar(a_n7_s2_r_d), .ai(a_n7_s2_i_d), .br(a_n9_s2_r_d), .bi(a_n9_s2_i_d),
    .cr(a_n3_s3_r), .ci(a_n3_s3_i)
);
ComplexAdder #(.WL(11), .WL_out(12)) A_n4_s3 (
    .ar(a_n8_s2_r_d), .ai(a_n8_s2_i_d), .br(a_n10_s2_r_d), .bi(a_n10_s2_i_d),
    .cr(a_n4_s3_r), .ci(a_n4_s3_i)
);

/////////////////////////////////////
//        Forth stage adder        //
/////////////////////////////////////

// forth stage adder output
wire signed [13:0] a_n1_s4_r;
wire signed [13:0] a_n1_s4_i;
wire signed [12:0] a_n2_s4_r, a_n3_s4_r, a_n4_s4_r, a_n5_s4_r, a_n6_s4_r, a_n7_s4_r;
wire signed [12:0] a_n2_s4_i, a_n3_s4_i, a_n4_s4_i, a_n5_s4_i, a_n6_s4_i, a_n7_s4_i;

// forth stage adder
ComplexAdder #(.WL(13), .WL_out(14)) A_n1_s4 (
    .ar({{4{x0_r_d[8]}},x0_r_d}), .ai({{4{x0_i_d[8]}},x0_i_d}), .br(a_n1_4_s2_r), .bi(a_n1_4_s2_i),
    .cr(a_n1_s4_r), .ci(a_n1_s4_i)
);
ComplexAdder #(.WL(11), .WL_out(13)) A_n2_s4 (
    .ar(a_n3_s2_r_d), .ai(a_n3_s2_i_d), .br(a_n4_s2_r_d), .bi(a_n4_s2_i_d),
    .cr(a_n2_s4_r), .ci(a_n2_s4_i)
);
ComplexAdder #(.WL(11), .WL_out(13)) A_n3_s4 (
    .ar(a_n5_s2_r_d), .ai(a_n5_s2_i_d), .br(a_n6_s2_r_d), .bi(a_n6_s2_i_d),
    .cr(a_n3_s4_r), .ci(a_n3_s4_i)
);
ComplexAdder #(.WL(12), .WL_out(13)) A_n4_s4 (
    .ar(a_n1_s3_r), .ai(a_n1_s3_i), .br(a_n2_s3_r), .bi(a_n2_s3_i),
    .cr(a_n4_s4_r), .ci(a_n4_s4_i)
);
ComplexAdder #(.WL(12), .WL_out(13)) A_n5_s4 (
    .ar(a_n3_s3_r), .ai(a_n3_s3_i), .br(a_n4_s3_r), .bi(a_n4_s3_i),
    .cr(a_n5_s4_r), .ci(a_n5_s4_i)
);
ComplexAdder #(.WL(11), .WL_out(13)) A_n6_s4 (
    .ar(a_n7_s2_r_d), .ai(a_n7_s2_i_d), .br(a_n8_s2_r_d), .bi(a_n8_s2_i_d),
    .cr(a_n6_s4_r), .ci(a_n6_s4_i)
);
ComplexAdder #(.WL(11), .WL_out(13)) A_n7_s4 (
    .ar(a_n9_s2_r_d), .ai(a_n9_s2_i_d), .br(a_n10_s2_r_d), .bi(a_n10_s2_i_d),
    .cr(a_n7_s4_r), .ci(a_n7_s4_i)
);

/////////////////////////////////////
//        Pipeline stage 02        //
/////////////////////////////////////

// Pipeline output  Stage01
reg signed [13:0] a_n1_s4_r_d;
reg signed [13:0] a_n1_s4_i_d;
reg signed [12:0] a_n2_s4_r_d, a_n3_s4_r_d, a_n4_s4_r_d, a_n5_s4_r_d, a_n6_s4_r_d, a_n7_s4_r_d;
reg signed [12:0] a_n2_s4_i_d, a_n3_s4_i_d, a_n4_s4_i_d, a_n5_s4_i_d, a_n6_s4_i_d, a_n7_s4_i_d;
reg signed [12:0] a_n1_4_s2_r_d, a_n2_4_s2_r_d;
reg signed [12:0] a_n1_4_s2_i_d, a_n2_4_s2_i_d;
reg signed [10:0] a_n3_s2_r_d_d, a_n4_s2_r_d_d, a_n5_s2_r_d_d, a_n6_s2_r_d_d, a_n7_s2_r_d_d, a_n8_s2_r_d_d, a_n9_s2_r_d_d, a_n10_s2_r_d_d;
reg signed [10:0] a_n3_s2_i_d_d, a_n4_s2_i_d_d, a_n5_s2_i_d_d, a_n6_s2_i_d_d, a_n7_s2_i_d_d, a_n8_s2_i_d_d, a_n9_s2_i_d_d, a_n10_s2_i_d_d;
reg signed [11:0] a_n1_s3_r_d, a_n2_s3_r_d, a_n3_s3_r_d, a_n4_s3_r_d;
reg signed [11:0] a_n1_s3_i_d, a_n2_s3_i_d, a_n3_s3_i_d, a_n4_s3_i_d;

always @ (posedge clk) begin
    if (reset) begin
        a_n1_s4_r_d <= 0;
        a_n1_s4_i_d <= 0;
        a_n2_s4_r_d <= 0;
        a_n3_s4_r_d <= 0;
        a_n4_s4_r_d <= 0;
        a_n5_s4_r_d <= 0;
        a_n6_s4_r_d <= 0;
        a_n7_s4_r_d <= 0;
        a_n2_s4_i_d <= 0;
        a_n3_s4_i_d <= 0;
        a_n4_s4_i_d <= 0;
        a_n5_s4_i_d <= 0;
        a_n6_s4_i_d <= 0;
        a_n7_s4_i_d <= 0;
        a_n1_4_s2_r_d <= 0;
        a_n2_4_s2_r_d <= 0;
        a_n1_4_s2_i_d <= 0;
        a_n2_4_s2_i_d <= 0;
        a_n3_s2_r_d_d <= 0;
        a_n4_s2_r_d_d <= 0;
        a_n5_s2_r_d_d <= 0;
        a_n6_s2_r_d_d <= 0;
        a_n7_s2_r_d_d <= 0;
        a_n8_s2_r_d_d <= 0;
        a_n9_s2_r_d_d <= 0;
        a_n10_s2_r_d_d <= 0;
        a_n3_s2_i_d_d <= 0;
        a_n4_s2_i_d_d <= 0;
        a_n5_s2_i_d_d <= 0;
        a_n6_s2_i_d_d <= 0;
        a_n7_s2_i_d_d <= 0;
        a_n8_s2_i_d_d <= 0;
        a_n9_s2_i_d_d <= 0;
        a_n10_s2_i_d_d <= 0;
        a_n1_s3_r_d <= 0;
        a_n2_s3_r_d <= 0;
        a_n3_s3_r_d <= 0;
        a_n4_s3_r_d <= 0;
        a_n1_s3_i_d <= 0;
        a_n2_s3_i_d <= 0;
        a_n3_s3_i_d <= 0;
        a_n4_s3_i_d <= 0;
    end
    else begin
        a_n1_s4_r_d <= a_n1_s4_r;
        a_n1_s4_i_d <= a_n1_s4_i;
        a_n2_s4_r_d <= a_n2_s4_r;
        a_n3_s4_r_d <= a_n3_s4_r;
        a_n4_s4_r_d <= a_n4_s4_r;
        a_n5_s4_r_d <= a_n5_s4_r;
        a_n6_s4_r_d <= a_n6_s4_r;
        a_n7_s4_r_d <= a_n7_s4_r;
        a_n2_s4_i_d <= a_n2_s4_i;
        a_n3_s4_i_d <= a_n3_s4_i;
        a_n4_s4_i_d <= a_n4_s4_i;
        a_n5_s4_i_d <= a_n5_s4_i;
        a_n6_s4_i_d <= a_n6_s4_i;
        a_n7_s4_i_d <= a_n7_s4_i;
        a_n1_4_s2_r_d <= a_n1_4_s2_r;
        a_n2_4_s2_r_d <= a_n2_4_s2_r;
        a_n1_4_s2_i_d <= a_n1_4_s2_i;
        a_n2_4_s2_i_d <= a_n2_4_s2_i;
        a_n3_s2_r_d_d <= a_n3_s2_r_d;
        a_n4_s2_r_d_d <= a_n4_s2_r_d;
        a_n5_s2_r_d_d <= a_n5_s2_r_d;
        a_n6_s2_r_d_d <= a_n6_s2_r_d;
        a_n7_s2_r_d_d <= a_n7_s2_r_d;
        a_n8_s2_r_d_d <= a_n8_s2_r_d;
        a_n9_s2_r_d_d <= a_n9_s2_r_d;
        a_n10_s2_r_d_d <= a_n10_s2_r_d;
        a_n3_s2_i_d_d <= a_n3_s2_i_d;
        a_n4_s2_i_d_d <= a_n4_s2_i_d;
        a_n5_s2_i_d_d <= a_n5_s2_i_d;
        a_n6_s2_i_d_d <= a_n6_s2_i_d;
        a_n7_s2_i_d_d <= a_n7_s2_i_d;
        a_n8_s2_i_d_d <= a_n8_s2_i_d;
        a_n9_s2_i_d_d <= a_n9_s2_i_d;
        a_n10_s2_i_d_d <= a_n10_s2_i_d;
        a_n1_s3_r_d <= a_n1_s3_r;
        a_n2_s3_r_d <= a_n2_s3_r;
        a_n3_s3_r_d <= a_n3_s3_r;
        a_n4_s3_r_d <= a_n4_s3_r;
        a_n1_s3_i_d <= a_n1_s3_i;
        a_n2_s3_i_d <= a_n2_s3_i;
        a_n3_s3_i_d <= a_n3_s3_i;
        a_n4_s3_i_d <= a_n4_s3_i;
    end
end

/////////////////////////////////////
//         Multiplier stage        //
/////////////////////////////////////

// multiplier coefficients

wire signed [14:0] W1, W2, W3, W4, W5, W6, W7, W8, W9, W10,
                   W11, W12, W13, W14, W15, W16, W17, W18, W19, W20;

assign  W1 = 15'b110111001100111;
assign  W2 = 15'b000010101001110;
assign  W3 = 15'b000010000001100;
assign  W4 = 15'b110101101100100;
assign  W5 = 15'b000010011011111;
assign  W6 = 15'b111100110111110;
assign  W7 = 15'b101001000010001;
assign  W8 = 15'b001010111111111;
assign  W9 = 15'b000110100010011;
assign  W10 = 15'b001110011001111;
assign  W11 = 15'b111001001000000;
assign  W20 = 15'b101101000000111;
assign  W19 = 15'b111111110011011;
assign  W18 = 15'b000011110010101;
assign  W17 = 15'b000101111011111;
assign  W16 = 15'b001011010000000;
assign  W15 = 15'b110110011110001;
assign  W14 = 15'b000101101010100;
assign  W13 = 15'b000010000100100;
assign  W12 = 15'b111111100110100;

// multiplier output
wire signed [27:0] m_n1_r, m_n2_r, m_n3_r, m_n4_r, m_n5_r, m_n6_r, m_n7_r, m_n8_r, m_n9_r, m_n10_r,
                   m_n11_r, m_n12_r, m_n13_r, m_n14_r, m_n15_r, m_n16_r, m_n17_r, m_n18_r, m_n19_r, m_n20_r;
wire signed [27:0] m_n1_i, m_n2_i, m_n3_i, m_n4_i, m_n5_i, m_n6_i, m_n7_i, m_n8_i, m_n9_i, m_n10_i,
                   m_n11_i, m_n12_i, m_n13_i, m_n14_i, m_n15_i, m_n16_i, m_n17_i, m_n18_i, m_n19_i, m_n20_i;

// multiplier
ComplexMul_coef_Real #(.WL(15), .WL_out(28)) M_n1 (   
    .ar({{2{a_n1_4_s2_r_d[12]}},a_n1_4_s2_r_d}), .ai({{2{a_n1_4_s2_i_d[12]}},a_n1_4_s2_i_d}), .br(W1),
    .cr(m_n1_r), .ci(m_n1_i)
);
ComplexMul_coef_Imag #(.WL(15), .WL_out(28)) M_n2 (   
    .ar({{2{a_n2_4_s2_r_d[12]}},a_n2_4_s2_r_d}), .ai({{2{a_n2_4_s2_i_d[12]}},a_n2_4_s2_i_d}), .bi(W2),
    .cr(m_n2_r), .ci(m_n2_i)
);
ComplexMul_coef_Real #(.WL(15), .WL_out(28)) M_n3 (   
    .ar({{4{a_n3_s2_r_d_d[10]}},a_n3_s2_r_d_d}), .ai({{4{a_n3_s2_i_d_d[10]}},a_n3_s2_i_d_d}), .br(W3),
    .cr(m_n3_r), .ci(m_n3_i)
);
ComplexMul_coef_Real #(.WL(15), .WL_out(28)) M_n4 (   
    .ar({{4{a_n4_s2_r_d_d[10]}},a_n4_s2_r_d_d}), .ai({{4{a_n4_s2_i_d_d[10]}},a_n4_s2_i_d_d}), .br(W4),
    .cr(m_n4_r), .ci(m_n4_i)
);
ComplexMul_coef_Real #(.WL(15), .WL_out(28)) M_n5 (   
    .ar({{2{a_n2_s4_r_d[12]}},a_n2_s4_r_d}), .ai({{2{a_n2_s4_i_d[12]}},a_n2_s4_i_d}), .br(W5),
    .cr(m_n5_r), .ci(m_n5_i)
);
ComplexMul_coef_Real #(.WL(15), .WL_out(28)) M_n6 (   
    .ar({{4{a_n5_s2_r_d_d[10]}},a_n5_s2_r_d_d}), .ai({{4{a_n5_s2_i_d_d[10]}},a_n5_s2_i_d_d}), .br(W6),
    .cr(m_n6_r), .ci(m_n6_i)
);
ComplexMul_coef_Real #(.WL(15), .WL_out(28)) M_n7 (   
    .ar({{4{a_n6_s2_r_d_d[10]}},a_n6_s2_r_d_d}), .ai({{4{a_n6_s2_i_d_d[10]}},a_n6_s2_i_d_d}), .br(W7),
    .cr(m_n7_r), .ci(m_n7_i)
);
ComplexMul_coef_Real #(.WL(15), .WL_out(28)) M_n8 (   
    .ar({{2{a_n3_s4_r_d[12]}},a_n3_s4_r_d}), .ai({{2{a_n3_s4_i_d[12]}},a_n3_s4_i_d}), .br(W8),
    .cr(m_n8_r), .ci(m_n8_i)
);
ComplexMul_coef_Real #(.WL(15), .WL_out(28)) M_n9 (   
    .ar({{3{a_n1_s3_r_d[11]}},a_n1_s3_r_d}), .ai({{3{a_n1_s3_i_d[11]}},a_n1_s3_i_d}), .br(W9),
    .cr(m_n9_r), .ci(m_n9_i)
);
ComplexMul_coef_Real #(.WL(15), .WL_out(28)) M_n10 (   
    .ar({{3{a_n2_s3_r_d[11]}},a_n2_s3_r_d}), .ai({{3{a_n2_s3_i_d[11]}},a_n2_s3_i_d}), .br(W10),
    .cr(m_n10_r), .ci(m_n10_i)
);
ComplexMul_coef_Real #(.WL(15), .WL_out(28)) M_n11 (   
    .ar({{2{a_n4_s4_r_d[12]}},a_n4_s4_r_d}), .ai({{2{a_n4_s4_i_d[12]}},a_n4_s4_i_d}), .br(W11),
    .cr(m_n11_r), .ci(m_n11_i)
);
ComplexMul_coef_Imag #(.WL(15), .WL_out(28)) M_n12 (   
    .ar({{2{a_n5_s4_r_d[12]}},a_n5_s4_r_d}), .ai({{2{a_n5_s4_i_d[12]}},a_n5_s4_i_d}), .bi(W12),
    .cr(m_n12_r), .ci(m_n12_i)
);
ComplexMul_coef_Imag #(.WL(15), .WL_out(28)) M_n13 (   
    .ar({{3{a_n3_s3_r_d[11]}},a_n3_s3_r_d}), .ai({{3{a_n3_s3_i_d[11]}},a_n3_s3_i_d}), .bi(W13),
    .cr(m_n13_r), .ci(m_n13_i)
);
ComplexMul_coef_Imag #(.WL(15), .WL_out(28)) M_n14 (   
    .ar({{3{a_n4_s3_r_d[11]}},a_n4_s3_r_d}), .ai({{3{a_n4_s3_i_d[11]}},a_n4_s3_i_d}), .bi(W14),
    .cr(m_n14_r), .ci(m_n14_i)
);
ComplexMul_coef_Imag #(.WL(15), .WL_out(28)) M_n15 (   
    .ar({{2{a_n6_s4_r_d[12]}},a_n6_s4_r_d}), .ai({{2{a_n6_s4_i_d[12]}},a_n6_s4_i_d}), .bi(W15),
    .cr(m_n15_r), .ci(m_n15_i)
);
ComplexMul_coef_Imag #(.WL(15), .WL_out(28)) M_n16 (   
    .ar({{4{a_n7_s2_r_d_d[10]}},a_n7_s2_r_d_d}), .ai({{4{a_n7_s2_i_d_d[10]}},a_n7_s2_i_d_d}), .bi(W16),
    .cr(m_n16_r), .ci(m_n16_i)
);
ComplexMul_coef_Imag #(.WL(15), .WL_out(28)) M_n17 (   
    .ar({{4{a_n8_s2_r_d_d[10]}},a_n8_s2_r_d_d}), .ai({{4{a_n8_s2_i_d_d[10]}},a_n8_s2_i_d_d}), .bi(W17),
    .cr(m_n17_r), .ci(m_n17_i)
);
ComplexMul_coef_Imag #(.WL(15), .WL_out(28)) M_n18 (   
    .ar({{2{a_n7_s4_r_d[12]}},a_n7_s4_r_d}), .ai({{2{a_n7_s4_i_d[12]}},a_n7_s4_i_d}), .bi(W18),
    .cr(m_n18_r), .ci(m_n18_i)
);
ComplexMul_coef_Imag #(.WL(15), .WL_out(28)) M_n19 (   
    .ar({{4{a_n9_s2_r_d_d[10]}},a_n9_s2_r_d_d}), .ai({{4{a_n9_s2_i_d_d[10]}},a_n9_s2_i_d_d}), .bi(W19),
    .cr(m_n19_r), .ci(m_n19_i)
);
ComplexMul_coef_Imag #(.WL(15), .WL_out(28)) M_n20 (   
    .ar({{4{a_n10_s2_r_d_d[10]}},a_n10_s2_r_d_d}), .ai({{4{a_n10_s2_i_d_d[10]}},a_n10_s2_i_d_d}), .bi(W20),
    .cr(m_n20_r), .ci(m_n20_i)
);

/////////////////////////////////////
//        Pipeline stage 03        //
/////////////////////////////////////

// Pipeline output  Stage01
reg signed [27:0] m_n1_r_d, m_n2_r_d, m_n3_r_d, m_n4_r_d, m_n5_r_d, m_n6_r_d, m_n7_r_d, m_n8_r_d, m_n9_r_d, m_n10_r_d,
                   m_n11_r_d, m_n12_r_d, m_n13_r_d, m_n14_r_d, m_n15_r_d, m_n16_r_d, m_n17_r_d, m_n18_r_d, m_n19_r_d, m_n20_r_d;
reg signed [27:0] m_n1_i_d, m_n2_i_d, m_n3_i_d, m_n4_i_d, m_n5_i_d, m_n6_i_d, m_n7_i_d, m_n8_i_d, m_n9_i_d, m_n10_i_d,
                   m_n11_i_d, m_n12_i_d, m_n13_i_d, m_n14_i_d, m_n15_i_d, m_n16_i_d, m_n17_i_d, m_n18_i_d, m_n19_i_d, m_n20_i_d;
reg signed [13:0] a_n1_s4_r_d_d;
reg signed [13:0] a_n1_s4_i_d_d;

always @ (posedge clk) begin
    if (reset) begin
        m_n1_r_d <= 0;
        m_n2_r_d <= 0;
        m_n3_r_d <= 0;
        m_n4_r_d <= 0;
        m_n5_r_d <= 0;
        m_n6_r_d <= 0;
        m_n7_r_d <= 0;
        m_n8_r_d <= 0;
        m_n9_r_d <= 0;
        m_n10_r_d <= 0; 
        m_n11_r_d <= 0;
        m_n12_r_d <= 0;
        m_n13_r_d <= 0;
        m_n14_r_d <= 0;
        m_n15_r_d <= 0;
        m_n16_r_d <= 0;
        m_n17_r_d <= 0;
        m_n18_r_d <= 0;
        m_n19_r_d <= 0;
        m_n20_r_d <= 0;
        m_n1_i_d <= 0;
        m_n2_i_d <= 0;
        m_n3_i_d <= 0;
        m_n4_i_d <= 0;
        m_n5_i_d <= 0;
        m_n6_i_d <= 0;
        m_n7_i_d <= 0;
        m_n8_i_d <= 0;
        m_n9_i_d <= 0;
        m_n10_i_d <= 0;
        m_n11_i_d <= 0;
        m_n12_i_d <= 0;
        m_n13_i_d <= 0;
        m_n14_i_d <= 0;
        m_n15_i_d <= 0;
        m_n16_i_d <= 0;
        m_n17_i_d <= 0;
        m_n18_i_d <= 0;
        m_n19_i_d <= 0;
        m_n20_i_d <= 0;
        a_n1_s4_r_d_d <= 0;
        a_n1_s4_i_d_d <= 0;
    end
    else begin
        m_n1_r_d <= m_n1_r;
        m_n2_r_d <= m_n2_r;
        m_n3_r_d <= m_n3_r;
        m_n4_r_d <= m_n4_r;
        m_n5_r_d <= m_n5_r;
        m_n6_r_d <= m_n6_r;
        m_n7_r_d <= m_n7_r;
        m_n8_r_d <= m_n8_r;
        m_n9_r_d <= m_n9_r;
        m_n10_r_d <= m_n10_r;
        m_n11_r_d <= m_n11_r;
        m_n12_r_d <= m_n12_r;
        m_n13_r_d <= m_n13_r;
        m_n14_r_d <= m_n14_r;
        m_n15_r_d <= m_n15_r;
        m_n16_r_d <= m_n16_r;
        m_n17_r_d <= m_n17_r;
        m_n18_r_d <= m_n18_r;
        m_n19_r_d <= m_n19_r;
        m_n20_r_d <= m_n20_r;
        m_n1_i_d <= m_n1_i;
        m_n2_i_d <= m_n2_i;
        m_n3_i_d <= m_n3_i;
        m_n4_i_d <= m_n4_i;
        m_n5_i_d <= m_n5_i;
        m_n6_i_d <= m_n6_i;
        m_n7_i_d <= m_n7_i;
        m_n8_i_d <= m_n8_i;
        m_n9_i_d <= m_n9_i;
        m_n10_i_d <= m_n10_i;
        m_n11_i_d <= m_n11_i;
        m_n12_i_d <= m_n12_i;
        m_n13_i_d <= m_n13_i;
        m_n14_i_d <= m_n14_i;
        m_n15_i_d <= m_n15_i;
        m_n16_i_d <= m_n16_i;
        m_n17_i_d <= m_n17_i;
        m_n18_i_d <= m_n18_i;
        m_n19_i_d <= m_n19_i;
        m_n20_i_d <= m_n20_i;
        a_n1_s4_r_d_d <= a_n1_s4_r_d;
        a_n1_s4_i_d_d <= a_n1_s4_i_d;
    end
end

/////////////////////////////////////
//        Fifth stage adder        //
/////////////////////////////////////

// fifth stage adder output
wire signed [28:0] a_n1_s5_r, a_n2_s5_r, a_n3_s5_r, a_n4_s5_r, a_n5_s5_r, a_n6_s5_r, a_n7_s5_r, a_n8_s5_r, a_n9_s5_r, a_n10_s5_r, a_n11_s5_r, a_n12_s5_r;
wire signed [28:0] a_n1_s5_i, a_n2_s5_i, a_n3_s5_i, a_n4_s5_i, a_n5_s5_i, a_n6_s5_i, a_n7_s5_i, a_n8_s5_i, a_n9_s5_i, a_n10_s5_i, a_n11_s5_i, a_n12_s5_i;

// fifth stage adder
ComplexAdder #(.WL(28), .WL_out(29)) A_n1_s5 (
    .ar(m_n3_r_d), .ai(m_n3_i_d), .br(m_n9_r_d), .bi(m_n9_i_d),
    .cr(a_n1_s5_r), .ci(a_n1_s5_i)
);
ComplexAdder #(.WL(28), .WL_out(29)) A_n2_s5 (
    .ar(m_n6_r_d), .ai(m_n6_i_d), .br(m_n9_r_d), .bi(m_n9_i_d),
    .cr(a_n2_s5_r), .ci(a_n2_s5_i)
);
ComplexAdder #(.WL(28), .WL_out(29)) A_n3_s5 (
    .ar(m_n4_r_d), .ai(m_n4_i_d), .br(m_n10_r_d), .bi(m_n10_i_d),
    .cr(a_n3_s5_r), .ci(a_n3_s5_i)
);
ComplexAdder #(.WL(28), .WL_out(29)) A_n4_s5 (
    .ar(m_n7_r_d), .ai(m_n7_i_d), .br(m_n10_r_d), .bi(m_n10_i_d),
    .cr(a_n4_s5_r), .ci(a_n4_s5_i)
);
ComplexAdder #(.WL(28), .WL_out(29)) A_n5_s5 (
    .ar(m_n5_r_d), .ai(m_n5_i_d), .br(m_n11_r_d), .bi(m_n11_i_d),
    .cr(a_n5_s5_r), .ci(a_n5_s5_i)
);
ComplexAdder #(.WL(28), .WL_out(29)) A_n6_s5 (
    .ar(m_n8_r_d), .ai(m_n8_i_d), .br(m_n11_r_d), .bi(m_n11_i_d),
    .cr(a_n6_s5_r), .ci(a_n6_s5_i)
);
ComplexAdder #(.WL(28), .WL_out(29)) A_n7_s5 (
    .ar(m_n12_r_d), .ai(m_n12_i_d), .br(m_n15_r_d), .bi(m_n15_i_d),
    .cr(a_n7_s5_r), .ci(a_n7_s5_i)
);
ComplexAdder #(.WL(28), .WL_out(29)) A_n8_s5 (
    .ar(m_n12_r_d), .ai(m_n12_i_d), .br(m_n18_r_d), .bi(m_n18_i_d),
    .cr(a_n8_s5_r), .ci(a_n8_s5_i)
);
ComplexAdder #(.WL(28), .WL_out(29)) A_n9_s5 (
    .ar(m_n13_r_d), .ai(m_n13_i_d), .br(m_n16_r_d), .bi(m_n16_i_d),
    .cr(a_n9_s5_r), .ci(a_n9_s5_i)
);
ComplexAdder #(.WL(28), .WL_out(29)) A_n10_s5 (
    .ar(m_n13_r_d), .ai(m_n13_i_d), .br(m_n19_r_d), .bi(m_n19_i_d),
    .cr(a_n10_s5_r), .ci(a_n10_s5_i)
);
ComplexAdder #(.WL(28), .WL_out(29)) A_n11_s5 (
    .ar(m_n14_r_d), .ai(m_n14_i_d), .br(m_n17_r_d), .bi(m_n17_i_d),
    .cr(a_n11_s5_r), .ci(a_n11_s5_i)
);
ComplexAdder #(.WL(28), .WL_out(29)) A_n12_s5 (
    .ar(m_n14_r_d), .ai(m_n14_i_d), .br(m_n20_r_d), .bi(m_n20_i_d),
    .cr(a_n12_s5_r), .ci(a_n12_s5_i)
);

/////////////////////////////////////
//        Sixth stage adder        //
/////////////////////////////////////

// sixth stage adder output
wire signed [28:0] a_n1_s6_r;
wire signed [28:0] a_n1_s6_i;
wire signed [29:0] a_n2_s6_r, a_n3_s6_r, a_n4_s6_r, a_n5_s6_r, a_n6_s6_r, a_n7_s6_r, a_n8_s6_r, a_n9_s6_r;
wire signed [29:0] a_n2_s6_i, a_n3_s6_i, a_n4_s6_i, a_n5_s6_i, a_n6_s6_i, a_n7_s6_i, a_n8_s6_i, a_n9_s6_i;

// input expansion
wire signed [27:0] a_n1_s4_r_d_d_exp, a_n1_s4_i_d_d_exp;

assign a_n1_s4_r_d_d_exp = {{2{a_n1_s4_r_d_d[13]}},a_n1_s4_r_d_d,12'd0};
assign a_n1_s4_i_d_d_exp = {{2{a_n1_s4_i_d_d[13]}},a_n1_s4_i_d_d,12'd0};

// sixth stage adder
ComplexAdder #(.WL(28), .WL_out(29)) A_n1_s6 (
    .ar(a_n1_s4_r_d_d_exp), .ai(a_n1_s4_i_d_d_exp), .br(m_n1_r_d), .bi(m_n1_i_d),
    .cr(a_n1_s6_r), .ci(a_n1_s6_i)
);
ComplexAdder #(.WL(29), .WL_out(30)) A_n2_s6 (
    .ar(a_n1_s5_r), .ai(a_n1_s5_i), .br(a_n5_s5_r), .bi(a_n5_s5_i),
    .cr(a_n2_s6_r), .ci(a_n2_s6_i)
);
ComplexAdder #(.WL(29), .WL_out(30)) A_n3_s6 (
    .ar(a_n3_s5_r), .ai(a_n3_s5_i), .br(a_n5_s5_r), .bi(a_n5_s5_i),
    .cr(a_n3_s6_r), .ci(a_n3_s6_i)
);
ComplexAdder #(.WL(29), .WL_out(30)) A_n4_s6 (
    .ar(a_n2_s5_r), .ai(a_n2_s5_i), .br(a_n6_s5_r), .bi(a_n6_s5_i),
    .cr(a_n4_s6_r), .ci(a_n4_s6_i)
);
ComplexAdder #(.WL(29), .WL_out(30)) A_n5_s6 (
    .ar(a_n4_s5_r), .ai(a_n4_s5_i), .br(a_n6_s5_r), .bi(a_n6_s5_i),
    .cr(a_n5_s6_r), .ci(a_n5_s6_i)
);
ComplexAdder #(.WL(29), .WL_out(30)) A_n6_s6 (
    .ar(a_n7_s5_r), .ai(a_n7_s5_i), .br(a_n9_s5_r), .bi(a_n9_s5_i),
    .cr(a_n6_s6_r), .ci(a_n6_s6_i)
);
ComplexAdder #(.WL(29), .WL_out(30)) A_n7_s6 (
    .ar(a_n7_s5_r), .ai(a_n7_s5_i), .br(a_n11_s5_r), .bi(a_n11_s5_i),
    .cr(a_n7_s6_r), .ci(a_n7_s6_i)
);
ComplexAdder #(.WL(29), .WL_out(30)) A_n8_s6 (
    .ar(a_n8_s5_r), .ai(a_n8_s5_i), .br(a_n10_s5_r), .bi(a_n10_s5_i),
    .cr(a_n8_s6_r), .ci(a_n8_s6_i)
);
ComplexAdder #(.WL(29), .WL_out(30)) A_n9_s6 (
    .ar(a_n8_s5_r), .ai(a_n8_s5_i), .br(a_n12_s5_r), .bi(a_n12_s5_i),
    .cr(a_n9_s6_r), .ci(a_n9_s6_i)
);

/////////////////////////////////////
//        Pipeline stage 04       //
/////////////////////////////////////

// Pipeline output  Stage01
reg signed [28:0] a_n1_s6_r_d;
reg signed [28:0] a_n1_s6_i_d;
reg signed [29:0] a_n2_s6_r_d, a_n3_s6_r_d, a_n4_s6_r_d, a_n5_s6_r_d, a_n6_s6_r_d, a_n7_s6_r_d, a_n8_s6_r_d, a_n9_s6_r_d;
reg signed [29:0] a_n2_s6_i_d, a_n3_s6_i_d, a_n4_s6_i_d, a_n5_s6_i_d, a_n6_s6_i_d, a_n7_s6_i_d, a_n8_s6_i_d, a_n9_s6_i_d;
reg signed [27:0] m_n2_r_d_d;
reg signed [27:0] m_n2_i_d_d;
reg signed [27:0] a_n1_s4_r_d_d_exp_d, a_n1_s4_i_d_d_exp_d;


always @ (posedge clk) begin
    if (reset) begin
        a_n1_s6_r_d <= 0;
        a_n1_s6_i_d <= 0;
        a_n2_s6_r_d <= 0;
        a_n3_s6_r_d <= 0;
        a_n4_s6_r_d <= 0;
        a_n5_s6_r_d <= 0;
        a_n6_s6_r_d <= 0;
        a_n7_s6_r_d <= 0;
        a_n8_s6_r_d <= 0;
        a_n9_s6_r_d <= 0;
        a_n2_s6_i_d <= 0;
        a_n3_s6_i_d <= 0;
        a_n4_s6_i_d <= 0;
        a_n5_s6_i_d <= 0;
        a_n6_s6_i_d <= 0;
        a_n7_s6_i_d <= 0;
        a_n8_s6_i_d <= 0;
        a_n9_s6_i_d <= 0;
        m_n2_r_d_d <= 0;
        m_n2_i_d_d <= 0;
        a_n1_s4_r_d_d_exp_d <= 0;
        a_n1_s4_i_d_d_exp_d <= 0;
    end
    else begin
        a_n1_s6_r_d <= a_n1_s6_r;
        a_n1_s6_i_d <= a_n1_s6_i;
        a_n2_s6_r_d <= a_n2_s6_r;
        a_n3_s6_r_d <= a_n3_s6_r;
        a_n4_s6_r_d <= a_n4_s6_r;
        a_n5_s6_r_d <= a_n5_s6_r;
        a_n6_s6_r_d <= a_n6_s6_r;
        a_n7_s6_r_d <= a_n7_s6_r;
        a_n8_s6_r_d <= a_n8_s6_r;
        a_n9_s6_r_d <= a_n9_s6_r;
        a_n2_s6_i_d <= a_n2_s6_i;
        a_n3_s6_i_d <= a_n3_s6_i;
        a_n4_s6_i_d <= a_n4_s6_i;
        a_n5_s6_i_d <= a_n5_s6_i;
        a_n6_s6_i_d <= a_n6_s6_i;
        a_n7_s6_i_d <= a_n7_s6_i;
        a_n8_s6_i_d <= a_n8_s6_i;
        a_n9_s6_i_d <= a_n9_s6_i;
        m_n2_r_d_d <= m_n2_r_d;
        m_n2_i_d_d <= m_n2_i_d;
        a_n1_s4_r_d_d_exp_d <= a_n1_s4_r_d_d_exp;
        a_n1_s4_i_d_d_exp_d <= a_n1_s4_i_d_d_exp;
    end
end

/////////////////////////////////////
//       Seventh stage adder       //
/////////////////////////////////////

// seventh stage adder tree output
wire signed [30:0] a_n5_1_s7_r, a_n5_2_s7_r, a_n10_1_s7_r, a_n10_2_s7_r;
wire signed [30:0] a_n5_1_s7_i, a_n5_2_s7_i, a_n10_1_s7_i, a_n10_2_s7_i;
wire signed [31:0] a_n5_3_s7_r, a_n10_3_s7_r;
wire signed [31:0] a_n5_3_s7_i, a_n10_3_s7_i;
wire signed [32:0] a_n5_4_s7_r, a_n10_4_s7_r;
wire signed [32:0] a_n5_4_s7_i, a_n10_4_s7_i;

// seventh stage adder output
wire signed [30:0] a_n1_s7_r, a_n2_s7_r, a_n3_s7_r, a_n4_s7_r, a_n6_s7_r, a_n7_s7_r, a_n8_s7_r, a_n9_s7_r;
wire signed [30:0] a_n1_s7_i, a_n2_s7_i, a_n3_s7_i, a_n4_s7_i, a_n6_s7_i, a_n7_s7_i, a_n8_s7_i, a_n9_s7_i;

// seventh stage adder input inverse
wire signed [29:0] a_n2_s6_r_d_inv, a_n3_s6_r_d_inv, a_n4_s6_r_d_inv, a_n5_s6_r_d_inv, a_n6_s6_r_d_inv, a_n7_s6_r_d_inv, a_n8_s6_r_d_inv, a_n9_s6_r_d_inv;
wire signed [29:0] a_n2_s6_i_d_inv, a_n3_s6_i_d_inv, a_n4_s6_i_d_inv, a_n5_s6_i_d_inv, a_n6_s6_i_d_inv, a_n7_s6_i_d_inv, a_n8_s6_i_d_inv, a_n9_s6_i_d_inv;

assign a_n2_s6_r_d_inv = -a_n2_s6_r_d;
assign a_n3_s6_r_d_inv = -a_n3_s6_r_d;
assign a_n4_s6_r_d_inv = -a_n4_s6_r_d;
assign a_n5_s6_r_d_inv = -a_n5_s6_r_d;
assign a_n6_s6_r_d_inv = -a_n6_s6_r_d;
assign a_n7_s6_r_d_inv = -a_n7_s6_r_d;
assign a_n8_s6_r_d_inv = -a_n8_s6_r_d;
assign a_n9_s6_r_d_inv = -a_n9_s6_r_d;

assign a_n2_s6_i_d_inv = -a_n2_s6_i_d;
assign a_n3_s6_i_d_inv = -a_n3_s6_i_d;
assign a_n4_s6_i_d_inv = -a_n4_s6_i_d;
assign a_n5_s6_i_d_inv = -a_n5_s6_i_d;
assign a_n6_s6_i_d_inv = -a_n6_s6_i_d;
assign a_n7_s6_i_d_inv = -a_n7_s6_i_d;
assign a_n8_s6_i_d_inv = -a_n8_s6_i_d;
assign a_n9_s6_i_d_inv = -a_n9_s6_i_d;

// seventh stage adder tree
ComplexAdder #(.WL(30), .WL_out(31)) A_n5_1_s7 (
    .ar({{{a_n1_s6_r_d[28]}},a_n1_s6_r_d}), .ai({{{a_n1_s6_i_d[28]}},a_n1_s6_i_d}), .br(a_n2_s6_r_d_inv), .bi(a_n2_s6_i_d_inv),
    .cr(a_n5_1_s7_r), .ci(a_n5_1_s7_i)
);
ComplexAdder #(.WL(30), .WL_out(31)) A_n5_2_s7 (
    .ar(a_n3_s6_r_d_inv), .ai(a_n3_s6_i_d_inv), .br(a_n4_s6_r_d_inv), .bi(a_n4_s6_i_d_inv),
    .cr(a_n5_2_s7_r), .ci(a_n5_2_s7_i)
);
ComplexAdder #(.WL(31), .WL_out(32)) A_n5_3_s7 (
    .ar(a_n5_1_s7_r), .ai(a_n5_1_s7_i), .br(a_n5_2_s7_r), .bi(a_n5_2_s7_i),
    .cr(a_n5_3_s7_r), .ci(a_n5_3_s7_i)
);
ComplexAdder #(.WL(32), .WL_out(33)) A_n5_4_s7 (
    .ar(a_n5_3_s7_r), .ai(a_n5_3_s7_i), .br({{2{a_n5_s6_r_d_inv[29]}},a_n5_s6_r_d_inv}), .bi({{2{a_n5_s6_i_d_inv[29]}},a_n5_s6_i_d_inv}),
    .cr(a_n5_4_s7_r), .ci(a_n5_4_s7_i)
);
ComplexAdder #(.WL(30), .WL_out(31)) A_n10_1_s7 (
    .ar({{2{m_n2_r_d_d[27]}},m_n2_r_d_d}), .ai({{2{m_n2_i_d_d[27]}},m_n2_i_d_d}), .br(a_n6_s6_r_d_inv), .bi(a_n6_s6_i_d_inv),
    .cr(a_n10_1_s7_r), .ci(a_n10_1_s7_i)
);
ComplexAdder #(.WL(30), .WL_out(31)) A_n10_2_s7 (
    .ar(a_n7_s6_r_d_inv), .ai(a_n7_s6_i_d_inv), .br(a_n8_s6_r_d_inv), .bi(a_n8_s6_i_d_inv),
    .cr(a_n10_2_s7_r), .ci(a_n10_2_s7_i)
);
ComplexAdder #(.WL(31), .WL_out(32)) A_n10_3_s7 (
    .ar(a_n10_1_s7_r), .ai(a_n10_1_s7_i), .br(a_n10_2_s7_r), .bi(a_n10_2_s7_i),
    .cr(a_n10_3_s7_r), .ci(a_n10_3_s7_i)
);
ComplexAdder #(.WL(32), .WL_out(33)) A_n10_4_s7 (
    .ar(a_n10_3_s7_r), .ai(a_n10_3_s7_i), .br({{2{a_n9_s6_r_d_inv[29]}},a_n9_s6_r_d_inv}), .bi({{2{a_n9_s6_i_d_inv[29]}},a_n9_s6_i_d_inv}),
    .cr(a_n10_4_s7_r), .ci(a_n10_4_s7_i)
);

// seventh stage adder
ComplexAdder #(.WL(30), .WL_out(31)) A_n1_s7 (
    .ar({{{a_n1_s6_r_d[28]}},a_n1_s6_r_d}), .ai({{{a_n1_s6_i_d[28]}},a_n1_s6_i_d}), .br(a_n2_s6_r_d), .bi(a_n2_s6_i_d),
    .cr(a_n1_s7_r), .ci(a_n1_s7_i)
);
ComplexAdder #(.WL(30), .WL_out(31)) A_n2_s7 (
    .ar({{{a_n1_s6_r_d[28]}},a_n1_s6_r_d}), .ai({{{a_n1_s6_i_d[28]}},a_n1_s6_i_d}), .br(a_n3_s6_r_d), .bi(a_n3_s6_i_d),
    .cr(a_n2_s7_r), .ci(a_n2_s7_i)
);
ComplexAdder #(.WL(30), .WL_out(31)) A_n3_s7 (
    .ar({{{a_n1_s6_r_d[28]}},a_n1_s6_r_d}), .ai({{{a_n1_s6_i_d[28]}},a_n1_s6_i_d}), .br(a_n4_s6_r_d), .bi(a_n4_s6_i_d),
    .cr(a_n3_s7_r), .ci(a_n3_s7_i)
);
ComplexAdder #(.WL(30), .WL_out(31)) A_n4_s7 (
    .ar({{{a_n1_s6_r_d[28]}},a_n1_s6_r_d}), .ai({{{a_n1_s6_i_d[28]}},a_n1_s6_i_d}), .br(a_n5_s6_r_d), .bi(a_n5_s6_i_d),
    .cr(a_n4_s7_r), .ci(a_n4_s7_i)
);
ComplexAdder #(.WL(30), .WL_out(31)) A_n6_s7 (
    .ar({{2{m_n2_r_d_d[27]}},m_n2_r_d_d}), .ai({{2{m_n2_i_d_d[27]}},m_n2_i_d_d}), .br(a_n9_s6_r_d), .bi(a_n9_s6_i_d),
    .cr(a_n6_s7_r), .ci(a_n6_s7_i)
);
ComplexAdder #(.WL(30), .WL_out(31)) A_n7_s7 (
    .ar({{2{m_n2_r_d_d[27]}},m_n2_r_d_d}), .ai({{2{m_n2_i_d_d[27]}},m_n2_i_d_d}), .br(a_n8_s6_r_d), .bi(a_n8_s6_i_d),
    .cr(a_n7_s7_r), .ci(a_n7_s7_i)
);
ComplexAdder #(.WL(30), .WL_out(31)) A_n8_s7 (
    .ar({{2{m_n2_r_d_d[27]}},m_n2_r_d_d}), .ai({{2{m_n2_i_d_d[27]}},m_n2_i_d_d}), .br(a_n7_s6_r_d), .bi(a_n7_s6_i_d),
    .cr(a_n8_s7_r), .ci(a_n8_s7_i)
);
ComplexAdder #(.WL(30), .WL_out(31)) A_n9_s7 (
    .ar({{2{m_n2_r_d_d[27]}},m_n2_r_d_d}), .ai({{2{m_n2_i_d_d[27]}},m_n2_i_d_d}), .br(a_n6_s6_r_d), .bi(a_n6_s6_i_d),
    .cr(a_n9_s7_r), .ci(a_n9_s7_i)
);

/////////////////////////////////////
//        Eighth stage adder       //
/////////////////////////////////////

// eighth stage adder input inverse
wire signed [30:0] a_n6_s7_r_inv, a_n7_s7_r_inv, a_n8_s7_r_inv, a_n9_s7_r_inv;
wire signed [30:0] a_n6_s7_i_inv, a_n7_s7_i_inv, a_n8_s7_i_inv, a_n9_s7_i_inv;
wire signed [32:0] a_n10_s7_r_inv;
wire signed [32:0] a_n10_s7_i_inv;

assign a_n6_s7_r_inv = -a_n6_s7_r;
assign a_n7_s7_r_inv = -a_n7_s7_r;
assign a_n8_s7_r_inv = -a_n8_s7_r;
assign a_n9_s7_r_inv = -a_n9_s7_r;
assign a_n10_s7_r_inv = -a_n10_4_s7_r;

assign a_n6_s7_i_inv = -a_n6_s7_i;
assign a_n7_s7_i_inv = -a_n7_s7_i;
assign a_n8_s7_i_inv = -a_n8_s7_i;
assign a_n9_s7_i_inv = -a_n9_s7_i;
assign a_n10_s7_i_inv = -a_n10_4_s7_i;

// eighth stage adder
ComplexAdder #(.WL(31), .WL_out(34)) A_n1_s8 (
    .ar(a_n1_s7_r), .ai(a_n1_s7_i), .br(a_n6_s7_r), .bi(a_n6_s7_i),
    .cr(X2_r), .ci(X2_i)
);
ComplexAdder #(.WL(31), .WL_out(34)) A_n2_s8 (
    .ar(a_n2_s7_r), .ai(a_n2_s7_i), .br(a_n7_s7_r), .bi(a_n7_s7_i),
    .cr(X7_r), .ci(X7_i)
);
ComplexAdder #(.WL(31), .WL_out(34)) A_n3_s8 (
    .ar(a_n3_s7_r), .ai(a_n3_s7_i), .br(a_n8_s7_r), .bi(a_n8_s7_i),
    .cr(X8_r), .ci(X8_i)
);
ComplexAdder #(.WL(31), .WL_out(34)) A_n4_s8 (
    .ar(a_n4_s7_r), .ai(a_n4_s7_i), .br(a_n9_s7_r), .bi(a_n9_s7_i),
    .cr(X6_r), .ci(X6_i)
);
ComplexAdder #(.WL(33), .WL_out(34)) A_n5_s8 (
    .ar(a_n5_4_s7_r), .ai(a_n5_4_s7_i), .br(a_n10_4_s7_r), .bi(a_n10_4_s7_i),
    .cr(X10_r), .ci(X10_i)
);
ComplexAdder #(.WL(31), .WL_out(34)) A_n6_s8 (
    .ar(a_n1_s7_r), .ai(a_n1_s7_i), .br(a_n6_s7_r_inv), .bi(a_n6_s7_i_inv),
    .cr(X9_r), .ci(X9_i)
);
ComplexAdder #(.WL(31), .WL_out(34)) A_n7_s8 (
    .ar(a_n2_s7_r), .ai(a_n2_s7_i), .br(a_n7_s7_r_inv), .bi(a_n7_s7_i_inv),
    .cr(X4_r), .ci(X4_i)
);
ComplexAdder #(.WL(31), .WL_out(34)) A_n8_s8 (
    .ar(a_n3_s7_r), .ai(a_n3_s7_i), .br(a_n8_s7_r_inv), .bi(a_n8_s7_i_inv),
    .cr(X3_r), .ci(X3_i)
);
ComplexAdder #(.WL(31), .WL_out(34)) A_n9_s8 (
    .ar(a_n4_s7_r), .ai(a_n4_s7_i), .br(a_n9_s7_r_inv), .bi(a_n9_s7_i_inv),
    .cr(X5_r), .ci(X5_i)
);
ComplexAdder #(.WL(33), .WL_out(34)) A_n10_s8 (
    .ar(a_n5_4_s7_r), .ai(a_n5_4_s7_i), .br(a_n10_s7_r_inv), .bi(a_n10_s7_i_inv),
    .cr(X1_r), .ci(X1_i)
);

assign X0_r = {{6{a_n1_s4_r_d_d_exp_d[27]}},a_n1_s4_r_d_d_exp_d};
assign X0_i = {{6{a_n1_s4_i_d_d_exp_d[27]}},a_n1_s4_i_d_d_exp_d};

/////////////////////////////////////
//    counter for finish signal    //
/////////////////////////////////////
reg [2:0] state_counter, finish_counter;
wire [2:0] state_counter_In, finish_counter_In;

assign state_counter_In = (state_counter == 3'b100)?(3'b100):(state_counter+1);
assign finish_counter_In = ((~(load|1'b0)) & (valid & 1'b1))?(((finish_counter == 3'b100))?(3'b100):(finish_counter+1)):(3'b000);   //finish_counter_In = (load == 1'b0 && valid == 1'b1);

always @ (posedge clk) begin
    if (reset) begin
        state_counter <= 0;
        finish_counter <= 0;
    end
    else begin
        state_counter <= state_counter_In;
        finish_counter <= finish_counter_In;
    end
end

always @ (*) begin
case(state_counter)
    3'b100: valid = (finish_counter == 3'b100)?1'b0: 1'b1;
    default: valid = 1'b0;
endcase
end
// issue: next input srting is provided before valid down.



endmodule

//sub module

module ComplexAdder
#(parameter WL=14, WL_out=15)
(   input signed [WL-1:0] ar, ai, br, bi,
    output signed [WL_out-1:0] cr, ci
    );


//Real part
assign cr = ar+br;

//Imaginary part
assign ci = ai+bi;


endmodule

module ComplexMul_coef_Real
#(parameter WL=14, WL_out=28)
(   input signed [WL-1:0] ar, ai, br,
    output signed [WL_out-1:0] cr, ci
    );


//Real part
assign cr = ar*br;

//Imaginary part
assign ci = ai*br;

endmodule

module ComplexMul_coef_Imag
#(parameter WL=14, WL_out=28)
(   input signed [WL-1:0] ar, ai, bi,
    output signed [WL_out-1:0] cr, ci
    );


//Real part
assign cr = ai*(-bi);

//Imaginary part
assign ci = ar*bi;
 
endmodule