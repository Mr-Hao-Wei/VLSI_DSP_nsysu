`timescale 1ns / 1ps

module tb_Mul_5bits;

    reg clk;
    reg reset;
    reg [4:0] a;
    reg [4:0] b;
    wire [9:0] s;

    Mul_5bits u0 (
        .clk(clk),
        .reset(reset),
        .a(a),
        .b(b),
        .s(s)
    );
    
    initial clk = 0;
    always #50 clk = ~clk;

        initial begin
        reset = 1; clk = 0; 
        #200 reset = 0; a = 5; b = 3;
        #500 a = 7; b = 9;

        #1000 $finish;
    end

    initial begin
         $monitor($time," a=%d b=%d s=%d",a,b,s);
    end

    initial begin
	$fsdbDumpfile("tb_Mul_5bits.fsdb");
	$fsdbDumpvars;
	//$fsdbDumpMDA;
    end


endmodule
    