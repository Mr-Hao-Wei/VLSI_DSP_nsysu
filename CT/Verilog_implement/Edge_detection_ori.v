`timescale 1ns/10ps
//////////////////////////////////////////////////////////////////////////////////
// Edge detection circuit (original)
// Structure: 
//		Layer1: Median blur (3x3) or Gaussian blur (3x3)
//		Layer2: Sobel filter (3x3) & Binarization
//		Pixel register: the buffer register of layer input
//		PAT_MEM(tb): the memory of the original picture
//		L1_MEM(tb): the memory of Layer1 output
//		L2_MEM(tb): the memory of Layer2 output
// Picture size: 64x64 (pixels)
// Convolution stride: 1
//
// Author: Abbiter Liu
//////////////////////////////////////////////////////////////////////////////////

// submodule
`include "./Gaussian_blur.v"
`include "./Median_blur_36.v"
`include "./Sobel_ed.v"
`include "./Binarization.v"


module  Edge_detection_ori(
	input 				clk,
	input 				reset,
	output reg 			busy,	
    // input 			    ready,

	input               switch,		// 0: Median blur 1: Gaussian blur
	input [7:0]         threshold,	// Binarization threshold: 0~255
			
	output reg [11:0]   iaddr_1, iaddr_2, iaddr_3, iaddr_4, iaddr_5, iaddr_6, iaddr_7, iaddr_8, iaddr_9, // PAT_MEM address (read)
	input  [7:0]        idata_1, idata_2, idata_3, idata_4, idata_5, idata_6, idata_7, idata_8, idata_9, //	PAT_MEM data buffer	
	
	output reg 			cwr,		// MEM write enable
	output reg [11:0] 	caddr_wr,	// MEM address (write)
	output reg [7:0] 	cdata_wr,	// MEM data (write) buffer
	
	output reg 			crd,		// MEM read enable
	output reg [11:0] 	caddr_rd_1, caddr_rd_2, caddr_rd_3, caddr_rd_4, caddr_rd_5, caddr_rd_6, caddr_rd_7, caddr_rd_8, caddr_rd_9,  // MEM address (read)
	input [7:0] 		cdata_rd_1, cdata_rd_2, cdata_rd_3, cdata_rd_4, cdata_rd_5, cdata_rd_6, cdata_rd_7, cdata_rd_8, cdata_rd_9,	 // MEM data (read) buffer
	
	output reg [2:0] 	csel		// MEM select 000: none  001: Layer1 MEM  010: Layer2 MEM
	);



/////////////////////////////////////
//            Parameter            //
/////////////////////////////////////
//FSM_State
parameter State_Initial = 2'd0,
          State_L1 = 2'd1,
          State_L2 = 2'd2,
          State_Complete = 2'd3;


/////////////////////////////////////
//           wire & reg            //
/////////////////////////////////////

reg [1:0] cs, ns;
reg [12:0] L1_count; 
reg [3:0] L2_count;	
reg [5:0] x, y;
wire L1_finish, L2_finish;
wire [7:0] Gau_out, Med_out;
wire [7:0] L1_result, L2_result;
wire [12:0] L1_count_expand;
wire [16:0] Sob_out;

wire [7:0] Gau_in_1, Gau_in_2, Gau_in_3, Gau_in_4, Gau_in_5, Gau_in_6, Gau_in_7, Gau_in_8, Gau_in_9;
wire [7:0] Med_in_1, Med_in_2, Med_in_3, Med_in_4, Med_in_5, Med_in_6, Med_in_7, Med_in_8, Med_in_9;
wire [7:0] Sob_in_1, Sob_in_2, Sob_in_3, Sob_in_4, Sob_in_5, Sob_in_6, Sob_in_7, Sob_in_8, Sob_in_9;
reg [7:0] Ed_reg_1, Ed_reg_2, Ed_reg_3, Ed_reg_4, Ed_reg_5, Ed_reg_6, Ed_reg_7, Ed_reg_8, Ed_reg_9;

/////////////////////////////////////
//               FSM               //
/////////////////////////////////////

always @(posedge clk or posedge reset) begin
	if(reset)
		cs <= 2'd0;
	else
		cs <= ns;
end

always @(*) begin
	case(cs)
		State_Initial: ns <= (busy)? State_L1:State_Initial;
		State_L1: ns <= (L1_finish==1'd1)? State_L2:State_L1;
		State_L2: ns <= (L2_finish==1'd1)? State_Complete:State_L2;
		State_Complete: ns <= State_Complete;
		default: ns <= State_Initial;
	endcase	
end

/////////////////////////////////////
//         Control signal          //
/////////////////////////////////////

// busy = 0  circuit sleep  busy = 1  circuit work
always @(posedge clk or posedge reset) begin
	if(reset)
		busy <= 1'b0;
	else if(cs==State_Initial)
		busy <= 1'b1;
	else if(cs==State_Complete)
		busy <= 1'b0;	
	else
		busy <= busy;
end

// MEM write & read enable
always @(*) begin
	case(cs)
		State_Initial: begin
			crd <= 1'b0;
			cwr <= 1'b0;
		end
		State_L1: begin
			crd <= 1'b0;
			cwr <= (L1_count>=4'd2)? 1'b1:1'b0;		
		end
		State_L2: begin
			crd <= 1'b1;
			cwr <= (L2_count==4'd2)? 1'b1:1'b0;		
		end
		State_Complete:	begin
			crd <= 1'b0;
			cwr <= 1'b0;		
		end
		default: begin
			crd <= 1'b0;
			cwr <= 1'b0;			
		end
	endcase
end

// MEM select
always @(*) begin
	case(cs)
		State_Initial: csel <= 3'b000;
		State_L1: csel <= 3'b001;
		State_L2: csel <= (L2_count==4'd2)? 3'b010:3'b001;
		State_Complete: csel <= 3'b000;
		default: csel <= 3'b000;
	endcase	
end

// MEM address axis (0,0) -> (63,63)  
// x: left -> right	 y: up -> down 
always @(posedge clk or posedge reset) begin
	if(reset) begin
		x <= 6'd0;
		y <= 6'd0;
	end
	else if(ns==State_L1 && busy == 1'b1) begin
		x <= x + 1;
		y <= y + (x==6'd63);
	end
	else if(L1_finish==1'b1) begin
		x <= 6'd0;
		y <= 6'd0;
	end
	else if(ns==State_L2 && L2_count==4'd2) begin
		x <= x + 1;
		y <= y + (x==6'd63);
	end
	else begin
		x <= x;
		y <= y;
	end
end

// Layer1 counter
always @(posedge clk or posedge reset) begin
	if(reset) begin
		L1_count <= 13'd0;
	end
	else if(ns==State_L1 && busy == 1'b1) begin
		L1_count <= L1_count + 1;
	end
	else begin
		L1_count <= 13'd0;
	end
end

assign L1_count_expand = L1_count - 13'd2;

// Layer1 finish signal
assign L1_finish = (L1_count==13'd4097)? 1'b1:1'b0;

// Layer2 counter
always @(posedge clk or posedge reset) begin
	if(reset) begin
		L2_count <= 4'd0;
	end
	else if(cs==State_L2 && L2_count<=4'd1) begin
		L2_count <= L2_count + 1;
	end
	else begin
		L2_count <= 4'd0;
	end
end

// Layer2 finish signal
assign L2_finish = (L2_count==4'd2 && x==6'd63 && y==6'd63)? 1'b1:1'b0;

/////////////////////////////////////
//   Layer 1(Median or Gaussian)   //
/////////////////////////////////////

// Gaussian blur input
assign Gau_in_1 = (switch == 1'b0)? 8'd0:Ed_reg_1;
assign Gau_in_2 = (switch == 1'b0)? 8'd0:Ed_reg_2;
assign Gau_in_3 = (switch == 1'b0)? 8'd0:Ed_reg_3;
assign Gau_in_4 = (switch == 1'b0)? 8'd0:Ed_reg_4;
assign Gau_in_5 = (switch == 1'b0)? 8'd0:Ed_reg_5;
assign Gau_in_6 = (switch == 1'b0)? 8'd0:Ed_reg_6;
assign Gau_in_7 = (switch == 1'b0)? 8'd0:Ed_reg_7;
assign Gau_in_8 = (switch == 1'b0)? 8'd0:Ed_reg_8;
assign Gau_in_9 = (switch == 1'b0)? 8'd0:Ed_reg_9;

// Median blur input
assign Med_in_1 = (switch == 1'b0)? Ed_reg_1:8'd0;
assign Med_in_2 = (switch == 1'b0)? Ed_reg_2:8'd0;
assign Med_in_3 = (switch == 1'b0)? Ed_reg_3:8'd0;
assign Med_in_4 = (switch == 1'b0)? Ed_reg_4:8'd0;
assign Med_in_5 = (switch == 1'b0)? Ed_reg_5:8'd0;
assign Med_in_6 = (switch == 1'b0)? Ed_reg_6:8'd0;
assign Med_in_7 = (switch == 1'b0)? Ed_reg_7:8'd0;
assign Med_in_8 = (switch == 1'b0)? Ed_reg_8:8'd0;
assign Med_in_9 = (switch == 1'b0)? Ed_reg_9:8'd0;

// Gaussian blur
Gaussian_blur u0(
    .px_1(Gau_in_1), .px_2(Gau_in_2), .px_3(Gau_in_3), .px_4(Gau_in_4), .px_5(Gau_in_5), .px_6(Gau_in_6), .px_7(Gau_in_7), .px_8(Gau_in_8), .px_9(Gau_in_9),
    .out(Gau_out)
	);

// Median blur with 36 PEs
Median_blur_36 u1(
    .px_1(Med_in_1), .px_2(Med_in_2), .px_3(Med_in_3), .px_4(Med_in_4), .px_5(Med_in_5), .px_6(Med_in_6), .px_7(Med_in_7), .px_8(Med_in_8), .px_9(Med_in_9),
    .out(Med_out)
	);

// Layer1 result
assign L1_result = (switch == 1'b0)? Med_out:Gau_out;

/////////////////////////////////////
//  Layer 2(Sobel & Binarization)  //
/////////////////////////////////////

// Sobel filter input
assign Sob_in_1 = (cs == State_L2)? Ed_reg_1:8'd0;
assign Sob_in_2 = (cs == State_L2)? Ed_reg_2:8'd0;
assign Sob_in_3 = (cs == State_L2)? Ed_reg_3:8'd0;
assign Sob_in_4 = (cs == State_L2)? Ed_reg_4:8'd0;
assign Sob_in_5 = (cs == State_L2)? Ed_reg_5:8'd0;
assign Sob_in_6 = (cs == State_L2)? Ed_reg_6:8'd0;
assign Sob_in_7 = (cs == State_L2)? Ed_reg_7:8'd0;
assign Sob_in_8 = (cs == State_L2)? Ed_reg_8:8'd0;
assign Sob_in_9 = (cs == State_L2)? Ed_reg_9:8'd0;

// Sobel filter
Sobel_ed u2(
    .px_1(Sob_in_1), .px_2(Sob_in_2), .px_3(Sob_in_3), .px_4(Sob_in_4), .px_5(Sob_in_5), .px_6(Sob_in_6), .px_7(Sob_in_7), .px_8(Sob_in_8), .px_9(Sob_in_9),
    .out(Sob_out)
	);

// Binarization -> Layer2 result
Binarization u3(
    .threshold(threshold),
    .in(Sob_out),
    .out(L2_result)
	);

/////////////////////////////////////
//              Memory             //
/////////////////////////////////////

// PAT_MEM address (read)
always @(posedge clk or posedge reset) begin
	if(reset) begin
		iaddr_1 <= 12'd0;
		iaddr_2 <= 12'd0;
		iaddr_3 <= 12'd0;
		iaddr_4 <= 12'd0;
		iaddr_5 <= 12'd0;
		iaddr_6 <= 12'd0;
		iaddr_7 <= 12'd0;
		iaddr_8 <= 12'd0;
		iaddr_9 <= 12'd0;		
	end
	else if(ns==State_L1) begin
		iaddr_1 <= {y-6'd1,x-6'd1};
		iaddr_2 <= {y-6'd1,x};
		iaddr_3 <= {y-6'd1,x+6'd1};
		iaddr_4 <= {y,x-6'd1};
		iaddr_5 <= {y,x};
		iaddr_6 <= {y,x+6'd1};
		iaddr_7 <= {y+6'd1,x-6'd1};
		iaddr_8 <= {y+6'd1,x};
		iaddr_9 <= {y+6'd1,x+6'd1};
	end
	else begin
		iaddr_1 <= 12'd0;
		iaddr_2 <= 12'd0;
		iaddr_3 <= 12'd0;
		iaddr_4 <= 12'd0;
		iaddr_5 <= 12'd0;
		iaddr_6 <= 12'd0;
		iaddr_7 <= 12'd0;
		iaddr_8 <= 12'd0;
		iaddr_9 <= 12'd0;		
	end
end

// Pixel register (layer input buffer)
always @(posedge clk or posedge reset) begin
	if(reset) begin
		Ed_reg_1 <= 8'd0;
		Ed_reg_2 <= 8'd0;
		Ed_reg_3 <= 8'd0;
		Ed_reg_4 <= 8'd0;
		Ed_reg_5 <= 8'd0;
		Ed_reg_6 <= 8'd0;
		Ed_reg_7 <= 8'd0;
		Ed_reg_8 <= 8'd0;
		Ed_reg_9 <= 8'd0;
	end
	else if(cs==State_L1) begin
		Ed_reg_1 <= (iaddr_5[5:0]==6'd0 || iaddr_5[11:6]==6'd0)? 8'd0:idata_1;
		Ed_reg_2 <= (iaddr_5[11:6]==6'd0)? 8'd0:idata_2;
		Ed_reg_3 <= (iaddr_5[5:0]==6'd63 || iaddr_5[11:6]==6'd0)? 8'd0:idata_3;
		Ed_reg_4 <= (iaddr_5[5:0]==6'd0)? 8'd0:idata_4;
		Ed_reg_5 <= idata_5;
		Ed_reg_6 <= (iaddr_5[5:0]==6'd63)? 8'd0:idata_6;
		Ed_reg_7 <= (iaddr_5[5:0]==6'd0 || iaddr_5[11:6]==6'd63)? 8'd0:idata_7;
		Ed_reg_8 <= (iaddr_5[11:6]==6'd63)? 8'd0:idata_8;
		Ed_reg_9 <= (iaddr_5[5:0]==6'd63 || iaddr_5[11:6]==6'd63)? 8'd0:idata_9;
	end	
	else if(cs==State_L2) begin
		Ed_reg_1 <= (x==6'd0 || y==6'd0)? 8'd0:cdata_rd_1;
		Ed_reg_2 <= (y==6'd0)? 8'd0:cdata_rd_2;
		Ed_reg_3 <= (x==6'd63 || y==6'd0)? 8'd0:cdata_rd_3;
		Ed_reg_4 <= (x==6'd0)? 8'd0:cdata_rd_4;
		Ed_reg_5 <= cdata_rd_5;
		Ed_reg_6 <= (x==6'd63)? 8'd0:cdata_rd_6;
		Ed_reg_7 <= (x==6'd0 || y==6'd63)? 8'd0:cdata_rd_7;
		Ed_reg_8 <= (y==6'd63)? 8'd0:cdata_rd_8;
		Ed_reg_9 <= (x==6'd63 || y==6'd63)? 8'd0:cdata_rd_9;
	end
	else begin
		Ed_reg_1 <= 8'd0;
		Ed_reg_2 <= 8'd0;
		Ed_reg_3 <= 8'd0;
		Ed_reg_4 <= 8'd0;
		Ed_reg_5 <= 8'd0;
		Ed_reg_6 <= 8'd0;
		Ed_reg_7 <= 8'd0;
		Ed_reg_8 <= 8'd0;
		Ed_reg_9 <= 8'd0;
	end
end

// MEM address (write)
always @(*) begin
	case(cs)
		State_L1: caddr_wr <= L1_count_expand[11:0];
		State_L2: caddr_wr <= {y,x};
		default: caddr_wr <= 12'd0;
	endcase
end	

// MEM data (write) buffer
always @(*) begin
	case(cs)
		State_L1: cdata_wr <= L1_result;
		State_L2: cdata_wr <= L2_result;
		default: cdata_wr <= 8'd0;
	endcase
end

// Layer1 MEM address (read)
always @(posedge clk or posedge reset) begin
	if(reset) begin
		caddr_rd_1 <= 12'd0;
		caddr_rd_2 <= 12'd0;
		caddr_rd_3 <= 12'd0;
		caddr_rd_4 <= 12'd0;
		caddr_rd_5 <= 12'd0;
		caddr_rd_6 <= 12'd0;
		caddr_rd_7 <= 12'd0;
		caddr_rd_8 <= 12'd0;
		caddr_rd_9 <= 12'd0;
	end
	else if(cs==State_L2 && L2_count==4'd0) begin
		caddr_rd_1 <= {y-6'd1,x-6'd1};
		caddr_rd_2 <= {y-6'd1,x};
		caddr_rd_3 <= {y-6'd1,x+6'd1};
		caddr_rd_4 <= {y,x-6'd1};
		caddr_rd_5 <= {y,x};
		caddr_rd_6 <= {y,x+6'd1};
		caddr_rd_7 <= {y+6'd1,x-6'd1};
		caddr_rd_8 <= {y+6'd1,x};
		caddr_rd_9 <= {y+6'd1,x+6'd1};
	end
	else begin
		caddr_rd_1 <= caddr_rd_1;
		caddr_rd_2 <= caddr_rd_2;
		caddr_rd_3 <= caddr_rd_3;
		caddr_rd_4 <= caddr_rd_4;
		caddr_rd_5 <= caddr_rd_5;
		caddr_rd_6 <= caddr_rd_6;
		caddr_rd_7 <= caddr_rd_7;
		caddr_rd_8 <= caddr_rd_8;
		caddr_rd_9 <= caddr_rd_9;
	end
end


endmodule