module ALU (
    input[31:0] a,input[31:0] b,input[4:0] bitNum,
    input[3:0] aluOP,input isSigned,input clk,input rst,
    output[31:0] s,output sign
);
    reg[32:0] sReg;
    reg sign;

    reg[32:0] a_;
    reg[32:0] b_;

    always @(*) begin
        if(~isSigned) begin
            a_={1'b0,a};
            b_={1'b0,b}; 
        end
        else begin
            a_={a[31],a};
            b_={b[31],b};
        end
    end

    

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            sReg<=0;
        end
        else begin
            case (aluOP)
                4'b0000: sReg<=a_&b_;
                4'b0001: sReg<=a_|b_;
                4'b0010: sReg<=a_-b_;
                4'b0011: sReg<=a_+b_;
                4'b0100: sReg<=a_^b_;
                4'b0101: sReg<=~(a_|b_);
                4'b0110: sReg<=b_<<bitNum;
                4'b0111: sReg<=b_>>bitNum;
                4'b1000: sReg<=($signed(b_))>>>bitNum;
            endcase
        end
        
    end

    always @(*) begin
        if(isSigned==0 || (sReg[32]^sReg[31])==1) begin
            sign=sReg[32];
        end
        else begin
            sign=sReg[31];
        end
    end

    assign s=sReg[31:0];
endmodule