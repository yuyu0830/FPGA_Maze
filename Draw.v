module Draw (
    input i_Clk, i_Rst,
    input [1:0] i_Level,
    input [1199:0] i_Map,
    input [5:0] i_PlayerPos_X, i_GoalPos_X, 
    input [4:0] i_PlayerPos_Y, i_GoalPos_Y, 
    output wire [7:0] o_Red, o_Green, o_Blue, 
    output wire o_Clk, o_blank, o_hsync, o_vsync, o_fDrawDone);

    // reg
    // PixelPos  : 픽셀 그리고있는 위치 (0, 0) ~ (799, 524)
    // BorderCnt : 픽셀이 현재 블럭에서 어느 위치를 그리고있는지 (0, 0) ~ (BlockSize, BlockSize)
    // BlockPos  : 현재 픽셀 위치를 지도의 블럭에 매핑 (0, 0) ~ (MapSize_X, MapSize_Y)
    reg [9:0] r_PixelPos_X, r_PixelPos_Y;
	reg [5:0] r_BorderCnt_X, r_BorderCnt_Y, r_BlockPos_X; 
    reg [4:0] r_BlockPos_Y;

    // wire
    wire [5:0] BlockSize;
    wire [10:0] BlockPosition;
    wire fPlayer, fWall, fGoal;

    wire fBorder_X, fBorder_Y;  // 현재 픽셀이 블럭의 마지막 줄일 때
    wire halfClk;
    wire hDrawDone, vDrawDone;
    wire hBlank, vBlank;

    ClkDiv  clk25m(i_Clk, halfClk);

    // parameter
    parameter 
        PIXEL_EZ = 6'd40,
        PIXEL_MI = 6'd20,
        PIXEL_HD = 6'd16;
    
    parameter
        ROW      = 6'd40;

    parameter
        H_DISPLAY = 640,
        V_DISPLAY = 480,
        H_LIMIT = 800,
        V_LIMIT = 525;


    // assign
    assign  BlockSize = i_Level == 2'b01 ? PIXEL_EZ : 
                       (i_Level == 2'b10 ? PIXEL_MI : 
                       (i_Level == 2'b11 ? PIXEL_HD : 6'b111_111));

    assign  fPlayer = (r_BlockPos_X == i_PlayerPos_X & r_BlockPos_Y == i_PlayerPos_Y),
            fWall   = i_Map[1199-BlockPosition],
            fGoal   = (r_BlockPos_X == i_GoalPos_X & r_BlockPos_Y == i_GoalPos_Y);

    assign  BlockPosition = (r_BlockPos_Y * ROW) + r_BlockPos_X;

    assign  o_Clk       = halfClk;

    assign  o_hsync     = r_PixelPos_X < 656 || r_PixelPos_X >= 752,
            o_vsync     = r_PixelPos_Y < 490 || r_PixelPos_Y >= 492;
            
    assign  hBlank 	    = r_PixelPos_X >= 640,
            vBlank 	    = r_PixelPos_Y >= 480,
            o_blank     = ~(hBlank || vBlank);

    assign  hDrawDone 	= r_PixelPos_X == H_DISPLAY - 1,
            vDrawDone 	= r_PixelPos_Y == V_DISPLAY - 1;

    assign  fBorder_X   = r_BorderCnt_X == BlockSize - 1,
            fBorder_Y   = r_BorderCnt_Y == BlockSize - 1;

    assign  o_Red   = fPlayer | fWall ? 8'b1111_1111 : 8'b0000_0000, 
            o_Green = fGoal | fWall ? 8'b1111_1111 : 8'b0000_0000, 
            o_Blue  = fWall ? 8'b1111_1111 : 8'b0000_0000;

    assign  o_fDrawDone  = hDrawDone & vDrawDone;

    always@(posedge halfClk, negedge i_Rst)
		if (!i_Rst) begin
			r_PixelPos_X    = 0;
            r_PixelPos_Y    = 0;
			r_BorderCnt_X   = 0;
            r_BorderCnt_Y   = 0;
            r_BlockPos_X    = 0;
            r_BlockPos_Y    = 0;
		end else begin
			r_PixelPos_X    = r_PixelPos_X < H_LIMIT ? r_PixelPos_X + 1 : 0;
            r_PixelPos_Y    = r_PixelPos_X == H_LIMIT - 1 ? (r_PixelPos_Y == V_LIMIT - 1 ? 0 : r_PixelPos_Y + 1) : r_PixelPos_Y;
			r_BorderCnt_X   = hBlank | fBorder_X ? 0 : r_BorderCnt_X + 1;                                   // halfClk마다 1씩 올라가고, 블럭 사이즈가 넘어가거나 화면 바깥일 때 0
            r_BorderCnt_Y   = hDrawDone ? (fBorder_Y | vBlank ? 0 : r_BorderCnt_Y + 1) : r_BorderCnt_Y;     // 가로 한번 다 그렸을 때 화면 바깥이거나 BorderCnt_Y가 블럭 사이즈를 넘어가면 0, 아니면 1 증가
            r_BlockPos_X    = hBlank ? 0 : (fBorder_X ? r_BlockPos_X + 1 : r_BlockPos_X);                   // 화면 바깥일 때는 0, BorderCnt_X가 블럭 사이즈를 넘어갈 때 BlockPos_X도 1 증가
            r_BlockPos_Y    = vBlank ? 0 : (hDrawDone & fBorder_Y ? r_BlockPos_Y + 1 : r_BlockPos_Y);       // 화면 바깥일 때는 0, BorderCnt_Y가 블럭 사이즈를 넘어갈 때 BlockPos_Y도 1 증가
		end

endmodule
