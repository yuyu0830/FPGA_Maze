module Draw (
    input i_Clk, i_Rst,
    input [1:0] i_Level,
    input [1199:0] i_Map,
    input [5:0] i_PlayerPos_X, i_GoalPos_X, 
    input [4:0] i_PlayerPos_Y, i_GoalPos_Y, 
    output wire [7:0] o_Red, o_Green, o_Blue, 
    output wire o_Clk, o_blank, o_hsync, o_vsync, o_fDrawDone);

    // wire
    wire hsync_out;
	wire vsync_out;
	wire hblank;
	wire vblank;

    wire [9:0] hCnt, vCnt;
    wire [5:0] PixelSize;
    wire fBorderX, fBorderY;
    wire vDrawDone, hDrawDone;
    wire newline_out;
    wire [10:0] BlockPosition;

    // reg
    reg [5:0] c_XPos, n_XPos, c_XCnt, n_XCnt, c_YCnt, n_YCnt;
    reg [4:0] c_YPos, n_YPos;

    // parameter
    parameter 
            PIXEL_EZ = 6'd40,
            PIXEL_MI = 6'd20,
            PIXEL_HD = 6'd16,
            ROW      = 6'd40;

    // assign
    assign  o_hsync = hsync_out;
	assign  o_vsync = vsync_out;
    assign  o_blank = ~(hblank || vblank);

    assign  PixelSize = i_Level == 2'b01 ? PIXEL_EZ : 
                       (i_Level == 2'b10 ? PIXEL_MI : 
                       (i_Level == 2'b11 ? PIXEL_HD : 6'b111_111));

    assign  fBorderX = c_XCnt == PixelSize,
            fBorderY = c_YCnt == PixelSize;

    assign  BlockPosition = (c_XPos * ROW) + c_YPos;

    assign  o_Red   = (c_XPos == i_PlayerPos_X & c_YPos == i_PlayerPos_Y) | i_Map[1199-BlockPosition] ? 8'b1111_1111 : 8'b0000_0000, 
            o_Green = (c_XPos == i_GoalPos_X & c_YPos == i_GoalPos_Y) | i_Map[1199-BlockPosition] ? 8'b1111_1111 : 8'b0000_0000, 
            o_Blue  = i_Map[1199-BlockPosition] ? 8'b1111_1111 : 8'b0000_0000;

    assign o_fDrawDone = hDrawDone & vDrawDone;

    // module
    ClkDiv  clk25m(i_Clk, o_Clk);
	hsync   hs(o_Clk, i_Rst, hsync_out, hblank, newline_out, hCnt, hDrawDone);
	vsync   vs(newline_out, i_Rst, vblank, vsync_out, vCnt, vDrawDone);

    always@ (posedge i_Clk, negedge i_Rst)
        if (!i_Rst) begin
            c_XPos = 0;
            c_YPos = 0;
            c_XCnt = 0;
            c_YCnt = 0;
        end else begin
            c_XPos = n_XPos;
            c_YPos = n_YPos;
            c_XCnt = n_XCnt;
            c_YCnt = n_YCnt;
        end

    always@*
    begin
        n_XCnt = hblank ? 0 : (hsync_out & o_Clk ? (fBorderX ? 0 : c_XCnt + 1) : c_XCnt);
        if (!vblank) begin
            n_YCnt = newline_out ? (fBorderY ? 0 : c_YCnt + 1) : c_YCnt;
        end else begin
            n_YCnt = 0;
        end
        //n_YCnt = vblank ? 0 : (vsync_out ? (fBorderY ? 0 : c_YCnt + 1) : c_YCnt);

        n_XPos = hsync_out & fBorderX ? (hDrawDone ? 0 : c_XPos + 1) : c_XPos;
        n_YPos = vsync_out & fBorderY ? (vDrawDone ? 0 : c_YPos + 1) : c_YPos;
    end



endmodule
