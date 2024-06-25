`timescale 1ns/10ps
//////////////////////////////////////////////////////////////////////////////////
// Sorting PE 3I3O
// Structure: Systolic array PE (3*2I2O)
// Class: high, median, low
//
// Author: Abbiter Liu
//////////////////////////////////////////////////////////////////////////////////

module  Compare_node_3I3O(
    input  [7:0] in_1, in_2, in_3,
    output  [7:0] high, mid, low
	);

wire  [7:0] high_1, low_1, high_2;

Compare_node_2I2O u1(
    .in_1(in_1), .in_2(in_2),
    .high(high_1), .low(low_1)
);

Compare_node_2I2O u2(
    .in_1(low_1), .in_2(in_3),
    .high(high_2), .low(low)
);

Compare_node_2I2O u3(
    .in_1(high_1), .in_2(high_2),
    .high(high), .low(mid)
);

endmodule


module  Compare_node_2I2O(
    input signed [7:0] in_1, in_2,
    output signed [7:0] high, low
	);

wire higher;

assign higher = (in_1>=in_2)? 1'b1:1'b0;

assign high = (higher==1'b1)? in_1:in_2;
assign low = (higher==1'b1)? in_2:in_1;

endmodule