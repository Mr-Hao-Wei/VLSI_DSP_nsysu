`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 5-bit Multiplier
// Structure: 5-bit Multiplier with accumulate adder
//
// Author: Abbiter Liu
//////////////////////////////////////////////////////////////////////////////////

module Mul_5bits (
    input clk,
    input reset,
    input [4:0] a,
    input [4:0] b,
    output [9:0] s
);


wire sel;
wire [4:0] a_in;
wire [9:0] acc_out;

reg b_in;
reg [2:0] count;
reg [9:0] a_in_shift;
reg [9:0] acc_in;
reg [9:0] adder_in;

always @(posedge clk ) begin
    if(reset)
        count <= 3'd0;
    else if(count >= 3'd4) 
        count <= 3'd0;  
    else 
        count <= count + 1;
end

always @(*) begin
    case (count)
        3'd0: b_in <= b[0];
        3'd1: b_in <= b[1];
        3'd2: b_in <= b[2];
        3'd3: b_in <= b[3];
        3'd4: b_in <= b[4];
        default: b_in <= 1'b0;
    endcase
end

assign sel = (b_in)?1'b1:1'b0;

assign a_in = (sel)?a:5'd0;

always @(*) begin
    case (count)
        3'd0: a_in_shift <= {5'd0,a_in};
        3'd1: a_in_shift <= {4'd0,a_in,1'd0};
        3'd2: a_in_shift <= {3'd0,a_in,2'd0};
        3'd3: a_in_shift <= {2'd0,a_in,3'd0};
        3'd4: a_in_shift <= {1'd0,a_in,4'd0};
        default: a_in_shift <= 10'd0;
    endcase
end

always @(posedge clk ) begin
    if(reset)
        acc_in <= 10'd0;
    else
        acc_in <= acc_out;
end

always @(*) begin
    case (count)
        3'd0: adder_in <= 10'd0;
        default: adder_in <= acc_in;
    endcase      
end

assign acc_out = adder_in + a_in_shift;

assign s = (count==3'd4)?acc_out:10'd0;

endmodule