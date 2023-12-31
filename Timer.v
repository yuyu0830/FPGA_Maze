module Timer(
    input i_Clk,
    input i_Rst,
    input i_Enable,
    output [3:0] o_Sec0, o_Sec1, o_Sec2
);

    parameter LST_CLK = 1_000_000_000 / 20 - 1;

    reg [3:0] c_Sec0, n_Sec0;
    reg [3:0] c_Sec1, n_Sec1;
    reg [3:0] c_Sec2, n_Sec2;

    reg [25:0] c_ClkCnt, n_ClkCnt;

    wire fLstClk;
    wire fIncSec0, fIncSec1, fIncSec2;
    wire fLstSec0, fLstSec1, fLstSec2;

    always@ (posedge i_Clk, negedge i_Rst)
        if (!i_Rst) begin
            c_Sec0   = 0;
            c_Sec1   = 0;
            c_Sec2   = 0;
            c_ClkCnt = 0;
        end else begin
            c_Sec0   = n_Sec0;
            c_Sec1   = n_Sec1;
            c_Sec2   = n_Sec2;
            c_ClkCnt = n_ClkCnt;
        end
    
    assign  o_Sec0 = c_Sec0,
            o_Sec1 = c_Sec1,
            o_Sec2 = c_Sec2;

    assign  fLstClk = c_ClkCnt == LST_CLK;

    assign  fLstSec0 = c_Sec0 == 9,
            fLstSec1 = c_Sec1 == 9,
            fLstSec2 = c_Sec2 == 9;

    assign  fIncSec0 = fLstClk,
            fIncSec1 = fIncSec0 && fLstSec0,
            fIncSec2 = fIncSec1 && fLstSec1;

    always@*
    begin  
        n_ClkCnt = i_Enable ? (fLstClk ? 0 : c_ClkCnt + 1) : 0;
        n_Sec0 = i_Enable ? (fIncSec0 ? (fLstSec0 ? 0 : c_Sec0 + 1) : c_Sec0) : 0;
        n_Sec1 = i_Enable ? (fIncSec1 ? (fLstSec1 ? 0 : c_Sec1 + 1) : c_Sec1) : 0;
        n_Sec2 = i_Enable ? (fIncSec2 ? (fLstSec2 ? 0 : c_Sec2 + 1) : c_Sec2) : 0;
    end


endmodule