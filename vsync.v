module vsync(
	input Clk, Rst,
	input [5:0] i_PixelSize,
	output vblank,
	output vsync_out,
	output [9:0] vPos,
	output vDrawDone
	);
	
// parameter
	parameter V_LIMIT = 480;

// regs
	reg [9:0] vCnt;
	reg blank;
	reg vsync;

// nets
	assign vblank 		= vCnt >= 480;
	assign vsync_out 	= vCnt < 490 || vCnt >= 492;
	assign vPos 		= vCnt;
	assign vDrawDone 	= vCnt == V_LIMIT - 1;

// main

// hsync 처럼 vsync에 대해 대입
always@(posedge Clk, negedge Rst)
	if (!Rst) begin
		vCnt = 0;
	end else begin
		vCnt = vCnt < 525 ? vCnt + 1 : 0;
	end

endmodule