module Ctrl(
    input[5:0] opCode,input[5:0] func,input[4:0] brc,input[4:0] cp0c,
    input[31:0] aluOut,input busy,input[5:0] hwInt,input[15:0] sr,
    input clk,input rst,
    output pcWr,
    output pcSrc,
    output irWr,
    output[1:0] aluSrc,
    output bitSrc,
    output[3:0] aluOP,
    output isSigned,
    output[1:0] regWriteDst,
    output[2:0] regWriteSrc,
    output regWrite,
    output memWrite,
    output[1:0] extOP,
    output[1:0] beOP,
    output doutSrc,
    output[2:0] dmOutOP, 
    output[2:0] npcOP,
    output start,
    output muldivSel,
    output exe,
    output hiWe,
    output loWe,
    output cp0We,
    output cp0WriteSrc                                                
);
    reg[3:0] state;
    initial begin
        state=4'b0000;
    end

    wire add;
    wire addu;
    wire sub;
    wire subu;
    wire addi;
    wire addiu;
    wire andn;
    wire andi;
    wire orn;
    wire ori;
    wire xorn;
    wire xori;
    wire norn; 
    wire sll;
    wire srl;
    wire sra;
    wire sllv;
    wire srlv;
    wire srav;
    wire beq;
    wire bne;
    wire blez;
    wire bltz;
    wire bgez;
    wire bgtz;
    wire lui;
    wire slt;
    wire sltu;
    wire slti;
    wire sltiu;
    wire j;
    wire jal;
    wire jr;
    wire jalr;
    wire lw;
    wire sw;
    wire lb;
    wire lbu;
    wire lh;
    wire lhu;
    wire sb;
    wire sh;
    wire mult;
    wire multu;
    wire div;
    wire divu;
    wire mfhi;
    wire mflo;
    wire mthi;
    wire mtlo;
    wire mfc0;
    wire mtc0;
    wire eret;
    
    wire normal; //普通指令
    wire memR; //寄存器读指令
    wire memW; //寄存器写指令
    wire br; //单操作数分支指令
    wire jump; // 跳转指令
    wire muldiv; //乘除运算指令
    wire dirRdWr; //lo\hi寄存器读取指令

    reg beqActiv;
    reg bneActiv;
    reg blezActiv;
    reg bgtzActiv;
    reg bltzActiv;
    reg bgezActiv;

    reg brActiv;

    always @(*) begin
        if(aluOut==0) begin
            beqActiv=1'b1;
            bneActiv=1'b0;
            blezActiv=1'b1;
            bltzActiv=1'b0;
            bgezActiv=1'b1;
            bgtzActiv=1'b0;
        end
        else begin
            beqActiv=1'b0;
            bneActiv=1'b1;
            if(aluOut[31]==1'b0) begin
                blezActiv=1'b0;
                bltzActiv=1'b0;
                bgezActiv=1'b1;
                bgtzActiv=1'b1;
            end
            else begin
                blezActiv=1'b1;
                bltzActiv=1'b1;
                bgezActiv=1'b0;
                bgtzActiv=1'b0;
            end
        end

        brActiv=(beq&beqActiv)|(bne&bneActiv)|(blez&blezActiv)
               |(bltz&bltzActiv)|(bgez&bgezActiv)|(bgtz&bgtzActiv);
    end

    assign add=(~opCode[0])&(~opCode[1])
                &(~opCode[2])&(~opCode[3])
                &(~opCode[4])&(~opCode[5])
                &(~func[0])&(~func[1])
                &(~func[2])&(~func[3])
                &(~func[4])&(func[5]);
    assign addu=(~opCode[0])&(~opCode[1])
                &(~opCode[2])&(~opCode[3])
                &(~opCode[4])&(~opCode[5])
                &(func[0])&(~func[1])
                &(~func[2])&(~func[3])
                &(~func[4])&(func[5]);
    assign sub=(~opCode[0])&(~opCode[1])
                &(~opCode[2])&(~opCode[3])
                &(~opCode[4])&(~opCode[5])
                &(~func[0])&(func[1])
                &(~func[2])&(~func[3])
                &(~func[4])&(func[5]);
    assign subu=(~opCode[0])&(~opCode[1])
                &(~opCode[2])&(~opCode[3])
                &(~opCode[4])&(~opCode[5])
                &(func[0])&(func[1])
                &(~func[2])&(~func[3])
                &(~func[4])&(func[5]);
    assign addi=(~opCode[0])&(~opCode[1])
                &(~opCode[2])&(opCode[3])
                &(~opCode[4])&(~opCode[5]);
    assign addiu=(opCode[0])&(~opCode[1])
                &(~opCode[2])&(opCode[3])
                &(~opCode[4])&(~opCode[5]);
    assign andn=(~opCode[0])&(~opCode[1])
                &(~opCode[2])&(~opCode[3])
                &(~opCode[4])&(~opCode[5])
                &(~func[0])&(~func[1])
                &(func[2])&(~func[3])
                &(~func[4])&(func[5]);
    assign andi=(~opCode[0])&(~opCode[1])
                &(opCode[2])&(opCode[3])
                &(~opCode[4])&(~opCode[5]);
    assign orn=(~opCode[0])&(~opCode[1])
                &(~opCode[2])&(~opCode[3])
                &(~opCode[4])&(~opCode[5])
                &(func[0])&(~func[1])
                &(func[2])&(~func[3])
                &(~func[4])&(func[5]);
    assign ori=(opCode[0])&(~opCode[1])
                &(opCode[2])&(opCode[3])
                &(~opCode[4])&(~opCode[5]);
    assign xorn=(~opCode[0])&(~opCode[1])
                &(~opCode[2])&(~opCode[3])
                &(~opCode[4])&(~opCode[5])
                &(~func[0])&(func[1])
                &(func[2])&(~func[3])
                &(~func[4])&(func[5]);
    assign xori=(~opCode[0])&(opCode[1])
                &(opCode[2])&(opCode[3])
                &(~opCode[4])&(~opCode[5]);
    assign norn=(~opCode[0])&(~opCode[1])
                &(~opCode[2])&(~opCode[3])
                &(~opCode[4])&(~opCode[5])
                &(func[0])&(func[1])
                &(func[2])&(~func[3])
                &(~func[4])&(func[5]);
    assign sll=(~opCode[0])&(~opCode[1])
                &(~opCode[2])&(~opCode[3])
                &(~opCode[4])&(~opCode[5])
                &(~func[0])&(~func[1])
                &(~func[2])&(~func[3])
                &(~func[4])&(~func[5]);
    assign sllv=(~opCode[0])&(~opCode[1])
                &(~opCode[2])&(~opCode[3])
                &(~opCode[4])&(~opCode[5])
                &(~func[0])&(~func[1])
                &(func[2])&(~func[3])
                &(~func[4])&(~func[5]);
    assign srl=(~opCode[0])&(~opCode[1])
                &(~opCode[2])&(~opCode[3])
                &(~opCode[4])&(~opCode[5])
                &(~func[0])&(func[1])
                &(~func[2])&(~func[3])
                &(~func[4])&(~func[5]);
    assign srlv=(~opCode[0])&(~opCode[1])
                &(~opCode[2])&(~opCode[3])
                &(~opCode[4])&(~opCode[5])
                &(~func[0])&(func[1])
                &(func[2])&(~func[3])
                &(~func[4])&(~func[5]);
    assign sra=(~opCode[0])&(~opCode[1])
                &(~opCode[2])&(~opCode[3])
                &(~opCode[4])&(~opCode[5])
                &(func[0])&(func[1])
                &(~func[2])&(~func[3])
                &(~func[4])&(~func[5]);
    
    
    assign srav=(~opCode[0])&(~opCode[1])
                &(~opCode[2])&(~opCode[3])
                &(~opCode[4])&(~opCode[5])
                &(func[0])&(func[1])
                &(func[2])&(~func[3])
                &(~func[4])&(~func[5]);
    assign beq=(~opCode[0])&(~opCode[1])
                &(opCode[2])&(~opCode[3])
                &(~opCode[4])&(~opCode[5]);
    assign bne=(opCode[0])&(~opCode[1])
                &(opCode[2])&(~opCode[3])
                &(~opCode[4])&(~opCode[5]);
    assign blez=(~opCode[0])&(opCode[1])
                &(opCode[2])&(~opCode[3])
                &(~opCode[4])&(~opCode[5]);
    assign bltz=(opCode[0])&(~opCode[1])
                &(~opCode[2])&(~opCode[3])
                &(~opCode[4])&(~opCode[5])
                &(~brc[0])&(~brc[1])&(~brc[2])
                &(~brc[3])&(~brc[4]);
    assign bgez=(opCode[0])&(~opCode[1])
                &(~opCode[2])&(~opCode[3])
                &(~opCode[4])&(~opCode[5])
                &(brc[0])&(~brc[1])&(~brc[2])
                &(~brc[3])&(~brc[4]);
    assign bgtz=(opCode[0])&(opCode[1])
                &(opCode[2])&(~opCode[3])
                &(~opCode[4])&(~opCode[5]);
    assign lui=(opCode[0])&(opCode[1])
                &(opCode[2])&(opCode[3])
                &(~opCode[4])&(~opCode[5]);
    assign slt=(~opCode[0])&(~opCode[1])
                &(~opCode[2])&(~opCode[3])
                &(~opCode[4])&(~opCode[5])
                &(~func[0])&(func[1])
                &(~func[2])&(func[3])
                &(~func[4])&(func[5]);
    assign sltu=(~opCode[0])&(~opCode[1])
                &(~opCode[2])&(~opCode[3])
                &(~opCode[4])&(~opCode[5])
                &(func[0])&(func[1])
                &(~func[2])&(func[3])
                &(~func[4])&(func[5]);
    assign slti=(~opCode[0])&(opCode[1])
                &(~opCode[2])&(opCode[3])
                &(~opCode[4])&(~opCode[5]);
    assign sltiu=(opCode[0])&(opCode[1])
                &(~opCode[2])&(opCode[3])
                &(~opCode[4])&(~opCode[5]);
    assign j=(~opCode[0])&(opCode[1])
                &(~opCode[2])&(~opCode[3])
                &(~opCode[4])&(~opCode[5]);
    assign jal=(opCode[0])&(opCode[1])
                &(~opCode[2])&(~opCode[3])
                &(~opCode[4])&(~opCode[5]);
    assign jalr=(~opCode[0])&(~opCode[1])
                &(~opCode[2])&(~opCode[3])
                &(~opCode[4])&(~opCode[5])
                &(func[0])&(~func[1])
                &(~func[2])&(func[3])
                &(~func[4])&(~func[5]);;
    assign jr=(~opCode[0])&(~opCode[1])
                &(~opCode[2])&(~opCode[3])
                &(~opCode[4])&(~opCode[5])
                &(~func[0])&(~func[1])
                &(~func[2])&(func[3])
                &(~func[4])&(~func[5]);
    assign lw=(opCode[0])&(opCode[1])
                &(~opCode[2])&(~opCode[3])
                &(~opCode[4])&(opCode[5]);
    assign sw=(opCode[0])&(opCode[1])
                &(~opCode[2])&(opCode[3])
                &(~opCode[4])&(opCode[5]);
    assign lb=(~opCode[0])&(~opCode[1])
                &(~opCode[2])&(~opCode[3])
                &(~opCode[4])&(opCode[5]);
    assign lbu=(~opCode[0])&(~opCode[1])
                &(opCode[2])&(~opCode[3])
                &(~opCode[4])&(opCode[5]);
    assign lh=(opCode[0])&(~opCode[1])
                &(~opCode[2])&(~opCode[3])
                &(~opCode[4])&(opCode[5]);
    assign lhu=(opCode[0])&(~opCode[1])
                &(opCode[2])&(~opCode[3])
                &(~opCode[4])&(opCode[5]);
    assign sb=(~opCode[0])&(~opCode[1])
                &(~opCode[2])&(opCode[3])
                &(~opCode[4])&(opCode[5]);
    assign sh=(opCode[0])&(~opCode[1])
                &(~opCode[2])&(opCode[3])
                &(~opCode[4])&(opCode[5]);
    assign mult=(~opCode[0])&(~opCode[1])
                &(~opCode[2])&(~opCode[3])
                &(~opCode[4])&(~opCode[5])
                &(~func[0])&(~func[1])
                &(~func[2])&(func[3])
                &(func[4])&(~func[5]);
    assign multu=(~opCode[0])&(~opCode[1])
                &(~opCode[2])&(~opCode[3])
                &(~opCode[4])&(~opCode[5])
                &(func[0])&(~func[1])
                &(~func[2])&(func[3])
                &(func[4])&(~func[5]);
    assign div=(~opCode[0])&(~opCode[1])
                &(~opCode[2])&(~opCode[3])
                &(~opCode[4])&(~opCode[5])
                &(~func[0])&(func[1])
                &(~func[2])&(func[3])
                &(func[4])&(~func[5]);
    assign divu=(~opCode[0])&(~opCode[1])
                &(~opCode[2])&(~opCode[3])
                &(~opCode[4])&(~opCode[5])
                &(func[0])&(func[1])
                &(~func[2])&(func[3])
                &(func[4])&(~func[5]);
    assign mfhi=(~opCode[0])&(~opCode[1])
                &(~opCode[2])&(~opCode[3])
                &(~opCode[4])&(~opCode[5])
                &(~func[0])&(~func[1])
                &(~func[2])&(~func[3])
                &(func[4])&(~func[5]);
    assign mflo=(~opCode[0])&(~opCode[1])
                &(~opCode[2])&(~opCode[3])
                &(~opCode[4])&(~opCode[5])
                &(~func[0])&(func[1])
                &(~func[2])&(~func[3])
                &(func[4])&(~func[5]);
    assign mthi=(~opCode[0])&(~opCode[1])
                &(~opCode[2])&(~opCode[3])
                &(~opCode[4])&(~opCode[5])
                &(func[0])&(~func[1])
                &(~func[2])&(~func[3])
                &(func[4])&(~func[5]);
    assign mtlo=(~opCode[0])&(~opCode[1])
                &(~opCode[2])&(~opCode[3])
                &(~opCode[4])&(~opCode[5])
                &(func[0])&(func[1])
                &(~func[2])&(~func[3])
                &(func[4])&(~func[5]);
    assign mfc0=(~opCode[0])&(~opCode[1])
                &(~opCode[2])&(~opCode[3])
                &(opCode[4])&(~opCode[5])
                &(~cp0c[0])&(~cp0c[1])
                &(~cp0c[2])&(~cp0c[3])
                &(~cp0c[4]);
    assign mtc0=(~opCode[0])&(~opCode[1])
                &(~opCode[2])&(~opCode[3])
                &(opCode[4])&(~opCode[5])
                &(~cp0c[0])&(~cp0c[1])
                &(cp0c[2])&(~cp0c[3])
                &(~cp0c[4]);
    assign eret=(~opCode[0])&(~opCode[1])
                &(~opCode[2])&(~opCode[3])
                &(opCode[4])&(~opCode[5])
                &(~func[0])&(~func[1])
                &(~func[2])&(func[3])
                &(func[4])&(~func[5]);
    
    assign normal=add|addu|sub|subu|addi|addiu|andn|andi|orn|ori|xorn|xori|norn
                 |sll|sllv|srl|srlv|sra|srav|lui|slt|slti|sltu|sltiu;
    assign memR=lw|lb|lbu|lh|lhu;
    assign memW=sw|sb|sh;
    assign br=beq|bne|blez|bltz|bgez|bgtz;
    assign jump=j|jal|jalr|jr|eret;
    assign muldiv=mult|multu|div|divu;
    assign dirRdWr=mfhi|mflo||mthi|mtlo|mfc0|mtc0;

    wire s0=(~state[0])&(~state[1])&(~state[2])&(~state[3]); //取值
    wire s1=(state[0])&(~state[1])&(~state[2])&(~state[3]); //译码
    wire s2=(~state[0])&(state[1])&(~state[2])&(~state[3]); //ALU运算
    wire s3=(state[0])&(state[1])&(~state[2])&(~state[3]); //存储器读
    wire s4=(~state[0])&(~state[1])&(state[2])&(~state[3]); //存储器写回寄存器
    wire s5=(state[0])&(~state[1])&(state[2])&(~state[3]); //存储器写
    wire s6=(~state[0])&(state[1])&(state[2])&(~state[3]); //ALU结果写回
    wire s7=(state[0])&(state[1])&(state[2])&(~state[3]); //分支指令
    wire s8=(~state[0])&(~state[1])&(~state[2])&(state[3]); //跳转
    wire s9=(state[0])&(~state[1])&(~state[2])&(state[3]); //乘除运算
    wire s10=(~state[0])&(state[1])&(~state[2])&(state[3]); //中断处理

    assign pcWr=s0|(s8&(jump))|(s7&brActiv)|s10;
    assign pcSrc=(s7&brActiv)|(s8&jump)|s10;
    assign irWr=s0;
    assign cmpSrc=br;
    assign aluSrc[0]=addi|addiu|andi|ori|xori|lw|sw|lui|lb|lbu|lh|lhu|sb|sh|slti;
    assign aluSrc[1]=blez|bltz|bgez|bgtz;
    assign bitSrc=sllv|srlv|srav;
    assign aluOP[0]=add|addu|addi|addiu|orn|ori|lui|memR|memW|norn|srl|srlv;
    assign aluOP[1]=add|addu|sub|subu|addi|addiu|br|memR|memW|slt|sltu|slti|sltiu|sll|sllv|srl|srlv;
    assign aluOP[2]=xorn|xori|norn|sll|sllv|srl|srlv;
    assign aluOP[3]=sra|srav;
    assign isSigned=slt|slti|mult|div|sra|srav;
    assign regWriteDst[0]=add|addu|sub|subu|andn|orn|xorn|norn|slt|sltu|jalr|mfhi|mflo;
    assign regWriteDst[1]=jal;
    assign regWriteSrc[0]=lw|lb|lbu|lh|lhu|slt|sltu|slti|sltiu|mflo;
    assign regWriteSrc[1]=jal|jalr|slt|sltu|slti|sltiu|mfc0;
    assign regWriteSrc[2]=mfhi|mflo|mfc0;
    assign regWrite=(s4&(memR|mfhi|mflo|mfc0))|(s6&normal)|(s8&(jal|jalr));
    assign memWrite=s5&memW;
    assign extOP[0]=lui;
    assign extOP[1]=ori;
    assign beOP[0]=lh|lhu|sh;
    assign beOP[1]=lw|sw;
    assign dmOutOP[0]=lbu|lhu;
    assign dmOutOP[1]=lh|lhu;
    assign dmOutOP[2]=lw;
    assign npcOP[0]=(s7&br)|(s8&(jalr|jr|eret));
    assign npcOP[1]=s8&(j|jal|jalr|jr);
    assign npcOP[2]=s10|(s8&eret);
    assign start=s9&(div|divu);
    assign muldivSel=div|divu;
    assign exe=s9;
    assign hiWe=s4&mthi;
    assign loWe=s4&mtlo;
    assign cp0We=(s4&mtc0)|s10;
    assign cp0WriteSrc=s10;

    reg divStartReg;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            state<=4'b0000;

            beqActiv<=1'b0;
            bneActiv<=1'b0;
            blezActiv<=1'b0;
            bltzActiv<=1'b0;
            bgezActiv<=1'b0;
            bgtzActiv<=1'b0;

            brActiv<=1'b0;

            divStartReg<=1'b0;
        end
        else if(state>=4 && state<=9 && (hwInt&sr[15:10]) && sr[1] && ~busy) begin
            state<=4'b1010;
        end
        else if(s9&(busy|((div|divu)&divStartReg))) begin
            state<=4'b1001;
            if(divStartReg) begin
                divStartReg<=1'b0;
            end
        end
        else begin
            state[0]<=s0|(s1&muldiv)|(s2&(memR|memW|br));
            state[1]<=(s1&(memR|memW|normal|br))|(s2&(memR|normal|br));
            state[2]<=(s1&dirRdWr)|(s2&(memW|normal|br))|(s3&memR);
            state[3]<=s1&(jump|muldiv);
            divStartReg<=1'b1;
        end
        
    end
    

endmodule