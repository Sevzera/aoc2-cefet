library verilog;
use verilog.vl_types.all;
entity m_cache is
    port(
        clock           : in     vl_logic;
        test_tag        : in     vl_logic_vector(7 downto 0);
        test_data       : in     vl_logic_vector(7 downto 0);
        test_wren       : in     vl_logic
    );
end m_cache;
