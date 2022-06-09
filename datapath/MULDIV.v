`include "datapath/MULT.v"
`include "datapath/DIV.v"

module MULDIV (
    input[31:0] a,
    input[31:0] b,
    input isSigned,
    input start,
    input muldivSel,
    input hiWe,
    input loWe,
    input exe,
    input clk,
    input rst,
    output[31:0] hi,
    output[31:0] lo,
    output busy
);
    wire[63:0] s;
    wire startDiv=start&isSigned;
    wire startDivU=start&(~isSigned);
    wire[31:0] q;
    wire[31:0] qu;
    wire[31:0] r;
    wire[31:0] ru;
    
    wire busy_;
    wire busy_u;
    reg busy;

    reg[31:0] hiReg;
    reg[31:0] loReg;

    MULT mult_m(.a(a),.b(b),.isSigned(isSigned),.clk(clk),.rst(rst),.s(s));

    DIV div_m(.a(a),.b(b),.start(startDiv),.clk(clk),.rst(rst),.q(q),.r(r),.busy(busy_));

    DIVU divu_m(.a(a),.b(b),.start(startDivU),.clk(clk),.rst(rst),.q(qu),.r(ru),.busy(busy_u));

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            hiReg<=0;
            loReg<=0;
        end
        else begin
            if(hiWe) begin
                hiReg<=a;
            end
            else if(loWe) begin
                loReg<=a;
            end
            else if(exe && ~muldivSel) begin
                hiReg<=s[63:32];
                loReg<=s[31:0];
            end
            else if(exe && muldivSel && isSigned) begin
                hiReg<=r;
                loReg<=q;
            end
            else if(exe && muldivSel && ~isSigned)begin
                hiReg<=ru;
                loReg<=qu;
            end
        end
        
    end

    always @(*) begin
        if(isSigned) begin
            busy=busy_;
        end
        else begin
            busy=busy_u;
        end
    end

    assign hi=hiReg;
    assign lo=loReg;
    
endmodule