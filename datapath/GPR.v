module GPR(
    input[4:0] a1,input[4:0] a2,
    input[31:0] writeSrc,input[4:0] a3,input regWrite,
    input clk,input rst,
    output[31:0] rd1,output[31:0] rd2
);
    reg[31:0] r[31:0];
    reg[31:0] rd1Reg;
    reg[31:0] rd2Reg;


    always @(posedge clk or posedge rst) begin
        if(rst) begin
            for(integer i=0;i<=31;i=i+1) begin
                r[i]<=32'h00000000;
            end 

            rd1Reg<=0;
            rd2Reg<=0;
        end
        else begin
            rd1Reg<=r[a1];
            rd2Reg<=r[a2];

            if(regWrite && a3!=0) begin
                r[a3]<=writeSrc;
            end
        end
        
    end

    assign rd1=rd1Reg;
    assign rd2=rd2Reg;
endmodule