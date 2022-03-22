`timescale 1ns / 1ps


module IR(
        input [31:0] IR_in,
        input clk,
        input IR_write,
        output[31:0] IR_out
    );
    reg[31:0] IR;
    initial IR = 0;
    assign IR_out = IR;
    
    always@(posedge clk)
    begin
        if(IR_write) 
            IR <= IR_in;
    end

endmodule
