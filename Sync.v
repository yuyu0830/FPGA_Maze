module Sync(
    input i_Clk, i_Rst, 
	input [5:0] i_PixelSize,
	output o_Clk, o_hsync, o_vsync, o_blank,
	output [5:0] o_XPos, 
    output [4:0] o_YPos,
	output o_fDrawDone
);

    // parameter
    parameter
        H_DISPLAY = 640,
        V_DISPLAY = 480,
        H_LIMIT = 800,
        V_LIMIT = 525;

    parameter
        IDLE    = 1'b0,
        SIG_OUT = 1'b1;

    // reg
    reg c_State, n_State;
    reg [9:0] r_hPos, r_vPos;           // 현재 어디 픽셀을 그리는지 h, v 로 알려줌 (h, v)
	reg [5:0] r_XCnt, r_XPos, r_YCnt;   // X, Y Cnt : 현재 블럭 (미로에서 한 블럭) 의 어디를 그리고 있는지
    reg [4:0] r_YPos;                   // X, Y Pos : 현재 그리고 있는 블럭이 미로의 (x, y) 블럭

    // wire
    wire fX_Border, fY_Border;
    wire halfClk;
    wire fNewline;
    wire hDrawDone, vDrawDone;
    wire hBlank, vBlank;

    ClkDiv  clk25m(i_Clk, halfClk);

    // assign
    assign  fNewline 	= r_hPos == 0;

    assign  o_Clk       = halfClk;

    assign  o_hsync     = r_hPos < 656 || r_hPos >= 752,
            o_vsync     = r_vPos < 490 || r_vPos >= 492;
            
    assign  hBlank 	    = r_hPos >= 640,
            vBlank 	    = r_vPos >= 480,
            o_blank     = ~(hBlank || vBlank);

    assign  hDrawDone 	= r_hPos == H_DISPLAY - 1,
            vDrawDone 	= r_vPos == V_DISPLAY - 1;

    assign  o_XPos = r_XPos,
            o_YPos = r_YPos;

    assign  fX_Border   = r_XCnt == i_PixelSize - 1,
            fY_Border   = r_YCnt == i_PixelSize - 1;

    assign  o_fDrawDone  = hDrawDone & vDrawDone;

	always@(posedge halfClk, negedge i_Rst)
		if (!i_Rst) begin
			r_hPos = 0;
            r_vPos = 0;
			r_XCnt = 0;
            r_XPos = 0;
            r_YCnt = 0;
            r_YPos = 0;
		end else begin
			r_hPos = r_hPos < H_LIMIT ? r_hPos + 1 : 0;
            r_vPos = r_hPos == H_LIMIT - 1 ? (r_vPos == V_LIMIT - 1 ? 0 : r_vPos + 1) : r_vPos;
			r_XCnt = hBlank | fX_Border ? 0 : r_XCnt + 1;                             // halfClk마다 1씩 올라가고, 블럭 사이즈가 넘어가거나 화면 바깥일 때 0
            r_XPos = hBlank ? 0 : (fX_Border ? r_XPos + 1 : r_XPos);                  // 화면 바깥일 때는 0, XCnt가 블럭 사이즈를 넘어갈 때 XPos도 1 증가
            r_YCnt = hDrawDone ? (fY_Border | vBlank ? 0 : r_YCnt + 1) : r_YCnt;      // 가로 한번 다 그렸을 때 화면 바깥이거나 YCnt가 블럭 사이즈를 넘어가면 0, 아니면 1 증가
            r_YPos = vBlank ? 0 : (hDrawDone & fY_Border? r_YPos + 1 : r_YPos);       // 화면 바깥일 때는 0, YCnt가 블럭 사이즈를 넘어갈 때 YPos도 1 증가
		end

    always@(posedge i_Clk, negedge i_Rst)
        if (!i_Rst) begin
            c_State = IDLE;
        end else begin
            c_State = n_State;
        end

    always@*
        begin
            n_State = c_State;

            case(c_State)
                IDLE:
                    n_State = hDrawDone & vDrawDone ? SIG_OUT : c_State;
                
                SIG_OUT:
                    n_State = IDLE;

            endcase
        end
endmodule