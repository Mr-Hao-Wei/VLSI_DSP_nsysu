`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 5-bit Multiplier
// Structure: 5-bit Multiplier with accumulate adder and unfolding factor 5
//
// Author: Abbiter Liu
//////////////////////////////////////////////////////////////////////////////////

module Mul_5bits_J5 (
    input clk,
    input reset,
    input [4:0] a,
    input [4:0] b,
    output reg [9:0] s
);


wire sel_0, sel_1, sel_2, sel_3, sel_4;
wire [4:0] a_in_0, a_in_1, a_in_2, a_in_3, a_in_4;
wire [9:0] acc_out_0, acc_out_1, acc_out_2, acc_out_3, acc_out_4;

reg b_in_0, b_in_1, b_in_2, b_in_3, b_in_4;
//reg [2:0] count;
wire [9:0] a_in_shift_0, a_in_shift_1, a_in_shift_2, a_in_shift_3, a_in_shift_4;
// reg [9:0] acc_in;
//reg [9:0] adder_in_0;

always @(posedge clk ) begin
    if (reset) begin
        b_in_0 <= 1'b0;
        b_in_1 <= 1'b0;
        b_in_2 <= 1'b0;
        b_in_3 <= 1'b0;
        b_in_4 <= 1'b0;
    end
    else begin
        b_in_0 <= b[0];
        b_in_1 <= b[1];
        b_in_2 <= b[2];
        b_in_3 <= b[3];
        b_in_4 <= b[4];
    end
end

assign sel_0 = (b_in_0)?1'b1:1'b0;
assign sel_1 = (b_in_1)?1'b1:1'b0;
assign sel_2 = (b_in_2)?1'b1:1'b0;
assign sel_3 = (b_in_3)?1'b1:1'b0;
assign sel_4 = (b_in_4)?1'b1:1'b0;

assign a_in_0 = (sel_0)?a:5'd0;
assign a_in_1 = (sel_1)?a:5'd0;
assign a_in_2 = (sel_2)?a:5'd0;
assign a_in_3 = (sel_3)?a:5'd0;
assign a_in_4 = (sel_4)?a:5'd0;

assign a_in_shift_0 = {5'd0,a_in_0};
assign a_in_shift_1 = {4'd0,a_in_1,1'd0};
assign a_in_shift_2 = {3'd0,a_in_2,2'd0};
assign a_in_shift_3 = {2'd0,a_in_3,3'd0};
assign a_in_shift_4 = {1'd0,a_in_4,4'd0};

// always @(posedge clk ) begin
//     if(reset)
//         acc_in <= 10'd0;
//     else
//         acc_in <= acc_out_4;
// end

assign acc_out_0 = 10'd0 + a_in_shift_0;
assign acc_out_1 = acc_out_0 + a_in_shift_1;
assign acc_out_2 = acc_out_1 + a_in_shift_2;
assign acc_out_3 = acc_out_2 + a_in_shift_3;
assign acc_out_4 = acc_out_3 + a_in_shift_4;

// assign s = acc_out_4;

always @(posedge clk ) begin
    if (reset)
        s <= 10'd0;
    else 
        s <= acc_out_4;
end

endmodule