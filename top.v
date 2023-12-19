module top(
    input i_Clk, i_Rst,
    input [3:0] i_Keyboard,

    output [6:0] o_FND0, o_FND1,
    output [7:0] o_Red, o_Green, o_Blue,
    output o_vSync, o_hSync,
    output [3:0] o_LED
);
    `include "parameters.vh"

    // reg
    reg [1:0] c_State, n_State;
    reg [ROW*COLUME:0] c_Map, n_Map;
    reg [1:0] c_Level, n_Level;
    reg [6:0] c_PlayerPos_X, n_PlayerPos_X;
    reg [5:0] c_PlayerPos_Y, n_PlayerPos_Y;

    // wire
    wire [3:0] Key_o_Direction;
    wire Key_o_fOut;

    wire [3:0] Timer_o_Sec0, Timer_o_Sec1;

    wire fRunning;
    wire fUpdate;
    wire fLevelUP;
    wire fDrawDone;



    // module
    Key K0(i_Clk, i_Rst, i_Keyboard, Key_o_Direction, Key_o_fOut, o_LED);

    Timer T0(i_Clk, i_Rst, fRunning, Timer_o_Sec0, Timer_o_Sec1);

    FND F0(Timer_o_Sec0, o_FND0);
    FND F1(Timer_o_Sec1, o_FND1);






 
endmodule