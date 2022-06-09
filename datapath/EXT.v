module EXT(
    input[15:0] imm,input[1:0] extOP,
    output[31:0] extImm
);
    reg[31:0] extImm;
    always @(*) begin
        case (extOP)
            2'b00: extImm={{16{imm[15]}},imm};
            2'b01: extImm={imm,16'h0000};
            2'b10: extImm={16'h0000,imm};
        endcase
    end
endmodule;