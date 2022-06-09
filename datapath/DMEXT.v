module DMEXT (
    input[31:0] dextIn,input[2:0] dmOutOP,
    input clk,input rst,
    output[31:0] dmOut
);
    reg[31:0] dmOutReg;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            dmOutReg<=0;
        end
        else begin
            case (dmOutOP)
                3'b000:dmOutReg<={{24{dextIn[7]}},dextIn[7:0]};
                3'b001:dmOutReg<={24'h000000,dextIn[7:0]};
                3'b010:dmOutReg<={{16{dextIn[15]}},dextIn[15:0]};
                3'b011:dmOutReg<={16'h0000,dextIn[15:0]};
                3'b100:dmOutReg<=dextIn;
            endcase
        end
        
    end

    assign dmOut=dmOutReg;
endmodule