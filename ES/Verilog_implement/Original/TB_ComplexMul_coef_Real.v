`timescale 10 ns/100 ps
module TB_ComplexMul_coef_Real;
`define PAT "./dat/Pattern_Mul.dat"
`define EXP "./dat/Expected_Mul.dat"
`define CYCLE 5
`define PAT_NUM 1000
`define WL 14 
`define WL_out 2*`WL


reg [3*`WL-1:0] pat [0:`PAT_NUM-1];
reg [`WL_out+`WL_out-1:0] exp [0:`PAT_NUM-1];
reg [`WL_out+`WL_out-1:0] exptemp;
wire [`WL_out+`WL_out-1:0] result;

reg clk, rst;
reg signed [`WL-1:0] ar, ai, br;
wire signed [`WL_out-1:0] cr, ci;

ComplexMul_coef_Real #(.WL(`WL) , .WL_out(`WL_out)) U0 (
    .clk(clk),
    .reset(rst),
    .ar(ar), 
    .ai(ai), 
    .br(br), 
    .cr(cr), 
    .ci(ci)
);

assign result = {cr,ci};

integer i;
reg finish;
reg [10:0] pass, error;

always
    begin
    #(`CYCLE/2) clk = ~clk;
    end


initial
begin
    $fsdbDumpfile("TB_ComplexMul_coef_Real_result.fsdb");
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
            {ar,ai,br}=pat[i];
            exptemp=exp[i];
    end
end

always @ (negedge clk)
begin
    if(result != exptemp)
        begin
            $display("===============================wrong result===============================", i);
            error=error+1;
        end
    else
        begin
            $display("==================================Correct=================================", i);
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
		  $display("        **   the number of correct :%d   **" ,pass);
		  $display("        **   the number of  error  :%d   **" ,error);
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
		  $display("        **   the number of correct :%d   **" ,pass);
		  $display("        **   the number of  error  :%d   **" ,error);
		  $display("        ***********************************\n");
		  $display("\n");
		  $display("\n");
		end
    #(1) $finish;  
  end

endmodule
