`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 5-bit Multiplier
// Structure: 5-bit Multiplier with accumulate adder and unfolding factor 4
//
// Author: Abbiter Liu
//////////////////////////////////////////////////////////////////////////////////

module Mul_5bits_J4 (
    input clk,
    input reset,
    input [4:0] a,
    input  b_0, b_1, b_2, b_3, b_4,
    output [9:0] s_0, s_1, s_2, s_3
);


wire sel_0, sel_1, sel_2, sel_3;
wire [4:0] a_in_0, a_in_1, a_in_2, a_in_3;
wire [9:0] acc_out_0, acc_out_1, acc_out_2, acc_out_3;

reg b_in_0, b_in_1, b_in_2, b_in_3;
reg [2:0] count;
reg [9:0] a_in_shift_0, a_in_shift_1, a_in_shift_2, a_in_shift_3;
reg [9:0] acc_in;
reg [9:0] adder_in_0, adder_in_1, adder_in_2, adder_in_3;

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
        3'd0: begin
            b_in_0 <= b_0;
            b_in_1 <= b_1;
            b_in_2 <= b_2;
            b_in_3 <= b_3; 
        end
        3'd1: begin
            b_in_0 <= b_4;
            b_in_1 <= b_0;
            b_in_2 <= b_1;
            b_in_3 <= b_2;
        end
        3'd2: begin
            b_in_0 <= b_3;
            b_in_1 <= b_4;
            b_in_2 <= b_0;
            b_in_3 <= b_1;
        end
        3'd3: begin
            b_in_0 <= b_2;
            b_in_1 <= b_3;
            b_in_2 <= b_4;
            b_in_3 <= b_0;
        end
        3'd4: begin
            b_in_0 <= b_1;
            b_in_1 <= b_2;
            b_in_2 <= b_3;
            b_in_3 <= b_4;
        end
        default: begin
            b_in_0 <= 1'b0;
            b_in_1 <= 1'b0;
            b_in_2 <= 1'b0;
            b_in_3 <= 1'b0;
        end 
    endcase
end

assign sel_0 = (b_in_0)?1'b1:1'b0;
assign sel_1 = (b_in_1)?1'b1:1'b0;
assign sel_2 = (b_in_2)?1'b1:1'b0;
assign sel_3 = (b_in_3)?1'b1:1'b0;

assign a_in_0 = (sel_0)?a:5'd0;
assign a_in_1 = (sel_1)?a:5'd0;
assign a_in_2 = (sel_2)?a:5'd0;
assign a_in_3 = (sel_3)?a:5'd0;

always @(*) begin
    case (count)
        3'd0: begin
            a_in_shift_0 <= {5'd0,a_in_0};
            a_in_shift_1 <= {4'd0,a_in_1,1'd0};
            a_in_shift_2 <= {3'd0,a_in_2,2'd0};
            a_in_shift_3 <= {2'd0,a_in_3,3'd0};
        end 
        3'd1: begin
            a_in_shift_0 <= {1'd0,a_in_0,4'd0};
            a_in_shift_1 <= {5'd0,a_in_1};
            a_in_shift_2 <= {4'd0,a_in_2,1'd0};
            a_in_shift_3 <= {3'd0,a_in_3,2'd0};
        end  
        3'd2: begin
            a_in_shift_0 <= {2'd0,a_in_0,3'd0};
            a_in_shift_1 <= {1'd0,a_in_1,4'd0};
            a_in_shift_2 <= {5'd0,a_in_2};
            a_in_shift_3 <= {4'd0,a_in_3,1'd0};
        end 
        3'd3: begin
            a_in_shift_0 <= {3'd0,a_in_0,2'd0};
            a_in_shift_1 <= {2'd0,a_in_1,3'd0};
            a_in_shift_2 <= {1'd0,a_in_2,4'd0};
            a_in_shift_3 <= {5'd0,a_in_3};
        end 
        3'd4: begin
            a_in_shift_0 <= {4'd0,a_in_0,1'd0};
            a_in_shift_1 <= {3'd0,a_in_1,2'd0};
            a_in_shift_2 <= {2'd0,a_in_2,3'd0};
            a_in_shift_3 <= {1'd0,a_in_3,4'd0};
        end 
        default: begin
            a_in_shift_0 <= 10'd0;
            a_in_shift_1 <= 10'd0;
            a_in_shift_2 <= 10'd0;
            a_in_shift_3 <= 10'd0;
        end
    endcase
end

always @(posedge clk ) begin
    if(reset)
        acc_in <= 10'd0;
    else
        acc_in <= acc_out_3;
end

always @(*) begin
    case (count)
        3'd0: begin
            adder_in_0 <= 10'd0;
            adder_in_1 <= acc_out_0;
            adder_in_2 <= acc_out_1;
            adder_in_3 <= acc_out_2;
        end
        3'd1: begin
            adder_in_0 <= acc_in;
            adder_in_1 <= 10'd0;
            adder_in_2 <= acc_out_1;
            adder_in_3 <= acc_out_2;
        end 
        3'd2: begin
            adder_in_0 <= acc_in;
            adder_in_1 <= acc_out_0;
            adder_in_2 <= 10'd0;
            adder_in_3 <= acc_out_2;
        end 
        3'd3: begin
            adder_in_0 <= acc_in;
            adder_in_1 <= acc_out_0;
            adder_in_2 <= acc_out_1;
            adder_in_3 <= 10'd0;
        end 
        3'd4: begin
            adder_in_0 <= acc_in;
            adder_in_1 <= acc_out_0;
            adder_in_2 <= acc_out_1;
            adder_in_3 <= acc_out_2;
        end         
        default: begin
            adder_in_0 <= 10'd0;
            adder_in_1 <= 10'd0;
            adder_in_2 <= 10'd0;
            adder_in_3 <= 10'd0;
        end 
    endcase      
end

assign acc_out_0 = adder_in_0 + a_in_shift_0;
assign acc_out_1 = adder_in_1 + a_in_shift_1;
assign acc_out_2 = adder_in_2 + a_in_shift_2;
assign acc_out_3 = adder_in_3 + a_in_shift_3;

assign s_0 = (count==3'd1)?acc_out_0:10'd0;
assign s_1 = (count==3'd2)?acc_out_1:10'd0;
assign s_2 = (count==3'd3)?acc_out_2:10'd0;
assign s_3 = (count==3'd4)?acc_out_3:10'd0;

endmodule