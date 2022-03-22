`timescale 1ns / 1ps
module DataMem(
input clk,
input MemRead, MemWrite,
input[31:0] addr,
input[31:0] write_data,
output[31:0] read_data
    );
    reg[31:0] Mem[0:31];
    initial begin
    Mem[0] = 32'h00000000;   
    Mem[1] = 32'h00000001;
    Mem[2] = 32'h00000002;
    Mem[3] = 32'h00000003;
    Mem[4] = 32'h00000004;
    Mem[5] = 32'h00000005;
    Mem[6] = 32'h00000006;
    Mem[7] = 32'h00000007;
    Mem[8] = 32'h00000008;
    Mem[9] = 32'h00000009;
    Mem[10] = 32'h0000000a;
    Mem[11] = 32'h0000000b;
    Mem[12] = 32'h0000000c;
    Mem[13] = 32'h0000000d;
    Mem[14] = 32'h0000000e;
    Mem[15] = 32'h0000000f;
end
    assign read_data = Mem[addr];
            
    always@(posedge clk) begin
        if(MemWrite) Mem[addr] <= write_data;
    end
endmodule
