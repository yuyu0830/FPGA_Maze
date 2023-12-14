module VGA(i_Clk, o_HSync, o_VSync, r_Hpos, r_Vpos);
 
input         i_Clk,
output        o_HSync;
output        o_VSync;
output [10:0] r_HPos;
output [10:0] r_VPos;
    
    //step pixel position throughout the screen
    always @(posedge i_Clk)
        begin
          if (r_HPos < 799)
            begin
                r_HPos <= r_HPos + 1;
            end
          else
            begin
                r_HPos <= 0;
                if (r_VPos < 524)
                  begin
                    r_VPos <= r_VPos + 1;
                  end
                else
                  begin
                    r_VPos <= 0;
                  end
 
            end  
        end
 
    //Horizontal sync
    always @(posedge i_Clk)
        begin
          if (r_HPos < 704)
            begin
                o_HSync = 1'b1;
            end
          else
            begin
                o_HSync = 1'b0;
            end  
        end
 
    //Vertical sync
    always @(posedge i_Clk)
        begin
          if (r_VPos < 523)
            begin
                o_VSync = 1'b1;
            end
          else
            begin
                o_VSync = 1'b0;
            end  
        end
endmodule