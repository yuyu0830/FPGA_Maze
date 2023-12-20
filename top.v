module Top(
    input i_Clk, i_Rst,
    input [3:0] i_Keyboard,
    output [6:0] o_FND0, o_FND1, o_FND2,
    output [7:0] o_Red, o_Green, o_Blue,
    output o_Clk, o_blank, o_hsync, o_vsync,
    output [1:0] o_LED0,
    output [3:0] o_LED1,
    output [3:0] o_LED2);

    `include "parameters.vh"

    // reg
    reg [2:0] c_State, n_State;
    reg [ROW*COLUMN-1:0] c_Map, n_Map;
    reg [5:0] c_Col, n_Col;
    reg [4:0] c_Row, n_Row;
    reg [1:0] c_Level, n_Level;
    reg [5:0] c_PlayerPos_X, n_PlayerPos_X; // (1 ~ 38)
    reg [4:0] c_PlayerPos_Y, n_PlayerPos_Y; // (1 ~ 28)
    reg [1:0] c_NextDirection, n_NextDirection;
    reg c_NeedMove, n_NeedMove;
    
    // wire
    wire [3:0] Key_o_Direction;
    wire Key_o_fOut;

    wire [3:0] Timer_o_Sec0, Timer_o_Sec1, Timer_o_Sec2;
    wire [5:0] GoalPos_X;
    wire [4:0] GoalPos_Y;
	 
    wire fStart;
    wire fRunning;
    wire fMove, fLvCheck;
    wire fNeedMove, fNeedLevelUP;
    wire fLevelUP;
    wire fDrawDone;

    wire fLeft, fUp, fDown, fRight;

    wire [10:0] PlayerPos;

    // module
    Key K0(i_Clk, i_Rst, i_Keyboard, Key_o_Direction, Key_o_fOut, );

    Timer T0(i_Clk, i_Rst, fRunning, Timer_o_Sec0, Timer_o_Sec1, Timer_o_Sec2);

    Draw D0(i_Clk, i_Rst, c_Level, c_Map, c_PlayerPos_X, GoalPos_X, c_PlayerPos_Y, GoalPos_Y, o_Red, o_Green, o_Blue, o_Clk, o_blank, o_hsync, o_vsync, fDrawDone);

    FND F0(Timer_o_Sec0, o_FND0);
    FND F1(Timer_o_Sec1, o_FND1);
    FND F2(Timer_o_Sec2, o_FND2);

    // assign
    assign  PlayerPos = (c_PlayerPos_Y * ROW) + c_PlayerPos_X;

    assign  GoalPos_X = c_Col - 2,
            GoalPos_Y = c_Row - 2;

    assign  fLeft   = !c_Map[1199 - (PlayerPos - 1)],
            fUp     = !c_Map[1199 - (PlayerPos - ROW)],
            fDown   = !c_Map[1199 - (PlayerPos + ROW)],
            fRight  = !c_Map[1199 - (PlayerPos + 1)];

    assign  fLevelUP = fLvCheck & fNeedLevelUP;

    assign  fStart      = c_State == IDLE & Key_o_fOut,
            fRunning    = c_State != IDLE,
            fMove       = c_State == MOVE,
            fLvCheck    = c_State == LV_CHECK,
            fNeedMove   = fRunning ? (
                (Key_o_Direction[3] & fLeft) |
                (Key_o_Direction[2] & fUp)   |
                (Key_o_Direction[1] & fDown) |
                (Key_o_Direction[0] & fRight)
            ) : 0,
            fNeedLevelUP = c_PlayerPos_X == GoalPos_X & c_PlayerPos_Y == GoalPos_Y;

    assign  o_LED0 = c_State,
            o_LED1 = i_Keyboard,
            o_LED2 = {fLeft, fUp, fDown, fRight}; // debug

    always@ (posedge i_Clk, negedge i_Rst)
        if (!i_Rst) begin
            c_State = IDLE;
            c_Map   = 0;
            c_Col   = 0;
            c_Row   = 0;
            c_Level = 0;
            c_PlayerPos_X   = 0;
            c_PlayerPos_Y   = 0;
            c_NeedMove      = 0;
            c_NextDirection = 0;
        end else begin
            c_State = n_State;
            c_Map   = n_Map;
            c_Col   = n_Col;
            c_Row   = n_Row;
            c_Level = n_Level;
            c_PlayerPos_X   = n_PlayerPos_X;
            c_PlayerPos_Y   = n_PlayerPos_Y;
            c_NeedMove      = n_NeedMove;
            c_NextDirection = n_NextDirection;
        end

    always@*
    begin
        n_NeedMove = fNeedMove ? 1 : (fMove ? 0 : c_NeedMove);
        n_Map =  c_Level == 1 ? MAZE_EZ :
                (c_Level == 2 ? MAZE_MI :
                (c_Level == 3 ? MAZE_HD : 0));
        n_Col =  c_Level == 1 ? BLOCK_EZ_COL : 
                (c_Level == 2 ? BLOCK_MI_COL :
                (c_Level == 3 ? BLOCK_HD_COL : 0));
        n_Row =  c_Level == 1 ? BLOCK_EZ_ROW : 
                (c_Level == 2 ? BLOCK_MI_ROW :
                (c_Level == 3 ? BLOCK_HD_ROW : 0));
        n_PlayerPos_X = fLevelUP | fStart ? 1 : (fMove ? (c_NextDirection == LEFT  ? c_PlayerPos_X - 1 : 
                                                         (c_NextDirection == RIGHT ? c_PlayerPos_X + 1 : c_PlayerPos_X)) : c_PlayerPos_X);
        n_PlayerPos_Y = fLevelUP | fStart ? 1 : (fMove ? (c_NextDirection == UP    ? c_PlayerPos_Y - 1 :
                                                         (c_NextDirection == DOWN  ? c_PlayerPos_Y + 1 : c_PlayerPos_Y)) : c_PlayerPos_Y);
        n_Level = fStart | (fLevelUP & fNeedLevelUP) ? c_Level + 1 : c_Level;
        n_NextDirection = fNeedMove ? (Key_o_Direction[3] ? LEFT : 
                                      (Key_o_Direction[2] ? UP :
                                      (Key_o_Direction[1] ? DOWN : RIGHT))) : c_NextDirection;
        n_State = c_State;

        case(c_State)
            IDLE:
                n_State = fStart ? RUNNING : c_State;

            RUNNING:
                n_State = fDrawDone && c_NeedMove ? MOVE : c_State;

            MOVE:
                n_State = LV_CHECK;

            LV_CHECK:
                n_State = RUNNING;
        endcase
    end
endmodule