`timescale 1ns / 1ps
module InstMem(   
input[31:0] addr,
output[31:0] inst
    );
    reg[31:0] Mem[0:16];
    initial begin
    Mem[0] = 32'b00001000000000000000000000000100;                           //00001000000000000000000000000100;    // j 
    Mem[1] = 32'b10001101000000010000000000000100;                          //00000000000000000000000000000000;   // and
    Mem[2] = 32'b00000000000000000000000000000000;                           //00000000000000000000000000000000;     // nop
    Mem[3] = 32'b00000000000010000000000000000000;                           //000000 00000 00000 00000 00000 000000;   // nop
    Mem[4] = 32'b10001100000000010000000000000100;                           //100011 00000 00001 0000000000000100;    // lw 
    Mem[5] = 32'b10001100000000100000000000001000;                           //100011 00000 00010 0000000000001000;     // lw 
    Mem[6] = 32'b00000000001000100001100000100000;                           //000000 00001 00010 00011 00000 100000;     // add 
    Mem[7] = 32'b00000000001000100010000000100010;                           //000000 00001 00010 00100 00000 100010; // sub 
    Mem[8] = 32'b00000000001001000010100000100100;                           //000000 00001 00100 00101 00000 100100;    // and 
    Mem[9] = 32'b00000000010001000011000000100101;                           //000000 00010 00100 00110 00000 100101;   // or 
    Mem[10] = 32'b00000000010000010011100000101010;                          //000000 00010 00001 00111 00000 101010;    // slt 
    Mem[11] = 32'b00010000101001110000000000000011;                           //000100 00101 00111 0000000000000011;   // beq 
    Mem[12] = 32'b00100000001000000000000000000001;                           //001000 00001 00000 0000000000000001;   // addi
    Mem[13] = 32'b00000000000000100000000000100110;                          //000000 00000 00010 00000 00000 100110;     // xor
    Mem[14] = 32'b00000000000000000000000000000000;                           //000000 00000 00000 00000 00000 000000;     // nop
    Mem[15] = 32'b10101100000000110000000000000100;                           //101011 00000 00011 0000000000000100;      // sw 
    Mem[16] = 32'b00001000000000000000000000000100;                           //000010 00000000000000000000000100;      //j
end
    assign inst = Mem[{2'b00,addr[31:2]}];  //一个指令四个字节
endmodule
