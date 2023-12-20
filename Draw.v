module Draw (
    input i_Clk, i_Rst,
    input [1:0] i_Level,
    input [1199:0] i_Map,
    input [5:0] i_PlayerPos_X, i_GoalPos_X, 
    input [4:0] i_PlayerPos_Y, i_GoalPos_Y, 
    output wire [7:0] o_Red, o_Green, o_Blue, 
    output wire o_Clk, o_blank, o_hsync, o_vsync, o_fDrawDone);

    // wire
    wire [5:0] BlockSize;
    wire [10:0] BlockPosition;
    wire fPlayer, fWall, fGoal;

    wire [5:0] Sync_o_XPos;
    wire [4:0] Sync_o_YPos;

    // parameter
    parameter 
            PIXEL_EZ = 6'd40,
            PIXEL_MI = 6'd20,
            PIXEL_HD = 6'd16,
            ROW      = 6'd40;

    // module
    Sync    S0(i_Clk, i_Rst, BlockSize, o_Clk, o_hsync, o_vsync, o_blank, Sync_o_XPos, Sync_o_YPos, o_fDrawDone);

    // assign
    assign  BlockSize = i_Level == 2'b01 ? PIXEL_EZ : 
                       (i_Level == 2'b10 ? PIXEL_MI : 
                       (i_Level == 2'b11 ? PIXEL_HD : 6'b111_111));

    assign  fPlayer = (Sync_o_XPos == i_PlayerPos_X & Sync_o_YPos == i_PlayerPos_Y),
            fWall   = i_Map[1199-BlockPosition],
            fGoal   = (Sync_o_XPos == i_GoalPos_X & Sync_o_YPos == i_GoalPos_Y);

    assign  BlockPosition = (Sync_o_YPos * ROW) + Sync_o_XPos;

    assign  o_Red   = fPlayer | fWall ? 8'b1111_1111 : 8'b0000_0000, 
            o_Green = fGoal | fWall ? 8'b1111_1111 : 8'b0000_0000, 
            o_Blue  = fWall ? 8'b1111_1111 : 8'b0000_0000;

endmodule
