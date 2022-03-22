`timescale 1ns / 1ps


module CU(
    input[5:0] op,
    input clk,

    output  reg RegDst,     //判断写寄存器的地址来源，0时地址来自rt，1时地址来自rd
                Jump,       //跳转指令的使能信号
                Branch,     //分支指令的使能信号
                MemRead,    //读MEM的使能信号
                MemtoReg,   //判断写回reg的数据来自哪里，0来自alu_result，1来自MEM的输出
                MemWrite,   //MEM的写使能信号
                ALUSrc,     //为0时，ALU的B端输入来自寄存器的data2，为1时，来自扩展的立即数
                RegWrite,   //寄存器的写使能
                PcWrite,    //pc的写使能，在转移指令中为1
                IRWrite,    //ir的写使能信号
    output reg  ALUcontrol_op   //alu的控制信号
    );
    
    reg [2:0] state = 3'b111, nextState = 3'b000;    //记录状态
    //状态宏定义
    parameter [2:0] initState = 3'b111,
                   IF = 3'b000,
                   ID = 3'b001,
                   EXE = 3'b010,
                   MEM = 3'b100,
                   WB = 3'b011;
                 
    // initial begin
    //    state = 3'b111;
       
    // end
      
   //状态转换有限自动机                
    always@(state or op) begin
        case(state)
            initState : nextState = IF;
            IF: nextState = ID;
            ID: begin
                if(op == 6'b000010) nextState = IF; //j
                    else nextState = EXE;
                end
            EXE: begin 
                if(op == 6'b000100) begin //beq
                    nextState = IF;
                end else if(op == 6'b100011 || op == 6'b101011)  //sw,lw
                    nextState = MEM;
                else nextState = WB;
                end
            MEM: begin
                if(op == 6'b101011) //sw
                    nextState = IF;
                else   //lw
                    nextState = WB;
                    end
            WB: nextState = IF;
        endcase
       
       
        // PcWrite 
        if(nextState == IF && state != initState) begin
            PcWrite = 1;
        end else begin
            PcWrite = 0;
        end

        // IRWrite
        if(state == IF) begin
            IRWrite = 1;
        end else begin
            IRWrite = 0;
        end
        
        if(state == WB) begin
            if(op == 6'b000000 || op == 6'b001000 || op == 6'b100011)     //R类,addi,lw
                RegWrite = 1;
        end else RegWrite = 0;


        case(op) 
            6'b000000: begin  //R型
                RegDst = 1; Jump = 0; Branch = 0; MemRead =  0; MemtoReg = 0; ALUcontrol_op =  0;  MemWrite = 0; ALUSrc = 0;

            end
        
            6'b001000: begin    //I型 addi
                RegDst = 0; Jump = 0; Branch = 0; MemRead =  0; MemtoReg = 0; ALUcontrol_op =  1;  MemWrite = 0; ALUSrc = 1;

            end
            6'b000100: begin   //beq
                RegDst = 0; Jump = 0; Branch = 1; MemRead =  0; MemtoReg = 0; ALUcontrol_op =  1;  MemWrite = 0; ALUSrc = 0;
            end
            
            6'b000010: begin   // j
                RegDst = 0; Jump = 1; Branch = 0; MemRead =  0; MemtoReg = 0; ALUcontrol_op =  1;  MemWrite = 0; ALUSrc = 0;

            end
            
            6'b101011: begin    //sw
                RegDst = 0; Jump = 0; Branch = 0; MemRead = 0; MemtoReg = 0; ALUcontrol_op =  1;  MemWrite = 1; ALUSrc = 1;

            end
            
            6'b100011: begin    //lw
                RegDst = 0; Jump = 0; Branch = 0; MemRead = 1; MemtoReg = 1; ALUcontrol_op =  1;  MemWrite = 0; ALUSrc = 1;

            end
        endcase
   end


always@(posedge clk) begin
       state = nextState;
    end
endmodule
