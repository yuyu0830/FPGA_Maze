module Draw(i_Clk, i_Rst, i_MazeLevel, i_MazeMap, o_Color, o_HSync, o_VSync);

input          i_Clk, i_Rst;
input [   1:0] i_MazeLevel;
input [1199:0] i_MazeMap;

output reg [ 2:0] o_Color;

output wire o_HSync, o_VSync;

wire [39:0] o_Col;
wire [29:0] o_Row;
wire        fDraw_Done;

reg [29:0] c_Row,  n_Row;
reg [16:0] c_Cnt,  n_Cnt;
reg [ 9:0] r_HPos, r_VPos;

parameter Lv1 = 40, Lv2 = 20, Lv3 = 10,
          Easy = 2'b00, Normal = 2'b01, Hard = 2'b10;
/*
Level 0 = 16*12 (40px)
Level 1 = 32*24 (20px)
Level 2 = 40*30 (16px)
*/

//step pixel position throughout the screen
always@(posedge i_Clk, negedge i_Rst)
  if(!i_Rst) begin
    c_Row = 1;
    c_Cnt = 0;
    
    if(r_HPos < 799) r_HPos = r_HPos + 1;
    else begin
      r_HPos = 0;
      r_VPos = r_VPos < 524 ? r_VPos + 1 : 0;
    end
  end
  else begin
    c_Row = n_Row;
    c_Cnt = n_Cnt;
    
    r_HPos = 0;
    r_VPos = 0;
  end

assign fDraw_Done = r_HPos == 639 & r_VPos == 479,

       o_Row = c_Row,
       o_Col = (c_Row[29] ? i_MazeMap[40*29+:40] : 0)|
               (c_Row[28] ? i_MazeMap[40*28+:40] : 0)|
               (c_Row[27] ? i_MazeMap[40*27+:40] : 0)|
               (c_Row[26] ? i_MazeMap[40*26+:40] : 0)|
               (c_Row[25] ? i_MazeMap[40*25+:40] : 0)|
               (c_Row[24] ? i_MazeMap[40*24+:40] : 0)|
               (c_Row[23] ? i_MazeMap[40*23+:40] : 0)|
               (c_Row[22] ? i_MazeMap[40*22+:40] : 0)|
               (c_Row[21] ? i_MazeMap[40*21+:40] : 0)|
               (c_Row[20] ? i_MazeMap[40*20+:40] : 0)|
               (c_Row[19] ? i_MazeMap[40*19+:40] : 0)|
               (c_Row[18] ? i_MazeMap[40*18+:40] : 0)|
               (c_Row[17] ? i_MazeMap[40*17+:40] : 0)|
               (c_Row[16] ? i_MazeMap[40*16+:40] : 0)|
               (c_Row[15] ? i_MazeMap[40*15+:40] : 0)|
               (c_Row[14] ? i_MazeMap[40*14+:40] : 0)|
               (c_Row[13] ? i_MazeMap[40*13+:40] : 0)|
               (c_Row[12] ? i_MazeMap[40*12+:40] : 0)|
               (c_Row[11] ? i_MazeMap[40*11+:40] : 0)|
               (c_Row[10] ? i_MazeMap[40*10+:40] : 0)|
               (c_Row[ 9] ? i_MazeMap[40* 9+:40] : 0)|
               (c_Row[ 8] ? i_MazeMap[40* 8+:40] : 0)|
               (c_Row[ 7] ? i_MazeMap[40* 7+:40] : 0)|
               (c_Row[ 6] ? i_MazeMap[40* 6+:40] : 0)|
               (c_Row[ 5] ? i_MazeMap[40* 5+:40] : 0)|
               (c_Row[ 4] ? i_MazeMap[40* 4+:40] : 0)|
               (c_Row[ 3] ? i_MazeMap[40* 3+:40] : 0)|
               (c_Row[ 2] ? i_MazeMap[40* 2+:40] : 0)|
               (c_Row[ 1] ? i_MazeMap[40* 1+:40] : 0)|
               (c_Row[ 0] ? i_MazeMap[40* 0+:40] : 0);

//Horizontal sync
always @(posedge i_Clk)
  if (r_HPos < 704) o_HSync = 1'b1;
  else o_HSync = 1'b0;

//Vertical sync
always @(posedge i_Clk)
begin
  if (r_VPos < 523) o_VSync = 1'b1;
  else o_VSync = 1'b0;
end  

//Color
always@*
  begin
    n_Cnt = fDraw_Done ? 0 : c_Cnt + 1;
    n_Row = fDraw_Done ? {c_Row[28:0], c_Row[29]} : c_Row;
    
    if((r_HPos < 640) & (r_VPos < 480)) begin
      case(i_MazeLevel)
        Easy : begin
        end
        Normal : begin
        end
        Hard : begin
        end
    end
    else begin
      o_Color = 3'b000;
    end
  end
endmodule