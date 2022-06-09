module DIV(
    input   [31:0]  a,   //被除数
    input   [31:0]  b,    //除数
    input           start,      //启动除法运算
    input           clk,
    input           rst,
    output  [31:0]  q,          //商
    output  [31:0]  r,          //余数
    output reg      busy        //除法器忙标志位
);
    reg     [4:0]   count;
    reg     [31:0]  reg_q;
    reg     [31:0]  reg_r;
    reg     [31:0]  reg_b;
    reg             q_sign;
    reg             r_sign;
    reg             a_sign;
    wire    [32:0]  sub_add = r_sign? {reg_r,reg_q[31]}+{1'b0,reg_b}:{reg_r,reg_q[31]}-{1'b0,reg_b};
    assign r = a_sign? (-(r_sign? reg_r+reg_b:reg_r)):(r_sign? reg_r+reg_b:reg_r);
    assign q = q_sign? -reg_q:reg_q;
    
    always@(posedge clk or posedge rst)
    begin
        if(rst)
            begin 
                count<=0;
                busy<=0;
            end
        else if(start&&(!busy))
        begin 
            count<=0;
            reg_q<=a[31]?-a:a;
            reg_r<=0;
            reg_b<=b[31]?-b:b;
            r_sign<=0;
            busy<=1'b1;
            q_sign<=a[31]^b[31];
            a_sign<=a[31];
        end
        else if(busy)
        begin
            reg_r<=sub_add[31:0];
            r_sign<=sub_add[32];
            reg_q<={reg_q[30:0],~sub_add[32]};
            count<=count+1;
            if(count==31)   busy<=0;
        end
    end
endmodule

module DIVU(
    input   [31:0]  a,   //被除数
    input   [31:0]  b,    //除数
    input           start,      //启动除法运算
    input           clk,
    input           rst,
    output  [31:0]  q,          //商
    output  [31:0]  r,          //余数
    output reg      busy        //除法器忙标志位
);
    reg     [4:0]   count;
    reg     [31:0]  reg_q;
    reg     [31:0]  reg_r;
    reg     [31:0]  reg_b;
    reg             r_sign;
    wire    [32:0]  sub_add = r_sign? ({reg_r,q[31]} + {1'b0,reg_b}):({reg_r,q[31]} - {1'b0,reg_b}); //加、减法器
    assign r = r_sign? reg_r + reg_b : reg_r;
    assign q = reg_q;
    
    always @(posedge clk or posedge rst)
    begin
        if (rst == 1) 
        begin
            count   <=  0;
            busy    <=  0;
        end 
        else 
        begin
            if (start&&(!busy)) 
            begin //初始化
                reg_q   <= a;
                reg_r   <= 32'b0;
                reg_b   <= b;
                r_sign  <= 0;
                count   <= 5'b0;
                busy    <= 1'b1;
            end 
            else if (busy) 
            begin //循环操作
                reg_r   <= sub_add[31:0];   //部分余数
                r_sign  <= sub_add[32];
                reg_q   <= {reg_q[30:0],~sub_add[32]};
                count   <= count + 5'b1;    //计数器加一
                if (count == 31)  busy <= 0;
            end
        end
    end
endmodule