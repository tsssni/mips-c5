module DM(
    input[13:2]  addr,
    input[3:0] be,
    input[31:0]  din,
    input we,
    input rst,
    output[31:0] dout
);
    reg[31:0] dm[3071:0];
    reg[31:0] dout;
    wire[31:0] be_={{4{be[3]}},{4{be[2]}},{4{be[1]}},{4{be[0]}}};

    always @(posedge rst) begin
        for(integer i=0;i<=1023;i=i+1) begin
            dm[i]<=32'h00000000;
        end
    end
    
    always @(*) begin
        if(addr<3072) begin
            if(we) begin
                dm[addr]=(be_&din)|((~be_)&dm[addr]); 
            end

            else begin
                case (be)
                    4'b0001:dout={24'h000000,dm[addr][7:0]};
                    4'b0010:dout={24'h000000,dm[addr][15:8]};
                    4'b0100:dout={24'h000000,dm[addr][23:16]};
                    4'b1000:dout={24'h000000,dm[addr][31:24]};
                    4'b0011:dout={16'h0000,dm[addr][15:0]};
                    4'b1100:dout={16'h0000,dm[addr][31:16]};
                    4'b1111:dout=dm[addr];
                endcase  
            end
        end
        
        
    end
endmodule