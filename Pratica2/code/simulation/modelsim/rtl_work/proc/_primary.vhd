library verilog;
use verilog.vl_types.all;
entity proc is
    port(
        DIN             : in     vl_logic_vector(15 downto 0);
        mem             : in     vl_logic_vector(15 downto 0);
        Resetn          : in     vl_logic;
        Clock           : in     vl_logic;
        Run             : in     vl_logic;
        Done            : out    vl_logic;
        BusWires        : out    vl_logic_vector(15 downto 0);
        pc              : out    vl_logic_vector(5 downto 0);
        addrM           : out    vl_logic_vector(15 downto 0);
        doutM           : out    vl_logic_vector(15 downto 0);
        wM              : out    vl_logic
    );
end proc;
