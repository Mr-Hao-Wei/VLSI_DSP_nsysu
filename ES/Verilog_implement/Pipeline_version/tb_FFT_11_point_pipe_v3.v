`timescale 1ns / 100ps

module tb_FFT_11_point_pipe_parallel;
`define PAT_x0 "./dat/Pattern_x0.dat"
`define PAT_x1 "./dat/Pattern_x1.dat"
`define PAT_x2 "./dat/Pattern_x2.dat"
`define PAT_x3 "./dat/Pattern_x3.dat"
`define PAT_x4 "./dat/Pattern_x4.dat"
`define PAT_x5 "./dat/Pattern_x5.dat"
`define PAT_x6 "./dat/Pattern_x6.dat"
`define PAT_x7 "./dat/Pattern_x7.dat"
`define PAT_x8 "./dat/Pattern_x8.dat"
`define PAT_x9 "./dat/Pattern_x9.dat"
`define PAT_x10 "./dat/Pattern_x10.dat"
`define EXP_X0 "./dat/Expected_X0.dat"
`define EXP_X1 "./dat/Expected_X1.dat"
`define EXP_X2 "./dat/Expected_X2.dat"
`define EXP_X3 "./dat/Expected_X3.dat"
`define EXP_X4 "./dat/Expected_X4.dat"
`define EXP_X5 "./dat/Expected_X5.dat"
`define EXP_X6 "./dat/Expected_X6.dat"
`define EXP_X7 "./dat/Expected_X7.dat"
`define EXP_X8 "./dat/Expected_X8.dat"
`define EXP_X9 "./dat/Expected_X9.dat"
`define EXP_X10 "./dat/Expected_X10.dat"
`define CYCLE 5
`define PAT_NUM 127
`define WL 9
`define WL_out 34
`define Max_cycle_num 150

reg [2*`WL-1:0] pat00 [0:`PAT_NUM-1];
reg [2*`WL-1:0] pat01 [0:`PAT_NUM-1];
reg [2*`WL-1:0] pat02 [0:`PAT_NUM-1];
reg [2*`WL-1:0] pat03 [0:`PAT_NUM-1];
reg [2*`WL-1:0] pat04 [0:`PAT_NUM-1];
reg [2*`WL-1:0] pat05 [0:`PAT_NUM-1];
reg [2*`WL-1:0] pat06 [0:`PAT_NUM-1];
reg [2*`WL-1:0] pat07 [0:`PAT_NUM-1];
reg [2*`WL-1:0] pat08 [0:`PAT_NUM-1];
reg [2*`WL-1:0] pat09 [0:`PAT_NUM-1];
reg [2*`WL-1:0] pat10 [0:`PAT_NUM-1];

reg [`WL_out+`WL_out-1:0] exp00 [0:`PAT_NUM-1];
reg [`WL_out+`WL_out-1:0] exp01 [0:`PAT_NUM-1];
reg [`WL_out+`WL_out-1:0] exp02 [0:`PAT_NUM-1];
reg [`WL_out+`WL_out-1:0] exp03 [0:`PAT_NUM-1];
reg [`WL_out+`WL_out-1:0] exp04 [0:`PAT_NUM-1];
reg [`WL_out+`WL_out-1:0] exp05 [0:`PAT_NUM-1];
reg [`WL_out+`WL_out-1:0] exp06 [0:`PAT_NUM-1];
reg [`WL_out+`WL_out-1:0] exp07 [0:`PAT_NUM-1];
reg [`WL_out+`WL_out-1:0] exp08 [0:`PAT_NUM-1];
reg [`WL_out+`WL_out-1:0] exp09 [0:`PAT_NUM-1];
reg [`WL_out+`WL_out-1:0] exp10 [0:`PAT_NUM-1];

reg [22*`WL_out-1:0] exptemp;
wire [22*`WL_out-1:0] result;

reg clk,rst,load;
reg signed [`WL-1:0] x0_r, x1_r, x2_r, x3_r, x4_r, x5_r, x6_r, x7_r, x8_r, x9_r, x10_r;
reg signed [`WL-1:0] x0_i, x1_i, x2_i, x3_i, x4_i, x5_i, x6_i, x7_i, x8_i, x9_i, x10_i;
wire valid;
wire signed [`WL_out-1:0] X0_r, X1_r, X2_r, X3_r, X4_r, X5_r, X6_r, X7_r, X8_r, X9_r, X10_r;
wire signed [`WL_out-1:0] X0_i, X1_i, X2_i, X3_i, X4_i, X5_i, X6_i, X7_i, X8_i, X9_i, X10_i;

FFT_11_point_pipe #(.WL(`WL) , .WL_out(`WL_out)) U0 (
    .clk(clk),
    .reset(rst),
    .valid(valid),
    .load(load),
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



assign result = {X0_r, X0_i, X1_r, X1_i, X2_r, X2_i, X3_r, X3_i, X4_r, X4_i, X5_r, X5_i, X6_r, X6_i, X7_r, X7_i, X8_r, X8_i, X9_r, X9_i, X10_r, X10_i};

integer i,cycle_num,i_exp;
reg finish;
reg [10:0] pass, error;

always
    begin
    #(`CYCLE/2) clk = ~clk;
    end


initial
begin
    $fsdbDumpfile("tb_FFT_11_point.fsdb");
    $fsdbDumpvars;

    $readmemb(`PAT_x0, pat00);
    $readmemb(`PAT_x1, pat01);
    $readmemb(`PAT_x2, pat02);
    $readmemb(`PAT_x3, pat03);
    $readmemb(`PAT_x4, pat04);
    $readmemb(`PAT_x5, pat05);
    $readmemb(`PAT_x6, pat06);
    $readmemb(`PAT_x7, pat07);
    $readmemb(`PAT_x8, pat08);
    $readmemb(`PAT_x9, pat09);
    $readmemb(`PAT_x10, pat10);

    $readmemb(`EXP_X0, exp00);
    $readmemb(`EXP_X1, exp01);
    $readmemb(`EXP_X2, exp02);
    $readmemb(`EXP_X3, exp03);
    $readmemb(`EXP_X4, exp04);
    $readmemb(`EXP_X5, exp05);
    $readmemb(`EXP_X6, exp06);
    $readmemb(`EXP_X7, exp07);
    $readmemb(`EXP_X8, exp08);
    $readmemb(`EXP_X9, exp09);
    $readmemb(`EXP_X10, exp10);

    $display("\n");
    $display("\n");
    $display("==============================start==============================");
    $display("\n");
    $display("\n");

    clk= 1'b0;
    pass = 0;
    error = 0;
    i_exp=0;
    cycle_num = 1;
    rst= 1'b1;
    #(`CYCLE*3/4) rst = 1'b0;
    load = 1'b1;
end



initial //refresh input data
begin
    for(i=0; i<= `PAT_NUM; i=i+1)
    begin
        @(negedge clk) begin
            if (i == `PAT_NUM) begin
                load = 1'b0;
            end
            if(load == 1'b1) begin
                {x0_r,x0_i}=pat00[i];
                {x1_r,x1_i}=pat01[i];
                {x2_r,x2_i}=pat02[i];
                {x3_r,x3_i}=pat03[i];
                {x4_r,x4_i}=pat04[i];
                {x5_r,x5_i}=pat05[i];
                {x6_r,x6_i}=pat06[i];
                {x7_r,x7_i}=pat07[i];
                {x8_r,x8_i}=pat08[i];
                {x9_r,x9_i}=pat09[i];
                {x10_r,x10_i}=pat10[i]; 
            end
            cycle_num = cycle_num+1;
            if(valid == 1'b1 && i_exp<`PAT_NUM) begin
                exptemp={exp00[i_exp], exp01[i_exp], exp02[i_exp], exp03[i_exp], exp04[i_exp], exp05[i_exp],exp06[i_exp], exp07[i_exp], exp08[i_exp], exp09[i_exp], exp10[i_exp]};
            i_exp=i_exp+1;
            end
        end  
    end
end



always @ (negedge clk)
begin
if (valid == 1'b1) begin
#(`CYCLE/4)
    if(result != exptemp)
        begin
            $display("XXXXXXXXXXXXXXXXXXXXXXXXXX     wrong result     XXXXXXXXXXXXXXXXXXXXXXXXX", i_exp);
            error=error+1;
        end
    else
        begin
            $display("OOOOOOOOOOOOOOOOOOOOOOOOOOOOO     Correct     OOOOOOOOOOOOOOOOOOOOOOOOOOOO", i_exp);
            pass=pass+1;
        end
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


