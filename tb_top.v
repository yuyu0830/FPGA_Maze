`timescale 1ns / 1ps

module Top_tb;
    reg Clk;
    reg Rst;
    reg [3:0] Keyboard;
    wire fDrawDone;

    wire [6:0] o_FND0, o_FND1, o_FND2;
    wire [7:0] o_Red, o_Green, o_Blue;
    wire o_vSync, o_hSync;
    wire [3:0] o_LED;

    reg [7:0] c_Cnt, n_Cnt;

    always #10 Clk = ~Clk;
    
    always
    begin
        #5 n_Cnt = c_Cnt + 1;
        #5 c_Cnt = n_Cnt;
    end

    assign fDrawDone = c_Cnt == 8'b10_000_000;

    TopTest T0(Clk, Rst, Keyboard, fDrawDone, o_FND0, o_FND1, o_FND2, o_Red, o_Green, o_Blue, o_vSync, o_hSync, o_LED);

    initial
    begin
        Clk = 1;
        Rst = 0;
        c_Cnt = 0;
        Keyboard = 0;

        @(negedge Clk) Rst = 1;
        #100 Keyboard   = 4'b1011;
        #10000 Keyboard = 4'b1111;
        #10000 Keyboard = 4'b1011;
        #10000 Keyboard = 4'b1001;
        #10000 Keyboard = 4'b1101;
        #10000 Keyboard = 4'b1111;
        #10000 Keyboard = 4'b1110;
        #10000 Keyboard = 4'b1111;
        #10000 Keyboard = 4'b0111;


        $stop;
    end


endmodule
