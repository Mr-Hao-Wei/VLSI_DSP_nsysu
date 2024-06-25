////////////////////////////////////////////////////////////////////////////////////
// Edge detection circuit testbench (pipline + systolic array + folding + retiming)
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
////////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/10ps
`define CYCLE      10.0          	  				// Modify your clock period here
`define SDFFILE    "./Edge_detection_syn.sdf"	  	// Modify your sdf file name
`define End_CYCLE  1000000000              			// Modify cycle times once your design need more cycle times!

`define PAT        "./dat_GAU/PAT.dat"              // Modify your "dat" directory path
`define L1_EXP     "./dat_GAU/L1_EXP.dat"          
`define L2_EXP     "./dat_GAU/L2_EXP.dat"     
     
 

module tb_Edge_detection;


reg	[7:0]	PAT	[0:4095];					// PAT_MEM

reg	[7:0]	L1_EXP	[0:4095];   			// Layer1 output expectation
reg	[7:0]	L1_MEM	[0:4095];  				// L1_MEM
 
reg	[7:0]	L2_EXP	[0:4095];				// Layer2 output expectation
reg	[7:0]	L2_MEM	[0:4095];				// L2_MEM


reg				reset = 0;
reg				clk = 0;
reg				ready = 0;

reg				switch = 1;					// 0: Median blur 1: Gaussian blur
reg    	[7:0]   threshold = 8'd56;    		// Binarization threshold: 0~255

wire			cwr;
wire			crd;
wire	[2:0]	csel;

wire	[7:0]	cdata_wr;
reg		[7:0]	cdata_rd_1, cdata_rd_2, cdata_rd_3, cdata_rd_4, cdata_rd_5, cdata_rd_6, cdata_rd_7, cdata_rd_8, cdata_rd_9;

wire	[11:0]	caddr_rd_1, caddr_rd_2, caddr_rd_3, caddr_rd_4, caddr_rd_5, caddr_rd_6, caddr_rd_7, caddr_rd_8, caddr_rd_9;
wire	[11:0]	caddr_wr;

wire	[11:0]	iaddr_1, iaddr_2, iaddr_3, iaddr_4, iaddr_5, iaddr_6, iaddr_7, iaddr_8, iaddr_9;
reg	    [7:0]	idata_1, idata_2, idata_3, idata_4, idata_5, idata_6, idata_7, idata_8, idata_9;


integer		p1, p2;
integer		err1, err2;

integer		pat_num;
reg		check1=0, check2=0;

`ifdef SDF
	initial $sdf_annotate(`SDFFILE, u_Edge_detection);
`endif

Edge_detection u_Edge_detection(
			.clk(clk),
			.reset(reset),
			.busy(busy),	
//			.ready(ready),
			.switch(switch),
			.threshold(threshold),	
			.iaddr_1(iaddr_1), .iaddr_2(iaddr_2), .iaddr_3(iaddr_3), .iaddr_4(iaddr_4), .iaddr_5(iaddr_5), .iaddr_6(iaddr_6), .iaddr_7(iaddr_7), .iaddr_8(iaddr_8), .iaddr_9(iaddr_9),
			.idata_1(idata_1), .idata_2(idata_2), .idata_3(idata_3), .idata_4(idata_4), .idata_5(idata_5), .idata_6(idata_6), .idata_7(idata_7), .idata_8(idata_8), .idata_9(idata_9),
			.cwr(cwr),
			.caddr_wr(caddr_wr),
			.cdata_wr(cdata_wr),
			.crd(crd),
			.cdata_rd_1(cdata_rd_1), .cdata_rd_2(cdata_rd_2), .cdata_rd_3(cdata_rd_3), .cdata_rd_4(cdata_rd_4),
			.cdata_rd_5(cdata_rd_5), .cdata_rd_6(cdata_rd_6), .cdata_rd_7(cdata_rd_7), .cdata_rd_8(cdata_rd_8), .cdata_rd_9(cdata_rd_9),
			.caddr_rd_1(caddr_rd_1), .caddr_rd_2(caddr_rd_2), .caddr_rd_3(caddr_rd_3), .caddr_rd_4(caddr_rd_4),
			.caddr_rd_5(caddr_rd_5), .caddr_rd_6(caddr_rd_6), .caddr_rd_7(caddr_rd_7), .caddr_rd_8(caddr_rd_8), .caddr_rd_9(caddr_rd_9),
			.csel(csel)
			);
			


always begin #(`CYCLE/2) clk = ~clk; end

initial begin
	$fsdbDumpfile("Edge_detection.fsdb");
	$fsdbDumpvars;
	//$fsdbDumpMDA;
end

initial begin  // global control
	$display("-----------------------------------------------------\n");
 	$display("START!!! Simulation Start .....\n");
 	$display("-----------------------------------------------------\n");
	@(negedge clk); #1; reset = 1'b1;  ready = 1'b1;
   	#(`CYCLE*3);  #1;   reset = 1'b0;  
   	wait(busy == 1); #(`CYCLE/4); ready = 1'b0;
end

initial begin // initial pattern and expected result
	wait(reset==1);
	wait ((ready==1) && (busy ==0) ) begin
		$readmemb(`PAT, PAT);
		$readmemb(`L1_EXP, L1_EXP);
		$readmemb(`L2_EXP, L2_EXP);
	end
		
end

always@(negedge clk) begin // generate the stimulus input data
	#1;
	if ((ready == 0) & (busy == 1)) begin
		idata_1 <= PAT[iaddr_1];
		idata_2 <= PAT[iaddr_2];
		idata_3 <= PAT[iaddr_3];
		idata_4 <= PAT[iaddr_4];
		idata_5 <= PAT[iaddr_5];
		idata_6 <= PAT[iaddr_6];
		idata_7 <= PAT[iaddr_7];
		idata_8 <= PAT[iaddr_8];
		idata_9 <= PAT[iaddr_9];
	end 
	else begin
		idata_1 <= 'hx;
		idata_2 <= 'hx;
		idata_3 <= 'hx;
		idata_4 <= 'hx;
		idata_5 <= 'hx;
		idata_6 <= 'hx;
		idata_7 <= 'hx;
		idata_8 <= 'hx;
		idata_9 <= 'hx;
	end 
	end


always@(negedge clk) begin
	if (crd == 1) begin
		case(csel)
			3'b001: begin
				cdata_rd_1 <= L1_MEM[caddr_rd_1];
				cdata_rd_2 <= L1_MEM[caddr_rd_2];
				cdata_rd_3 <= L1_MEM[caddr_rd_3];
				cdata_rd_4 <= L1_MEM[caddr_rd_4];
				cdata_rd_5 <= L1_MEM[caddr_rd_5];
				cdata_rd_6 <= L1_MEM[caddr_rd_6];
				cdata_rd_7 <= L1_MEM[caddr_rd_7];
				cdata_rd_8 <= L1_MEM[caddr_rd_8];
				cdata_rd_9 <= L1_MEM[caddr_rd_9];
			end 
			3'b010: begin
				cdata_rd_1 <= L2_MEM[caddr_rd_1];
				cdata_rd_2 <= L2_MEM[caddr_rd_2];
				cdata_rd_3 <= L2_MEM[caddr_rd_3];
				cdata_rd_4 <= L2_MEM[caddr_rd_4];
				cdata_rd_5 <= L2_MEM[caddr_rd_5];
				cdata_rd_6 <= L2_MEM[caddr_rd_6];
				cdata_rd_7 <= L2_MEM[caddr_rd_7];
				cdata_rd_8 <= L2_MEM[caddr_rd_8];
				cdata_rd_9 <= L2_MEM[caddr_rd_9]; 
			end 
		endcase
	end
end

always@(posedge clk) begin 
	if (cwr == 1) begin
		case(csel)
			3'b001: begin check1 <= 1; L1_MEM[caddr_wr] <= cdata_wr; end
			3'b010: begin check2 <= 1; L2_MEM[caddr_wr] <= cdata_wr; end		
		endcase
	end
end

initial begin
err1 = 0;
err2 = 0;
end

//-------------------------------------------------------------------------------------------------------------------
initial begin  
check1<= 0;
wait(busy==1); wait(busy==0);
if (check1 == 1) begin 
	err1 = 0;
	for (p1=0; p1<=4095; p1=p1+1) begin
		if (L1_MEM[p1] == L1_EXP[p1]) ;
		/*else if ( (L0_MEM0[p0]+20'h1) == L0_EXP0[p0]) ;
		else if ( (L0_MEM0[p0]-20'h1) == L0_EXP0[p0]) ;
		else if ( (L0_MEM0[p0]+20'h2) == L0_EXP0[p0]) ;
		else if ( (L0_MEM0[p0]-20'h2) == L0_EXP0[p0]) ;
		else if ( (L0_MEM0[p0]+20'h3) == L0_EXP0[p0]) ;
		else if ( (L0_MEM0[p0]-20'h3) == L0_EXP0[p0]) ;*/
		else begin
			err1 = err1 + 1;
			begin 
				$display("WRONG! Layer 1 Pixel %d is wrong!", p1);
				$display("               The output data is %b, but the expected data is %b ", L1_MEM[p1], L1_EXP[p1]);
			end
		end
	end
	if (err1 == 0) $display("Layer 1 is correct !");
	else		 $display("Layer 1 be found %d error !", err1);
end
end

initial begin  
check2<= 0;
wait(busy==1); wait(busy==0);
if (check2 == 1) begin 
	err2 = 0;
	for (p2=0; p2<=4095; p2=p2+1) begin
		if (L2_MEM[p2] == L2_EXP[p2]) ;
		/*else if (L0_MEM1[p0]+20'h1 == L0_EXP1[p0]) ;
		else if (L0_MEM1[p0]-20'h1 == L0_EXP1[p0]) ;
		else if (L0_MEM1[p0]+20'h2 == L0_EXP1[p0]) ;
		else if (L0_MEM1[p0]-20'h2 == L0_EXP1[p0]) ;
		else if (L0_MEM1[p0]+20'h3 == L0_EXP1[p0]) ;
		else if (L0_MEM1[p0]-20'h3 == L0_EXP1[p0]) ;*/
		else begin
			err2 = err2 + 1;
			begin 
				$display("WRONG! Layer 2 Pixel %d is wrong!", p2);
				$display("               The output data is %b, but the expected data is %b ", L2_MEM[p2], L2_EXP[p2]);
			end
		end
	end
	if (err2 == 0) $display("Layer 2 is correct !");
	else		 $display("Layer 2 be found %d error !", err2);
end
end
	
//-------------------------------------------------------------------------------------------------------------------
initial  begin
 #`End_CYCLE ;
 	$display("-----------------------------------------------------\n");
 	$display("Error!!! The simulation can't be terminated under normal operation!\n");
 	$display("-------------------------FAIL------------------------\n");
 	$display("-----------------------------------------------------\n");
 	$finish;
end

initial begin
      wait(busy == 1);
      wait(busy == 0);      
    $display(" ");
	$display("-----------------------------------------------------\n");
	$display("--------------------- S U M M A R Y -----------------\n");
	if( (check1==1)&(err1==0) ) $display("Congratulations! Layer 1 data have been generated successfully! The result is PASS!!\n");
		else if (check1 == 0) $display("Layer 1 output was fail! \n");
		else $display("FAIL!!!  There are %d errors! in Layer 1 \n", err1);
	if( (check2==1)&(err2==0) ) $display("Congratulations! Layer 2 data have been generated successfully! The result is PASS!!\n");
		else if (check2 == 0) $display("Layer 2 output was fail! \n");
		else $display("FAIL!!!  There are %d errors! in Layer 2 \n", err2);
	if ((check1|check2) == 0) $display("FAIL!!! No output data was found!! \n");
	$display("-----------------------------------------------------\n");
      #(`CYCLE/2); $finish;
end



   
endmodule


