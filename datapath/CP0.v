module CP0 (
    input[4:0] addr,input we,
    input writeSrc,input[31:0] din,
    input clk,input rst,
    output reg[31:0] dout,output[15:0] srRd,output[31:0] epcRd
);
    reg[31:0] sr;
    reg[31:0] cause;
    reg[31:0] epc;
    reg[31:0] prid;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            prid<=0;
            sr<={16'b0,6'b111111,8'b0,2'b11};
            cause<=0;
            epc<=0;
        end
        else if(we) begin
            case (addr)
                5'b01000:prid<=din; 
                5'b01100:sr<=din;
                5'b01101:cause<=din;
                5'b01110:epc<=din; 
            endcase
            if(writeSrc==1'b1) begin
                sr<=32'h0000fc01;
            end
        end
    end

    always @(*) begin
        case (addr)
            5'b01000:dout=prid; 
            5'b01100:dout=sr;
            5'b01101:dout=cause;
            5'b01110:dout=epc; 
        endcase
    end

    assign srRd=sr;
    assign epcRd=epc;
endmodule