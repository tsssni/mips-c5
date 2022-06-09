`include "MIPS.v"
`include "BRG.v"
`include "TIMER.v"

module MINI_MACHINE (
    input clk,
    input rst
);
    wire[5:0] hwInt;
    wire[31:2] prAddr;
    wire prWe;
    wire[3:0] prBe;
    wire[31:0] prDout;

    wire[31:0] devRd;
    wire irq;
    wire[3:2] devAddr;
    wire devWe;
    wire[31:0] devWd;
    wire[31:0] prRd;
    wire devClk;
    wire devRst;

    MIPS mips_m(.prDin(prRd),.hwInt(hwInt),.clk(clk),.rst(rst),
    .prAddr(prAddr),.prWe(prWe),.prBe(prBe),.prDout(prDout));

    BRG brg_m(.prAddr(prAddr),.prWd(prDout),.prWe(prWe),.prBe(prBe),
    .devRd(devRd),.irq(irq),.clk(clk),.rst(rst),.devAddr(devAddr),
    .devWe(devWe),.devWd(devWd),.hwInt(hwInt),.prRd(prRd),
    .devClk(devClk),.devRst(devRst));

    TIMER timer_m(.addr(devAddr),.we(devWe),.din(devWd),.clk(clk),
    .rst(rst),.dout(devRd),.irq(irq));
    
endmodule