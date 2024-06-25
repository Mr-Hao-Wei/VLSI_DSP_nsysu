`timescale 1ns/10ps
//////////////////////////////////////////////////////////////////////////////////
// Sobel filter with folding factor 9
// Kernel size: 3x3
// Kernel weight:
//    Gx:   --------------------     Gy:  -------------------
//          | -1  |  0  |  1  |           |  1  |  2  |  1  |
//          --------------------          -------------------
//          | -2  |  0  |  2  |           |  0  |  0  |  0  |
//          --------------------          -------------------
//          | -1  |  0  |  1  |           | -1  | -2  | -1  |
//          --------------------          -------------------
//
// Author: Abbiter Liu
//////////////////////////////////////////////////////////////////////////////////

module  Sobel_ed_folding_9(
    input 	clk,
	input 	reset,
    input [3:0] count,
    input [7:0] px_1, px_2, px_3, px_4, px_5, px_6, px_7, px_8, px_9,
    output  [16:0] out
	);

/////////////////////////////////////
//            Parameter            //
/////////////////////////////////////
//Kernel Gx
parameter Kernel_x_1 = -3'd1, 
          Kernel_x_2 = 3'd0, 
          Kernel_x_3 = 3'd1, 
          Kernel_x_4 = -3'd2,
		  Kernel_x_5 = 3'd0, 
          Kernel_x_6 = 3'd2, 
          Kernel_x_7 = -3'd1, 
          Kernel_x_8 = 3'd0,
          Kernel_x_9 = 3'd1;
//Kernel Gy
parameter Kernel_y_1 = 3'd1, 
          Kernel_y_2 = 3'd2, 
          Kernel_y_3 = 3'd1, 
          Kernel_y_4 = 3'd0,
		  Kernel_y_5 = 3'd0, 
          Kernel_y_6 = 3'd0, 
          Kernel_y_7 = -3'd1, 
          Kernel_y_8 = -3'd2,
          Kernel_y_9 = -3'd1;

/////////////////////////////////////
//          Mul & Add op           //
/////////////////////////////////////

//Gx
wire signed [11:0] mul_x;
wire signed [15:0] acc_x;
wire signed [15:0] Gx_abs;

reg signed [2:0] Kernel_x;
reg signed [8:0] mul_in_x;
reg signed [15:0] add_in_1_x, add_in_2_x;
reg signed [11:0] mul_x_delay;
reg signed [15:0] acc_x_delay;
reg signed [15:0] Gx;

always @(*) begin
    case (count)
        4'd2: begin
            Kernel_x <= Kernel_x_1;
            mul_in_x <= {1'b0,px_1};
            add_in_1_x <= 16'd0;
            add_in_2_x <= 16'd0;
        end
        4'd3: begin
            Kernel_x <= Kernel_x_2;
            mul_in_x <= {1'b0,px_2};
            add_in_1_x <= {{4{mul_x[11]}},mul_x};
            add_in_2_x <= {{4{mul_x_delay[11]}},mul_x_delay};
        end
        4'd4: begin
            Kernel_x <= Kernel_x_3;
            mul_in_x <= {1'b0,px_3};
            add_in_1_x <= {{4{mul_x[11]}},mul_x};
            add_in_2_x <= acc_x_delay;
        end
        4'd5: begin
            Kernel_x <= Kernel_x_4;
            mul_in_x <= {1'b0,px_4};
            add_in_1_x <= {{4{mul_x[11]}},mul_x};
            add_in_2_x <= acc_x_delay;
        end         
        4'd6: begin
            Kernel_x <= Kernel_x_5;
            mul_in_x <= {1'b0,px_5};
            add_in_1_x <= {{4{mul_x[11]}},mul_x};
            add_in_2_x <= acc_x_delay;
        end
        4'd7: begin
            Kernel_x <= Kernel_x_6;
            mul_in_x <= {1'b0,px_6};
            add_in_1_x <= {{4{mul_x[11]}},mul_x};
            add_in_2_x <= acc_x_delay;
        end
        4'd8: begin
            Kernel_x <= Kernel_x_7;
            mul_in_x <= {1'b0,px_7};
            add_in_1_x <= {{4{mul_x[11]}},mul_x};
            add_in_2_x <= acc_x_delay;
        end
        4'd9: begin
            Kernel_x <= Kernel_x_8;
            mul_in_x <= {1'b0,px_8};
            add_in_1_x <= {{4{mul_x[11]}},mul_x};
            add_in_2_x <= acc_x_delay;
        end
        4'd10: begin
            Kernel_x <= Kernel_x_9;
            mul_in_x <= {1'b0,px_9};
            add_in_1_x <= {{4{mul_x[11]}},mul_x};
            add_in_2_x <= acc_x_delay;
        end
        default: begin
            Kernel_x <= 3'd0;
            mul_in_x <= 9'd0;
            add_in_1_x <= 16'd0;
            add_in_2_x <= 16'd0;
        end
    endcase
end

assign mul_x = Kernel_x * mul_in_x;
assign acc_x = add_in_1_x + add_in_2_x;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        mul_x_delay <= 12'd0;
        acc_x_delay <= 16'd0;
    end
    else begin
        mul_x_delay <= mul_x;
        acc_x_delay <= acc_x;
    end    
end
    
always @(*) begin
    case (count)
        4'd11: Gx <= acc_x_delay;
        default: Gx <= 16'd0;
    endcase
end

assign Gx_abs = (Gx[15]==1'b1)? -Gx:Gx;


//Gy
wire signed [11:0] mul_y;
wire signed [15:0] acc_y;
wire signed [15:0] Gy_abs;

reg signed [2:0] Kernel_y;
reg signed [8:0] mul_in_y;
reg signed [15:0] add_in_1_y, add_in_2_y;
reg signed [11:0] mul_y_delay;
reg signed [15:0] acc_y_delay;
reg signed [15:0] Gy;

always @(*) begin
    case (count)
        4'd2: begin
            Kernel_y <= Kernel_y_1;
            mul_in_y <= {1'b0,px_1};
            add_in_1_y <= 15'd0;
            add_in_2_y <= 15'd0;
        end
        4'd3: begin
            Kernel_y <= Kernel_y_2;
            mul_in_y <= {1'b0,px_2};
            add_in_1_y <= {{4{mul_y[11]}},mul_y};
            add_in_2_y <= {{4{mul_y_delay[11]}},mul_y_delay};
        end
        4'd4: begin
            Kernel_y <= Kernel_y_3;
            mul_in_y <= {1'b0,px_3};
            add_in_1_y <= {{4{mul_y[11]}},mul_y};
            add_in_2_y <= acc_y_delay;
        end
        4'd5: begin
            Kernel_y <= Kernel_y_4;
            mul_in_y <= {1'b0,px_4};
            add_in_1_y <= {{4{mul_y[11]}},mul_y};
            add_in_2_y <= acc_y_delay;
        end         
        4'd6: begin
            Kernel_y <= Kernel_y_5;
            mul_in_y <= {1'b0,px_5};
            add_in_1_y <= {{4{mul_y[11]}},mul_y};
            add_in_2_y <= acc_y_delay;
        end
        4'd7: begin
            Kernel_y <= Kernel_y_6;
            mul_in_y <= {1'b0,px_6};
            add_in_1_y <= {{4{mul_y[11]}},mul_y};
            add_in_2_y <= acc_y_delay;
        end
        4'd8: begin
            Kernel_y <= Kernel_y_7;
            mul_in_y <= {1'b0,px_7};
            add_in_1_y <= {{4{mul_y[11]}},mul_y};
            add_in_2_y <= acc_y_delay;
        end
        4'd9: begin
            Kernel_y <= Kernel_y_8;
            mul_in_y <= {1'b0,px_8};
            add_in_1_y <= {{4{mul_y[11]}},mul_y};
            add_in_2_y <= acc_y_delay;
        end
        4'd10: begin
            Kernel_y <= Kernel_y_9;
            mul_in_y <= {1'b0,px_9};
            add_in_1_y <= {{4{mul_y[11]}},mul_y};
            add_in_2_y <= acc_y_delay;
        end
        default: begin
            Kernel_y <= 3'd0;
            mul_in_y <= 9'd0;
            add_in_1_y <= 16'd0;
            add_in_2_y <= 16'd0;
        end
    endcase
end

assign mul_y = Kernel_y * mul_in_y;
assign acc_y = add_in_1_y + add_in_2_y;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        mul_y_delay <= 12'd0;
        acc_y_delay <= 16'd0;
    end
    else begin
        mul_y_delay <= mul_y;
        acc_y_delay <= acc_y;
    end    
end
    
always @(*) begin
    case (count)
        4'd11: Gy <= acc_y_delay;
        default: Gy <= 16'd0;
    endcase
end

assign Gy_abs = (Gy[15]==1'b1)? -Gy:Gy;

// out
assign out = Gx_abs + Gy_abs;

endmodule