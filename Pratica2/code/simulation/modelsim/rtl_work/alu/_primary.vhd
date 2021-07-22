library verilog;
use verilog.vl_types.all;
entity alu is
    port(
        aluSignal       : in     vl_logic_vector(2 downto 0);
        A               : in     vl_logic_vector(15 downto 0);
        BusWires        : in     vl_logic_vector(15 downto 0);
        G               : out    vl_logic_vector(15 downto 0)
    );
end alu;
