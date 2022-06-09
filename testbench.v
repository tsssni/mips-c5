`timescale 1ns / 1ns
`include "MINI_MACHINE.v"

module testbench (
    
);
    reg clk;
    reg rst;

    MINI_MACHINE mini_machine_m(.clk(clk),.rst(rst));
    

    initial begin
        clk=1'b0;
        rst=1'b0;

        $monitor("%d %h %d %h %h %h %h %h",
        $time,
        mini_machine_m.mips_m.instr,
        mini_machine_m.timer_m.count,
        mini_machine_m.brg_m.prAddr,
        mini_machine_m.mips_m.ctrl_m.state,
        mini_machine_m.mips_m.cp0_m.din,
        mini_machine_m.mips_m.hi,
        mini_machine_m.mips_m.lo);
        
        #10 rst=1'b1;
        #5 rst=1'b0;
        #75000 $finish;
    end

    always #20 clk=~clk;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars;
    end
    
endmodule