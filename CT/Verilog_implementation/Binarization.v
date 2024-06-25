`timescale 1ns/10ps
//////////////////////////////////////////////////////////////////////////////////
// Binarization 
// Threshold: 0~255
// Max: 255 (white)
// Min: 0   (black)
//
// Author: Abbiter Liu
//////////////////////////////////////////////////////////////////////////////////

module  Binarization(
    input [7:0] threshold,
    input [16:0] in,
    output [7:0] out
	);

assign out = (in>=threshold)? 8'd255:8'd0;

endmodule
