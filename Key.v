module Key(i_Clk, i_Rst, i_Push, o_Push, o_fOut, o_LED);
    input i_Clk, i_Rst;
    input [3:0] i_Push;
    output [3:0] o_Push;
    output [3:0] o_LED;
    output o_fOut;

    reg c_State, n_State;
    reg [5:0] c_ClkCnt, n_ClkCnt;
    reg [3:0] c_Pushed, n_Pushed;
    reg [3:0] c_LED, n_LED;

    wire 
        fChanged,
        fLstClk;

    parameter
        IDLE = 1'b0,
        CHANGE = 1'b1;

    always@(posedge i_Clk, negedge i_Rst)
        if(!i_Rst) begin
            c_State = IDLE;
            c_ClkCnt = 0;
            c_Pushed = 0;
            c_LED = 0;
        end else begin
            c_State = n_State;
            c_ClkCnt = n_ClkCnt;
            c_Pushed = n_Pushed;
            c_LED = n_LED;
        end

    assign 
        fChanged = |(i_Push ^ c_Pushed),
        fLstClk = &c_ClkCnt;

    assign
        o_fOut = (fLstClk && fChanged) && |o_Push,
        o_Push = ~(i_Push | c_Pushed),
        o_LED = c_LED;

    always@*
    begin
        n_ClkCnt = fChanged ? c_ClkCnt + 1 : 0;
        n_Pushed = fChanged && fLstClk ? ~i_Push : c_Pushed;
        n_LED = o_fOut ? c_LED ^ o_Push : c_LED;

        n_State = c_State;
        case (c_State)
            IDLE:
                n_State = fChanged ? CHANGE : c_State;
            
            CHANGE:
                n_State = fLstClk ? IDLE : c_State;
                
        endcase
    end
//$write(“molrayo”);
endmodule