module BEEXT (
    input[31:0] aluOut,input[1:0] beOP,
    output[3:0] be
);
    reg[3:0] be;
    always @(*) begin
        if(beOP[1]) begin
            be=4'b1111;
        end
        else if(~beOP[0]) begin
            case (aluOut[1:0])
                2'b00:be=4'b0001; 
                2'b01:be=4'b0010;
                2'b10:be=4'b0100;
                2'b11:be=4'b1000;
            endcase
        end
        else begin
            case (aluOut[1])
                1'b0:be=4'b0011;
                1'b1:be=4'b1100; 
            endcase
        end
    end    
endmodule