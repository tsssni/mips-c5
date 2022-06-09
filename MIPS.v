`include "datapath/ALU.v"
`include "datapath/BEEXT.v"
`include "datapath/DM.v"
`include "datapath/DMEXT.v"
`include "datapath/EXT.v"
`include "datapath/GPR.v"
`include "datapath/IM.v"
`include "datapath/NPC.v"
`include "datapath/PC.v"
`include "datapath/MULDIV.v"
`include "datapath/CP0.v"
`include "controller/Ctrl.v"

module MIPS(
    input[31:0] prDin,
    input[5:0] hwInt,
    input clk,
    input rst,
    output[31:2] prAddr,
    output prWe,
    output[3:0] prBe,
    output[31:0] prDout
);
    wire[2:0] npcOP;
    wire[31:0] pcPlus4;
    wire[31:2] npc;

    reg[31:2] pcIn;
    wire pcWr;
    wire pcSrc;
    wire[31:2] pc;
    
    wire[31:0] instr;
    wire irWr;
    
    wire cmpSrc;
    reg[31:0] cmp;
    
    reg[4:0] writeReg;
    reg[31:0] writeSrc;
    wire[1:0] regWriteDst;
    wire[2:0] regWriteSrc;
    wire regWrite;
    wire[31:0] rd1;
    wire[31:0] rd2;

    wire[1:0] extOP;
    wire[31:0] extImm;

    wire[1:0] aluSrc;
    wire bitSrc;
    reg[4:0] bitNum;
    wire[3:0] aluOP;
    wire isSigned;
    wire[32:1] aluOpNum1=rd1;
    reg[32:1] aluOpNum2;
    wire[31:0] aluOut;
    wire sign;

    wire memWrite;
    wire[3:0] be;
    wire[1:0] beOP;
    wire[31:0] dout;
    wire[2:0] dmOutOP;
    wire[31:0] dmOut;

    reg[31:0] dextIn;

    wire start;
    wire muldivSel;
    wire hiWe;
    wire loWe;
    wire exe;
    wire[31:0] hi;
    wire[31:0] lo;
    wire busy;

    wire cp0We;
    wire cp0WriteSrc;
    reg[31:0] cp0In;
    reg[4:0] cp0Addr;
    wire[31:0] cp0Out;
    wire[15:0] srRd;
    wire[31:0] epcRd;

    always @(*) begin
        case (pcSrc)
            0:pcIn=pcPlus4[31:2];
            1:pcIn=npc; 
        endcase
    end

    PC pc_m(.npc(pcIn),.pcWr(pcWr),.clk(clk),
    .rst(rst),.pc(pc));

    IM im_m(.addr(pc[14:2]),.irWr(irWr),.clk(clk),.rst(rst),.dout(instr)); 

    Ctrl ctrl_m(.opCode(instr[31-:6]),.func(instr[5:0]),.brc(instr[20:16]),.cp0c(instr[25-:5]),
                .aluOut(aluOut),.busy(busy),.hwInt(hwInt),.sr(srRd),
                .clk(clk),.rst(rst),
                .pcWr(pcWr),
                .pcSrc(pcSrc),
                .irWr(irWr),
                .aluSrc(aluSrc),
                .bitSrc(bitSrc),
                .aluOP(aluOP),
                .isSigned(isSigned),
                .regWriteDst(regWriteDst),
                .regWriteSrc(regWriteSrc),
                .regWrite(regWrite),
                .memWrite(memWrite),
                .extOP(extOP),
                .beOP(beOP),
                .dmOutOP(dmOutOP),
                .npcOP(npcOP),
                .start(start),
                .muldivSel(muldivSel),
                .exe(exe),
                .hiWe(hiWe),
                .loWe(loWe),
                .cp0We(cp0We),
                .cp0WriteSrc(cp0WriteSrc));

    always @(*) begin
        case (regWriteDst)
            2'b00:writeReg=instr[20:16]; 
            2'b01:writeReg=instr[15:11];
            2'b10:writeReg=5'b11111; 
        endcase

        case (regWriteSrc)
            3'b000:writeSrc=aluOut;
            3'b001:writeSrc=dmOut;
            3'b010:writeSrc={pc,2'b00};
            3'b011:writeSrc={31'b0,sign}; 
            3'b100:writeSrc=hi;
            3'b101:writeSrc=lo;
            3'b110:writeSrc=cp0Out;
        endcase
    end

    GPR gpr_m(.a1(instr[25:21]),.a2(instr[20:16]),
            .writeSrc(writeSrc),.a3(writeReg),.regWrite(regWrite),
            .clk(clk),.rst(rst),
            .rd1(rd1),.rd2(rd2)); 

    EXT ext_m(.imm(instr[15:0]),.extOP(extOP),.extImm(extImm));   

    always @(*) begin
        case (aluSrc)
            2'b00:aluOpNum2=rd2;
            2'b01:aluOpNum2=extImm;
            2'b10:aluOpNum2=32'b0;
        endcase
        
        case (bitSrc)
            1'b0:bitNum=instr[10:6]; 
            1'b1:bitNum=rd1[4:0]; 
        endcase
    end
    
    ALU alu_m(.a(aluOpNum1),.b(aluOpNum2),.bitNum(bitNum),
    .aluOP(aluOP),.isSigned(isSigned),.clk(clk),.rst(rst),
    .s(aluOut),.sign(sign));  

    BEEXT beext_m(.aluOut(aluOut),.beOP(beOP),.be(be));   

    DM dm_m(.addr(aluOut[13:2]),.be(be),.din(rd2),.we(memWrite),.dout(dout));

    always @(*) begin
        if(aluOut[15:2]>=0 && aluOut[15:2]<=3072) begin
            dextIn=dout;
        end
        else if(aluOut[15:0]>=16'h7f00 && aluOut[15:0]<=16'h7fb0) begin
            dextIn=prDin;
        end
    end

    DMEXT dmext_m(.dextIn(dextIn),.dmOutOP(dmOutOP),.clk(clk),.rst(rst),.dmOut(dmOut));

    NPC npc_m(.pc(pc),.imm(instr[25:0]),.rd1(rd1),.npcOP(npcOP),.epc(epcRd),
    .npc(npc),.pcPlus4(pcPlus4));

    MULDIV muldiv_m(.a(rd1),.b(rd2),.isSigned(isSigned),.start(start),.muldivSel(muldivSel),
    .hiWe(hiWe),.loWe(loWe),.exe(exe),.clk(clk),.rst(rst),.hi(hi),.lo(lo),.busy(busy));

    always @(*) begin
        case (cp0WriteSrc)
            1'b0:begin 
                cp0In=rd2; 
                cp0Addr=instr[15:11];
            end
            1'b1:begin 
                cp0In={pc,2'b00}; 
                cp0Addr=5'b01110;
            end
        endcase
    end

    CP0 cp0_m(.addr(cp0Addr),.we(cp0We),.writeSrc(cp0WriteSrc),.din(cp0In),
    .clk(clk),.rst(rst),.dout(cp0Out),.srRd(srRd),.epcRd(epcRd));

    assign prAddr=aluOut[31:2];
    assign prWe=memWrite;
    assign prBe=be;
    assign prDout=rd2;
endmodule