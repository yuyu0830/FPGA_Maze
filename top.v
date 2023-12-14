`include "vgaprocessor.v"
 
module top 
    (
        input i_Clk,
        input [2399:0] i_Maze,
        input [1:0] i_MazeState,

        output [7:0] o_VGA_Red,
        output [7:0] o_VGA_Green,
        output [7:0] o_VGA_Blue,
        output o_VGA_HSync,
        output o_VGA_VSync
    );
    
    wire [23:0] w_ColourPin;
 
    VgaProcessor processor
    (
        .i_Clk(i_Clk),
        .i_Maze(i_Maze),
        .i_MazeState(i_MazeState),
        .o_HSync(o_VGA_HSync),
        .o_VSync(o_VGA_VSync),
        .o_Colour_On(w_ColourPin)
    );
 
    assign o_VGA_Red = w_ColourPin[23:16]; 
    assign o_VGA_Green = w_ColourPin[15:8];
    assign o_VGA_Blue = w_ColourPin[7:0];
 
endmodule