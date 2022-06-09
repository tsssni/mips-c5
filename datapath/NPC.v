module NPC (
    input[31:2] pc,input[25:0] imm,
    input[31:0] rd1,input[31:0] epc,
    input[2:0] npcOP,
    output[31:2] npc,output[31:0] pcPlus4
);
    reg[31:2] npc;
    reg[31:0] pcPlus4;

    always @(*) begin
        pcPlus4={pc+1'b1,2'b00}; 

        case (npcOP)
            3'b000:npc=pcPlus4[31:2];
            3'b001:npc=pc+{{14{imm[15]}},imm[15:0]};
            3'b010:npc={pc[31:28],imm}; 
            3'b011:npc=rd1[31:2];
            3'b100:npc=30'h00001060;
            3'b101:npc=epc[31:2];
        endcase
    end
endmodule