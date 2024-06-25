`timescale 1ns / 1ps

module tb_Mul_5bits_J2
;

    reg clk;
    reg reset;
    reg [4:0] a;
    reg  b_0, b_1, b_2, b_3, b_4;
    wire [9:0] s_0, s_1;

    Mul_5bits_J2 u0 (
        .clk(clk),
        .reset(reset),
        .a(a),
        .b_0(b_0),
        .b_1(b_1),
        .b_2(b_2),
        .b_3(b_3),
        .b_4(b_4),
        .s_0(s_0),
        .s_1(s_1)
    );
    
    initial clk = 0;
    always #50 clk = ~clk;

        initial begin
        reset = 1; clk = 0; 
        #200 reset = 0; a = 5; b_4 = 0; b_3 = 0; b_2 = 0; b_1 = 1; b_0 = 1; 
        

        #1000 $finish;
    end

    initial begin
         $monitor($time," a=%d b_4=%d b_3=%d b_2=%d b_1=%d b_0=%d s_0=%d s_1=%d",a,b_4,b_3,b_2,b_1,b_0,s_0,s_1);
    end

    initial begin
	$fsdbDumpfile("tb_Mul_5bits_J2.fsdb");
	$fsdbDumpvars;
	//$fsdbDumpMDA;
    end


endmodule
    