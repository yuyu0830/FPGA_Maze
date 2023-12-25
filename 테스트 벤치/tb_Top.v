`timescale 1ns / 1ns

module Top_tb;
    reg Clk;
    reg Rst;
    reg [3:0] Keyboard;
    reg fDrawDone;

    wire [6:0] o_FND0, o_FND1, o_FND2;
    wire [7:0] o_Red, o_Green, o_Blue;
    wire o_Clk, o_blank, o_hsync, o_vsync;
    wire [1:0] o_LED0;
    wire [3:0] o_LED1, o_LED2;

    always #10 Clk = ~Clk;

    Top T0(Clk, Rst, Keyboard, o_FND0, o_FND1, o_FND2, o_Red, o_Green, o_Blue, o_Clk, o_blank, o_hsync, o_vsync, o_LED0, o_LED1, o_LED2);

    initial
    begin
        Clk = 1;
        Rst = 0;
        Keyboard = 4'b1111;

        @(negedge Clk) Rst = 1;
        #17_000_000 Keyboard = 4'b1101;
        #17_000_000 Keyboard = 4'b1111;
        #17_000_000 Keyboard = 4'b1110;
        #17_000_000 Keyboard = 4'b1111;
        #17_000_000 Keyboard = 4'b1110;
        #17_000_000 Keyboard = 4'b1111;

        $stop;
    end


endmodule
