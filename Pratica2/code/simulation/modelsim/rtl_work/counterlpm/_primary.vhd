library verilog;
use verilog.vl_types.all;
entity counterlpm is
    port(
        clk_en          : in     vl_logic;
        clock           : in     vl_logic;
        cnt_en          : in     vl_logic;
        data            : in     vl_logic_vector(5 downto 0);
        sclr            : in     vl_logic;
        sload           : in     vl_logic;
        q               : out    vl_logic_vector(5 downto 0)
    );
end counterlpm;
