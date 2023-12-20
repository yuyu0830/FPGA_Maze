module hsync(
	input Clk, Rst, 
	input [5:0] i_PixelSize,
	output hsync_out,
	output hblank,
	output newline_out,
	output [9:0] hPos,
	output [5:0] xPos,
	output hDrawDone
	);

// params
	parameter H_LIMIT = 640;

// regs
	reg [9:0] hCnt;
	reg [5:0] c_Cnt, n_Cnt, c_Pos, n_Pos;

	wire fBorder = c_Cnt == i_PixelSize;

// nets
	assign hsync_out 	= hCnt < 656 || hCnt >= 752;
	assign hblank 		= hCnt >= 640;
	assign newline_out 	= hCnt == 0;
	assign hPos 		= hCnt;
	assign hDrawDone 	= hCnt == H_LIMIT - 1;

// hsync = 1, 0~639 픽셀 visible area
// hsync = 1, 640 ~ 655 픽셀 front proch
// hsync = 0, 656 ~ 751 픽셀 sync pulse
// hsync = 1, 752 ~ 799 픽셀 back porch

// main
	always@(posedge Clk, negedge Rst)
		if (!Rst) begin
			hCnt = 0;
			c_Cnt = 0;
			c_Pos = 0;
		end else begin
			hCnt = hCnt < 800 ? hCnt + 1 : 0;
			c_Cnt = n_Cnt;
			c_Pos = n_Pos;
		end

	always@*
		begin
			n_Cnt = fBorder ? 0: c_Cnt + 1;
			n_Pos = hblank ? 0 : (fBorder ? c_Pos + 1 : c_Pos));
		end

endmodule