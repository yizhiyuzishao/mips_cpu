`timescale 1ns / 1ps
module CPU(
input clk
    );    
    wire[31:0] pc_in, pc_out, pc_add4, extended_imm;
    wire[31:0] inst, instmem_out;
    wire[31:0] read_data1, read_data2, write_data;    //寄存器堆引脚
    wire[31:0] datamem_out, branch_mux;
    wire[31:0] data1, data2, result;            //ALU引脚
    wire[4:0] addrs, addrt;
    wire[4:0] write_addr; 
    wire[2:0] aluop;
    
    // wire[1:0]  ALUctlOp;
    wire RegDst, Jump, Branch, MemRead, MemtoReg, ALUctl_op, MemWrite, ALUSrc, RegWrite, PcWrite, IRWrite;
    wire bcond;
    
    //符号扩展
    assign extended_imm = (inst[15] == 0) ? {16'b0, inst[15:0]}:{16'b1, inst[15:0]};

    assign pc_add4 = pc_out + 4;
    
    assign addrs = inst[25:21];
    assign addrt = inst[20:16];

    //ALU的输入引脚
    assign write_addr = (RegDst == 1)?inst[15:11] : inst[20:16];
    assign data1 = read_data1;
    assign data2 = (ALUSrc == 1)?extended_imm : read_data2;
    //判断是aluo写回寄存器还是mem写回
    assign write_data = (MemtoReg == 1) ? datamem_out : result;

    //两个多路选择器(分支和jmp)
    assign branch_mux = (Branch&bcond == 1) ? {extended_imm[29:0], 2'b00} + pc_add4 : pc_add4;
    assign pc_in = (Jump == 1) ? ({pc_add4[31:28],inst[25:0],2'b00}) : branch_mux;


    
    PC pc(clk, PcWrite, pc_in, pc_out);
    InstMem instmem(pc_out, instmem_out);
    IR ir(instmem_out, clk, IRWrite, inst);
    DataMem datamem(clk, MemRead, MemWrite, {2'b00,result[31:2]}, read_data2, datamem_out);  //输入地址要除以4
    Regs regfiles(RegWrite, clk, addrs, addrt, write_addr, write_data, read_data1, read_data2);
    CU cu(inst[31:26], clk, RegDst, Jump, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, PcWrite, IRWrite, ALUctl_op);
    ALU alu(aluop, data1, data2, result, bcond);
    ALUcontrol alu_control(inst[5:0], ALUctl_op, aluop);
    
endmodule
