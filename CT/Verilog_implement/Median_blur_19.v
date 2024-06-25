`timescale 1ns/10ps
//////////////////////////////////////////////////////////////////////////////////
// Median blur with 19 PEs
// Structure: Systolic array
// Kernel size: 3x3
//
// Author: Abbiter Liu
//////////////////////////////////////////////////////////////////////////////////

module  Median_blur_19(
    input  [7:0] px_1, px_2, px_3, px_4, px_5, px_6, px_7, px_8, px_9,
    output  [7:0] out
	);

wire  [7:0] h3_1, h3_2, h3_3, h3_4, h3_5;
wire  [7:0] m3_1, m3_2, m3_3, m3_4;
wire  [7:0] l3_1, l3_2, l3_3, l3_4, l3_5;

wire  [7:0] h2_1, h2_2, h2_3, h2_4;
wire  [7:0] l2_1, l2_2, l2_3, l2_4;

Compare_node_3I3O u1(
    .in_1(px_1), .in_2(px_2), .in_3(px_3),
    .high(h3_1), .mid(m3_1), .low(l3_1)
);

Compare_node_3I3O u2(
    .in_1(px_4), .in_2(px_5), .in_3(px_6),
    .high(h3_2), .mid(m3_2), .low(l3_2)
);

Compare_node_3I3O u3(
    .in_1(px_7), .in_2(px_8), .in_3(px_9),
    .high(h3_3), .mid(m3_3), .low(l3_3)
);

Compare_node_2I2O u4(
    .in_1(h3_1), .in_2(h3_2),
    .high(h2_1), .low(l2_1)
);

Compare_node_2I2O u5(
    .in_1(l2_1), .in_2(h3_3),
    .high(h2_2), .low(l2_2)
);

Compare_node_3I3O u6(
    .in_1(m3_1), .in_2(m3_2), .in_3(m3_3),
    .high(h3_4), .mid(m3_4), .low(l3_4)
);

Compare_node_2I2O u7(
    .in_1(l3_1), .in_2(h2_4),
    .high(h2_3), .low(l2_3)
);

Compare_node_2I2O u8(
    .in_1(l3_2), .in_2(l3_3),
    .high(h2_4), .low(l2_4)
);

Compare_node_3I3O u9(
    .in_1(l2_2), .in_2(m3_4), .in_3(h2_3),
    .high(h3_5), .mid(out), .low(l3_5)
);

endmodule

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
    input  [7:0] in_1, in_2,
    output  [7:0] high, low
	);

wire higher;

assign higher = (in_1>=in_2)? 1'b1:1'b0;

assign high = (higher==1'b1)? in_1:in_2;
assign low = (higher==1'b1)? in_2:in_1;

endmodule