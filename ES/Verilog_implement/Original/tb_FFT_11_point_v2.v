`timescale 1ns / 1ps

module tb_FFT_11_point;
`define PAT "./dat/Pattern.dat"
`define EXP "./dat/Expected.dat"
`define CYCLE 5
`define PAT_NUM 11
`define WL 9
`define WL_out 34

reg [2*`WL-1:0] pat [0:`PAT_NUM-1];
reg [`WL_out+`WL_out-1:0] exp [0:`PAT_NUM-1];
reg [22*`WL_out-1:0] exptemp;
wire [22*`WL_out-1:0] result;

reg signed [`WL-1:0] x0_r, x1_r, x2_r, x3_r, x4_r, x5_r, x6_r, x7_r, x8_r, x9_r, x10_r;
reg signed [`WL-1:0] x0_i, x1_i, x2_i, x3_i, x4_i, x5_i, x6_i, x7_i, x8_i, x9_i, x10_i;
wire signed [`WL_out-1:0] X0_r, X1_r, X2_r, X3_r, X4_r, X5_r, X6_r, X7_r, X8_r, X9_r, X10_r;
wire signed [`WL_out-1:0] X0_i, X1_i, X2_i, X3_i, X4_i, X5_i, X6_i, X7_i, X8_i, X9_i, X10_i;

FFT_11_point #(.WL(`WL) , .WL_out(`WL_out)) U0 (
    .x0_r(x0_r),
    .x1_r(x1_r),
    .x2_r(x2_r),
    .x3_r(x3_r),
    .x4_r(x4_r),
    .x5_r(x5_r),
    .x6_r(x6_r),
    .x7_r(x7_r),
    .x8_r(x8_r),
    .x9_r(x9_r),
    .x10_r(x10_r),
    .x0_i(x0_i),
    .x1_i(x1_i),
    .x2_i(x2_i),
    .x3_i(x3_i),
    .x4_i(x4_i),
    .x5_i(x5_i),
    .x6_i(x6_i),
    .x7_i(x7_i),
    .x8_i(x8_i),
    .x9_i(x9_i),
    .x10_i(x10_i),
    .X0_r(X0_r),
    .X1_r(X1_r),
    .X2_r(X2_r),
    .X3_r(X3_r),
    .X4_r(X4_r),
    .X5_r(X5_r),
    .X6_r(X6_r),
    .X7_r(X7_r),
    .X8_r(X8_r),
    .X9_r(X9_r),
    .X10_r(X10_r),
    .X0_i(X0_i),
    .X1_i(X1_i),
    .X2_i(X2_i),
    .X3_i(X3_i),
    .X4_i(X4_i),
    .X5_i(X5_i),
    .X6_i(X6_i),
    .X7_i(X7_i),
    .X8_i(X8_i),
    .X9_i(X9_i),
    .X10_i(X10_i)
);


reg clk;
assign result = {X0_r, X0_i, X1_r, X1_i, X2_r, X2_i, X3_r, X3_i, X4_r, X4_i, X5_r, X5_i, X6_r, X6_i, X7_r, X7_i, X8_r, X8_i, X9_r, X9_i, X10_r, X10_i};

integer i,rst;
reg finish;
reg [10:0] pass, error;

always
    begin
    #(`CYCLE/2) clk = ~clk;
    end


initial
begin
    $fsdbDumpfile("FFT_11_point.fsdb");
    $fsdbDumpvars;

    $readmemb(`PAT, pat);
    $readmemb(`EXP, exp);

    $display("\n");
    $display("\n");
    $display("==============================start==============================");
    $display("\n");
    $display("\n");

    clk= 1'b0;
    rst= 1'b0;
    pass = 0;
    error = 0;
end

initial
begin
    for(i=1; i<= `PAT_NUM; i=i+1)
    begin
        @(negedge clk)
            {x0_r,x0_i}=pat[0];
            {x1_r,x1_i}=pat[1];
            {x2_r,x2_i}=pat[2];
            {x3_r,x3_i}=pat[3];
            {x4_r,x4_i}=pat[4];
            {x5_r,x5_i}=pat[5];
            {x6_r,x6_i}=pat[6];
            {x7_r,x7_i}=pat[7];
            {x8_r,x8_i}=pat[8];
            {x9_r,x9_i}=pat[9];
            {x10_r,x10_i}=pat[10];
            exptemp={exp[0],exp[1],exp[2],exp[3],exp[4],exp[5],exp[6],exp[7],exp[8],exp[9],exp[10]};
    end
end

always @ (negedge clk)
begin
    if(result != exptemp)
        begin
            $display("XXXXXXXXXXXXXXXXXXXXXXXXXX     wrong result     XXXXXXXXXXXXXXXXXXXXXXXXX", i);
            error=error+1;
        end
    else
        begin
            $display("OOOOOOOOOOOOOOOOOOOOOOOOOOOOO     Correct     OOOOOOOOOOOOOOOOOOOOOOOOOOOO", i);
            pass=pass+1;
        end
    
    finish = (i == `PAT_NUM);
end

initial    //finish
  begin
    @(posedge finish)
	  if(error==0)
	    begin
		  $display("\n");
		  $display("\n");
		  $display("===================all satisfy expect===================");
		  $display("\n");
		  $display("        ***********************************");
		  $display("        **   the number of pattern :%01d   **",`PAT_NUM);
		  $display("        **   the number of correct :%01d   **" ,pass);
		  $display("        **   the number of  error  :%01d   **" ,error);
		  $display("        ***********************************\n");
		  $display("\n");
		  $display("\n");
		end
	  else
	    begin
		  $display("\n");
		  $display("\n");
		  $display("===================There is something wrong===================");
		  $display("===================There is something wrong===================");
		  $display("\n");
		  $display("        ***********************************");
		  $display("        **   the number of pattern :%01d   **",`PAT_NUM);
		  $display("        **   the number of correct :%01d   **",pass);
		  $display("        **   the number of  error  :%01d   **",error);
		  $display("        ***********************************\n");
		  $display("\n");
		  $display("\n");
		end
    #(1) $finish;  
  end

endmodule


