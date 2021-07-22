library verilog;
use verilog.vl_types.all;
entity upcount_5 is
    port(
        Reset           : in     vl_logic;
        Clock           : in     vl_logic;
        count_en        : in     vl_logic;
        Q               : out    vl_logic_vector(4 downto 0)
    );
end upcount_5;
