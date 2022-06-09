module IM (
    input[14:2] addr,input irWr,
    input clk,input rst,
    output[31:0] dout
);
    reg[31:0] im[2047:0];
    reg[31:0] doutReg;
    initial begin
        $readmemh("./code.txt",im,12'h000,12'h054);
        $readmemh("./intr.txt",im,12'h460,12'h46c);
    end
   
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            doutReg<=im[0];
        end
        else if(irWr) begin
            doutReg<=im[addr-12'hc00];
        end
    end 

    assign dout=doutReg;       
   
endmodule