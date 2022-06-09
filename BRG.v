module BRG (
    input[31:2] prAddr,input[31:0] prWd,
    input prWe,input[3:0] prBe,
    input[31:0] devRd,input irq,
    input clk,input rst,
    output[3:2] devAddr,output reg devWe,output[31:0] devWd,
    output[5:0] hwInt,output[31:0] prRd,
    output devClk,output devRst
);
    assign devAddr=prAddr[3:2];
    assign devWd=prWd;
    assign hwInt={4'b0,irq};
    assign prRd=devRd;
    assign devClk=clk;
    assign devRst=rst;

    always @(*) begin
        if(prWe && prAddr>=30'h1fc0 && prAddr<=30'h1fc2) begin
            devWe=1'b1;
        end
        else begin
            devWe=1'b0;
        end
    end
endmodule