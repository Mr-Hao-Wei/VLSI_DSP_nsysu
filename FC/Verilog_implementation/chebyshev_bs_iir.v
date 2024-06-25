`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// IIR Chebyshev bandstop filter
// Structure: IIR Cascaded Second-Order Sections Direct Form II
// Total order: 6
// Cut-off freq.: 60 Hz
// Sampling freq.: 360 Hz
//
// Author: Abbiter Liu
//////////////////////////////////////////////////////////////////////////////////

module chebyshev_bs_iir 
#(parameter WL=28) //int:16 fraction:12
(   input clk, 
    input reset, 
    input signed [WL-1:0] x, 
    output signed [WL-1:0] y
    );


// filter coefficients
wire signed [WL-1:0] a1_n1, a2_n1, a1_n2, a2_n2, a1_n3, a2_n3,
                     b0_n1, b1_n1, b2_n1, b0_n2, b1_n2, b2_n2, b0_n3, b1_n3, b2_n3;

// filter variables
wire signed [2*WL:0] a_n1_out, a_n2_out, a_n3_out;
wire signed [2*WL:0] b_n1_out, b_n2_out, b_n3_out;
wire signed [2*WL-1:0] a1_n1_out, a2_n1_out, a1_n2_out, a2_n2_out, a1_n3_out, a2_n3_out;
wire signed [2*WL-1:0] b0_n1_out, b1_n1_out, b2_n1_out, b0_n2_out, b1_n2_out, b2_n2_out, b0_n3_out, b1_n3_out, b2_n3_out;

// filter regs
reg signed [WL-1:0] f1_n1, f2_n1, f1_n2, f2_n2, f1_n3, f2_n3; 

// filter regs inputs
wire signed [WL-1:0] f1_n1_input, f1_n2_input, f1_n3_input;

// temporary filter input/output
wire signed [WL-1:0] y_temp1, y_temp2;

// scaling input/output bits
wire signed [2*WL:0] x_scale, y_temp1_scale, y_temp2_scale;


// filter coefficients values
assign a1_n1 = -28'd3915;
assign a2_n1 = 28'd4006;
assign a1_n2 = -28'd4185;
assign a2_n2 = 28'd4008;
assign a1_n3 = -28'd4008;
assign a2_n3 = 28'd3920;


assign b0_n1 = 28'd4051;
assign b1_n1 = -28'd4072;
assign b2_n1 = 28'd4051;
assign b0_n2 = 28'd4051;
assign b1_n2 = -28'd4029;
assign b2_n2 = 28'd4051;
assign b0_n3 = 28'd4008;
assign b1_n3 = -28'd4008;
assign b2_n3 = 28'd4008;

// update filter variables
assign b0_n1_out = b0_n1*f1_n1_input;
assign b1_n1_out = b1_n1*f1_n1;
assign b2_n1_out = b2_n1*f2_n1;
assign b0_n2_out = b0_n2*f1_n2_input;
assign b1_n2_out = b1_n2*f1_n2;
assign b2_n2_out = b2_n2*f2_n2;
assign b0_n3_out = b0_n3*f1_n3_input;
assign b1_n3_out = b1_n3*f1_n3;
assign b2_n3_out = b2_n3*f2_n3;


assign a1_n1_out = a1_n1*f1_n1;
assign a2_n1_out = a2_n1*f2_n1;
assign a1_n2_out = a1_n2*f1_n2;
assign a2_n2_out = a2_n2*f2_n2;
assign a1_n3_out = a1_n3*f1_n3;
assign a2_n3_out = a2_n3*f2_n3;


// add/scale/truncate operations
assign a_n1_out = a1_n1_out + a2_n1_out;
assign x_scale = {{29{x[27]}},x} << 12;
assign f1_n1_input = (x_scale - a_n1_out) >>> 12;
assign b_n1_out = b0_n1_out + b1_n1_out + b2_n1_out;
assign y_temp1 = b_n1_out >>> 12;

assign a_n2_out = a1_n2_out + a2_n2_out;
assign y_temp1_scale = {{29{y_temp1[27]}},y_temp1} << 12;
assign f1_n2_input = (y_temp1_scale - a_n2_out) >>> 12;
assign b_n2_out = b0_n2_out + b1_n2_out + b2_n2_out;
assign y_temp2 = b_n2_out >>> 12;

assign a_n3_out = a1_n3_out + a2_n3_out;
assign y_temp2_scale = {{29{y_temp2[27]}},y_temp2} << 12;
assign f1_n3_input = (y_temp2_scale - a_n3_out) >>> 12;
assign b_n3_out = b0_n3_out + b1_n3_out + b2_n3_out;
assign y = b_n3_out >>> 12;


// Run the filter state machine at signal sample rate
always @ (negedge clk) 
begin
    if (reset) begin
        f1_n1 <= 0;
        f2_n1 <= 0; 
        f1_n2 <= 0;
        f2_n2 <= 0;
        f1_n3 <= 0;
        f2_n3 <= 0;         
    end
    else begin
        f1_n1 <= f1_n1_input;
        f2_n1 <= f1_n1; 
        f1_n2 <= f1_n2_input;
        f2_n2 <= f1_n2;
        f1_n3 <= f1_n3_input;
        f2_n3 <= f1_n3;          
    end
end 
endmodule
