`timescale 1ns / 1ps
//cpu_tb.v
module cpu_tb(
    );
    reg clk;
    initial clk = 1;
    always#5 clk = ~clk;
    CPU cpu(clk);
endmodule
