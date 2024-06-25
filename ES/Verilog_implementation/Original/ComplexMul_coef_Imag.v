`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Complex Multiplier Imaginary Coefficent
// Structure: Complex Multiplier - coefficent is Pure Imaginary Number
//
// Author: JY Chen
//////////////////////////////////////////////////////////////////////////////////


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
