`timescale 1ns / 1ps

 module ALU(
input[2:0] aluop,
input[31:0] data1, data2,
output reg[31:0] result,
output bcond
    );
   assign bcond = (data1 == data2) ? 1 : 0;
   
   always@* begin
   case(aluop)
    3'b000: result <= data1 + data2;//add
    3'b001: result <= data1 - data2;//sub
    3'b010: result <= data1 & data2;//and
    3'b011: result <= data1 | data2;//or
    3'b100: result <= (data1 < data2) ? 1 : 0; //slt
    3'b101: result <= data1 ^ data2;//xor
    3'b111: result <= data1; //nop
   endcase
   end
   
endmodule
