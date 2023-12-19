library verilog;
use verilog.vl_types.all;
entity Key is
    generic(
        IDLE            : vl_logic := Hi0;
        CHANGE          : vl_logic := Hi1
    );
    port(
        i_Clk           : in     vl_logic;
        i_Rst           : in     vl_logic;
        i_Push          : in     vl_logic_vector(3 downto 0);
        o_Push          : out    vl_logic_vector(3 downto 0);
        o_fOut          : out    vl_logic;
        o_LED           : out    vl_logic_vector(3 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of IDLE : constant is 1;
    attribute mti_svvh_generic_type of CHANGE : constant is 1;
end Key;
