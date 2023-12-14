`timescale 1ns / 1ps

module top_tb;

    reg i_Clk;
    reg [2399:0] i_Maze;
    reg [1:0] i_MazeState;
    wire o_VGA_Red_0, o_VGA_Red_1, o_VGA_Red_2, o_VGA_HSync, o_VGA_VSync;

    // Instantiate the top module
    top uut (
        .i_Clk(i_Clk),
        .i_Maze(i_Maze),
        .i_MazeState(i_MazeState),
        .o_VGA_Red_0(o_VGA_Red_0),
        .o_VGA_Red_1(o_VGA_Red_1),
        .o_VGA_Red_2(o_VGA_Red_2),
        .o_VGA_HSync(o_VGA_HSync),
        .o_VGA_VSync(o_VGA_VSync)
    );

    // Clock generation
    initial begin
        i_Clk = 0;
        forever #5 i_Clk = ~i_Clk;
    end

    // Add stimulus here if needed

    // Monitor signals
    always @(posedge i_Clk) begin
        $display("Time=%0t: HSync=%b VSync=%b Red_0=%b Red_1=%b Red_2=%b",
                 $time, o_VGA_HSync, o_VGA_VSync, o_VGA_Red_0, o_VGA_Red_1, o_VGA_Red_2);
    end

endmodule
