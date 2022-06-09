module TIMER (
    input[3:2] addr,input we,input[31:0] din,
    input clk,input rst,
    output reg[31:0] dout,output reg irq
);
    reg[31:0] ctrl;
    reg[31:0] preset;
    reg[31:0] count;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            ctrl<={28'b0,4'b1001};
            preset<=128;
            count<=128;
        end
        else begin
            if(we) begin
                case (addr)
                    2'b00:ctrl<=din;
                    2'b01:preset<=din;
                    2'b10:count<=din; 
                endcase
                irq<=1'b0;
            end
            else begin
                if(ctrl[0]) begin
                    count<=count-1;    
                end

                if(count==0) begin
                    if(ctrl[2:1]==2'b00) begin
                        ctrl[0]<=1'b0;
                        if(ctrl[3]) begin
                            irq<=1'b1;
                            ctrl[3]<=1'b0;
                        end
                    end
                    else if(ctrl[2:1]==2'b01) begin
                        count<=preset;
                    end
                end  
            end
        end

        

        
    end

    always @(*) begin
        case (addr)
            2'b00:dout=ctrl;
            2'b01:dout=preset;
            2'b10:dout=count; 
        endcase
    end
endmodule