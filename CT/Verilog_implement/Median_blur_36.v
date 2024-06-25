`timescale 1ns/10ps
//////////////////////////////////////////////////////////////////////////////////
// Median blur with 36 PEs
// Structure: Systolic array
// Kernel size: 3x3
//
// Author: Abbiter Liu
//////////////////////////////////////////////////////////////////////////////////

module  Median_blur_36(
    input  [7:0] px_1, px_2, px_3, px_4, px_5, px_6, px_7, px_8, px_9,
    output  [7:0] out
	);

wire  [7:0] h_1, h_2, h_3, h_4, h_5, h_6, h_7, h_8, h_9, h_10, h_11, h_12, h_13, h_14, h_15, h_16, h_17, h_18,
                  h_19, h_20, h_21, h_22, h_23, h_24, h_25, h_26, h_27, h_28, h_29, h_30, h_31, h_32, h_33, h_34, h_36;
wire  [7:0] l_1, l_2, l_3, l_4, l_5, l_6, l_7, l_8, l_9, l_10, l_11, l_12, l_13, l_14, l_15, l_16, l_17, l_18,
                  l_19, l_20, l_21, l_22, l_23, l_24, l_25, l_26, l_27, l_28, l_29, l_30, l_31, l_32, l_33, l_34, l_35, l_36;

Compare_node_2I2O u1(
    .in_1(px_1), .in_2(px_2),
    .high(h_1), .low(l_1)
);

Compare_node_2I2O u2(
    .in_1(px_3), .in_2(px_4),
    .high(h_2), .low(l_2)
);

Compare_node_2I2O u3(
    .in_1(px_5), .in_2(px_6),
    .high(h_3), .low(l_3)
);

Compare_node_2I2O u4(
    .in_1(px_7), .in_2(px_8),
    .high(h_4), .low(l_4)
);

Compare_node_2I2O u5(
    .in_1(l_1), .in_2(h_2),
    .high(h_5), .low(l_5)
);

Compare_node_2I2O u6(
    .in_1(l_2), .in_2(h_3),
    .high(h_6), .low(l_6)
);

Compare_node_2I2O u7(
    .in_1(l_3), .in_2(h_4),
    .high(h_7), .low(l_7)
);

Compare_node_2I2O u8(
    .in_1(l_4), .in_2(px_9),
    .high(h_8), .low(l_8)
);

Compare_node_2I2O u9(
    .in_1(h_1), .in_2(h_5),
    .high(h_9), .low(l_9)
);

Compare_node_2I2O u10(
    .in_1(l_5), .in_2(h_6),
    .high(h_10), .low(l_10)
);

Compare_node_2I2O u11(
    .in_1(l_6), .in_2(h_7),
    .high(h_11), .low(l_11)
);

Compare_node_2I2O u12(
    .in_1(l_7), .in_2(h_8),
    .high(h_12), .low(l_12)
);

Compare_node_2I2O u13(
    .in_1(l_9), .in_2(h_10),
    .high(h_13), .low(l_13)
);

Compare_node_2I2O u14(
    .in_1(l_10), .in_2(h_11),
    .high(h_14), .low(l_14)
);

Compare_node_2I2O u15(
    .in_1(l_11), .in_2(h_12),
    .high(h_15), .low(l_15)
);

Compare_node_2I2O u16(
    .in_1(l_12), .in_2(l_8),
    .high(h_16), .low(l_16)
);

Compare_node_2I2O u17(
    .in_1(h_9), .in_2(h_13),
    .high(h_17), .low(l_17)
);

Compare_node_2I2O u18(
    .in_1(l_13), .in_2(h_14),
    .high(h_18), .low(l_18)
);

Compare_node_2I2O u19(
    .in_1(l_14), .in_2(h_15),
    .high(h_19), .low(l_19)
);

Compare_node_2I2O u20(
    .in_1(l_15), .in_2(h_16),
    .high(h_20), .low(l_20)
);

Compare_node_2I2O u21(
    .in_1(l_17), .in_2(h_18),
    .high(h_21), .low(l_21)
);

Compare_node_2I2O u22(
    .in_1(l_18), .in_2(h_19),
    .high(h_22), .low(l_22)
);

Compare_node_2I2O u23(
    .in_1(l_19), .in_2(h_20),
    .high(h_23), .low(l_23)
);

Compare_node_2I2O u24(
    .in_1(l_20), .in_2(l_16),
    .high(h_24), .low(l_24)
);

Compare_node_2I2O u25(
    .in_1(h_17), .in_2(h_21),
    .high(h_25), .low(l_25)
);

Compare_node_2I2O u26(
    .in_1(l_21), .in_2(h_22),
    .high(h_26), .low(l_26)
);

Compare_node_2I2O u27(
    .in_1(l_22), .in_2(h_23),
    .high(h_27), .low(l_27)
);

Compare_node_2I2O u28(
    .in_1(l_23), .in_2(h_24),
    .high(h_28), .low(l_28)
);

Compare_node_2I2O u29(
    .in_1(l_25), .in_2(h_26),
    .high(h_29), .low(l_29)
);

Compare_node_2I2O u30(
    .in_1(l_26), .in_2(h_27),
    .high(h_30), .low(l_30)
);

Compare_node_2I2O u31(
    .in_1(l_27), .in_2(h_28),
    .high(h_31), .low(l_31)
);

Compare_node_2I2O u32(
    .in_1(l_28), .in_2(l_24),
    .high(h_32), .low(l_32)
);

Compare_node_2I2O u33(
    .in_1(h_25), .in_2(h_29),
    .high(h_33), .low(l_33)
);

Compare_node_2I2O u34(
    .in_1(l_29), .in_2(h_30),
    .high(h_34), .low(l_34)
);

Compare_node_2I2O u35(
    .in_1(l_30), .in_2(h_31),
    .high(out), .low(l_35)
);

Compare_node_2I2O u36(
    .in_1(l_31), .in_2(h_32),
    .high(h_36), .low(l_36)
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