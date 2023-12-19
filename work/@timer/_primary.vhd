library verilog;
use verilog.vl_types.all;
entity Timer is
    generic(
        LST_CLK         : integer := 4999999
    );
    port(
        i_Clk           : in     vl_logic;
        i_Rst           : in     vl_logic;
        i_Enable        : in     vl_logic;
        o_Sec0          : out    vl_logic_vector(3 downto 0);
        o_Sec1          : out    vl_logic_vector(3 downto 0);
        o_Sec2          : out    vl_logic_vector(3 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of LST_CLK : constant is 1;
end Timer;
