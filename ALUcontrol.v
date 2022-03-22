`timescale 1ns / 1ps
module ALUcontrol(
input[5:0] funct,   
input ALUctl_op,
output reg[2:0] aluop 
    );
    always@* begin
        case(ALUctl_op)
            0: begin
                case(funct) 
                    6'b000000: aluop <= 3'b111;  //nop
                    6'b100000: aluop <= 3'b000; //add
                    6'b100100: aluop <= 3'b010; //and
                    6'b100101: aluop <= 3'b011; //or
                    6'b101010: aluop <= 3'b100; //slt
                    6'b100010: aluop <= 3'b001; //sub
                    6'b100110: aluop <= 3'b101; //xor
                endcase
            end            
            1: aluop = 3'b000;       
        endcase
    end
endmodule
