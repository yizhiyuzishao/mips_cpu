`timescale 1ns / 1ps

module Regs(
input RegWrite, 
input  clk,
input[4:0] addrs, addrt, 
input[4:0] write_addr,
input[31:0] write_data,
output reg[31:0] read_data1, read_data2
    );
    reg[31:0] regs[0:31];
    initial regs[0] = 0;

    always@(posedge clk) begin
        read_data1 <= regs[addrs];
        read_data2 <= regs[addrt];
        if(RegWrite) begin
            regs[write_addr] <= write_data;
        end            
    end
endmodule
