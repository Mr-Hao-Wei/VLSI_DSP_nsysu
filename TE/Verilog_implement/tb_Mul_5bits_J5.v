`timescale 1ns / 1ps

module tb_Mul_5bits_J5;


    reg [4:0] a;
    reg [4:0] b;
    wire [9:0] s;

    Mul_5bits_J5 u0 (
        .a(a),
        .b(b),
        .s(s)
    );
    
    // initial clk = 0;
    // always #50 clk = ~clk;

        initial begin
        #200 a = 5; b = 3;
        #200 a = 7; b = 9;

        #1000 $finish;
    end

    initial begin
         $monitor($time," a=%d b=%d s=%d",a,b,s);
    end

    initial begin
	$fsdbDumpfile("tb_Mul_5bits_J5.fsdb");
	$fsdbDumpvars;
	//$fsdbDumpMDA;
    end

endmodule
    