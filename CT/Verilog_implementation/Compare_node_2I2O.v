`timescale 1ns/10ps
//////////////////////////////////////////////////////////////////////////////////
// Sorting PE 2I2O
// Structure: Systolic array PE
// Class: high(>=), low(<)
//
// Author: Abbiter Liu
//////////////////////////////////////////////////////////////////////////////////

module  Compare_node_2I2O(
    input  [7:0] in_1, in_2,
    output  [7:0] high, low
	);

wire higher;

assign higher = (in_1>=in_2)? 1'b1:1'b0;

assign high = (higher==1'b1)? in_1:in_2;
assign low = (higher==1'b1)? in_2:in_1;

endmodule