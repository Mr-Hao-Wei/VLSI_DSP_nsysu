`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Complex Multiplier Real Coefficent
// Structure: Complex Multiplier - coefficent is Pure Real Number
//
// Author: JY Chen
//////////////////////////////////////////////////////////////////////////////////


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
