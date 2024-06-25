`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// IIR Chebyshev bandstop filter testbench
// Structure: IIR Cascaded Second-Order Sections Direct Form II
// Total order: 6
// Cut-off freq.: 60 Hz
// Sampling freq.: 360 Hz
//
// Author: Abbiter Liu
//////////////////////////////////////////////////////////////////////////////////

module testbench_30;

    reg clk;
    reg reset;
    reg signed [27:0] x;
    wire signed [27:0] y;

    // Instantiate the test filter
    chebyshev_bs_iir #(.WL(28)) u0 (
        .clk(clk), 
        .reset(reset),
        .x(x), 
        .y(y)
    );

    // Generate clock with 100ns period
    initial clk = 0;
    always #50 clk = ~clk;


    integer  ii;

    // Initialize and pass sinusoidal input data of 30Hz with sampling frequency of 360Hz   
    initial begin
        x = 0; reset = 1; clk = 0; 
        #100 reset = 1; 
        #200 reset = 0;
        for(ii=0;ii<100;ii=ii+1) begin  // Run 100 periods
            #100 x={15'd0,13'd0};
            #100 x={15'd50,13'd0};
            #100 x={15'd86,13'd4935};
            #100 x={15'd100,13'd0};
            #100 x={15'd86,13'd4935};
            #100 x={15'd50,13'd0};
            #100 x={15'd0,13'd0};
            #100 x=-{15'd50,13'd0};
            #100 x=-{15'd86,13'd4935};
            #100 x=-{15'd100,13'd0};
            #100 x=-{15'd86,13'd4935};
            #100 x=-{15'd50,13'd0};
        end
        $finish;
    end

    initial begin
         $monitor($time," x=%d y=%d",x,y);
    end

    // initial begin
    //      $monitor(" y=%d",y);
    // end

    // Generate wave file
    initial begin
	$fsdbDumpfile("tb_30.fsdb");
	$fsdbDumpvars;
	//$fsdbDumpMDA;
    end
      
endmodule