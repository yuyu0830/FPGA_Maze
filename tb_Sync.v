`timescale 1ns / 1ns

module tb_Sync;
    reg Clk;
    reg Rst;

    always #10 Clk = ~Clk;

    Sync S0(Clk, Rst, 6'd40, , , , , , ,);

    initial
    begin
        Clk = 1;
        Rst = 0;

        @(negedge Clk) Rst = 1;
        #64_000_000


        $stop;

    end
endmodule;