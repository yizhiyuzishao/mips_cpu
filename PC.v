`timescale 1ns / 1ps


module PC(
input clk,
input PcWrite,
input[31:0] PCin,
output[31:0] PCout
    );
    reg[31:0] pc;
    
    initial pc = 0;
    assign PCout = pc;

    always@(posedge clk) begin
        if(PcWrite)
            pc <= PCin;
    end
endmodule
