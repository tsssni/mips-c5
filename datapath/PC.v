module PC(
    input[31:2] npc,input pcWr,
    input clk,input rst,
    output[31:2] pc
);
    reg[31:2] pcReg;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            pcReg<={18'b0,12'hc00};
        end
        else if(pcWr) begin
            pcReg<=npc;
        end
    end

    assign pc=pcReg;
endmodule