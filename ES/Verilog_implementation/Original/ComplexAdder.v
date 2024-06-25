`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Complex Adder
// Structure: 2A Complex Adder
//
// Author: JY Chen
//////////////////////////////////////////////////////////////////////////////////


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

