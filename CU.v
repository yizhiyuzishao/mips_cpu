`timescale 1ns / 1ps


module CU(
    input[5:0] op,
    input clk,

    output  reg RegDst,     //�ж�д�Ĵ����ĵ�ַ��Դ��0ʱ��ַ����rt��1ʱ��ַ����rd
                Jump,       //��תָ���ʹ���ź�
                Branch,     //��ָ֧���ʹ���ź�
                MemRead,    //��MEM��ʹ���ź�
                MemtoReg,   //�ж�д��reg�������������0����alu_result��1����MEM�����
                MemWrite,   //MEM��дʹ���ź�
                ALUSrc,     //Ϊ0ʱ��ALU��B���������ԼĴ�����data2��Ϊ1ʱ��������չ��������
                RegWrite,   //�Ĵ�����дʹ��
                PcWrite,    //pc��дʹ�ܣ���ת��ָ����Ϊ1
                IRWrite,    //ir��дʹ���ź�
    output reg  ALUcontrol_op   //alu�Ŀ����ź�
    );
    
    reg [2:0] state = 3'b111, nextState = 3'b000;    //��¼״̬
    //״̬�궨��
    parameter [2:0] initState = 3'b111,
                   IF = 3'b000,
                   ID = 3'b001,
                   EXE = 3'b010,
                   MEM = 3'b100,
                   WB = 3'b011;
                 
    // initial begin
    //    state = 3'b111;
       
    // end
      
   //״̬ת�������Զ���                
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
            if(op == 6'b000000 || op == 6'b001000 || op == 6'b100011)     //R��,addi,lw
                RegWrite = 1;
        end else RegWrite = 0;


        case(op) 
            6'b000000: begin  //R��
                RegDst = 1; Jump = 0; Branch = 0; MemRead =  0; MemtoReg = 0; ALUcontrol_op =  0;  MemWrite = 0; ALUSrc = 0;

            end
        
            6'b001000: begin    //I�� addi
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
