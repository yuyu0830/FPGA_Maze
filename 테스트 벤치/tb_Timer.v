`timescale 1ns/1ns
module tb_Timer();
    reg Clk;
    reg Rst;
    reg Enable;

    wire [3:0] T_Sec0, T_Sec1;

    Timer T0(Clk, Rst, Enable, T_Sec0, T_Sec1);

    always #10 Clk = ~Clk;

    initial
    begin
        Clk = 1;
        Rst = 0;
        Enable = 0;

        @(negedge Clk) Rst = 1;
        Enable = 1;
        #222_222_200 Enable = 0;
        #222_222;

        $stop;
    end
endmodule