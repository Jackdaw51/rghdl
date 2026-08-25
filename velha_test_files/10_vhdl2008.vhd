-- Rung 10: VHDL-2008 additions. OPTIONAL
-- Analyse this file with --std=08 ONLY. It must FAIL under --std=93, which
-- makes it a useful two-sided test: your parser needs a revision flag, not
-- a grammar that accepts the union of all revisions.
--
-- Exercises: context declarations, process(all), matching operators ?= ?/=,
-- the condition operator ??, case?, else/elsif in generate, simplified
-- conditional and selected assignment in sequential code, unconstrained
-- record elements, generic types on packages, external names, and the
-- extended 'if' in a subprogram return.

library ieee;
context ieee.ieee_std_context;

-- Context declaration: a named, reusable context clause.
context my_ctx is
    library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
end context my_ctx;

--------------------------------------------------------------------------
context work.my_ctx;

package v2008_pkg is
    -- Unconstrained element in a record (2008 only).
    type packet_t is record
        hdr     : std_logic_vector;
        payload : std_logic_vector;
    end record packet_t;

    subtype small_packet is packet_t(hdr(3 downto 0), payload(15 downto 0));
end package v2008_pkg;

--------------------------------------------------------------------------
context work.my_ctx;
use work.v2008_pkg.all;

entity v2008 is
    port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        d     : in  std_logic_vector(7 downto 0);
        patt  : in  std_logic_vector(7 downto 0);
        q     : out std_logic_vector(7 downto 0);
        hit   : out std_logic;
        flag  : out std_logic
    );
end entity v2008;

architecture rtl of v2008 is
    signal pkt   : small_packet;
    signal match : std_logic;
begin

    -- Matching relational operators: return std_ulogic, not boolean.
    match <= d ?= patt;
    hit   <= d(0) ?/= '0';

    -- process(all): implicit sensitivity list.
    comb : process (all) is
    begin
        -- Condition operator '??' makes a std_logic usable where a boolean
        -- is required. It is implicit in 'if', explicit elsewhere.
        if match then                   -- implicit ??
            flag <= '1';
        elsif ?? d(7) then              -- explicit ??
            flag <= '0';
        else
            flag <= 'X';
        end if;
    end process comb;

    -- case? : don't-care matching against '-' in the choices.
    sel : process (all) is
    begin
        case? d is
            when "1-------" => q <= x"01";
            when "01------" => q <= x"02";
            when "001-----" => q <= x"04";
            when others     => q <= x"00";
        end case?;
    end process sel;

    -- Conditional and selected assignment in SEQUENTIAL code (2008).
    seq : process (clk) is
    begin
        if rising_edge(clk) then
            pkt.hdr     <= d(3 downto 0) when rst = '0' else "0000";

            with d(1 downto 0) select
                pkt.payload <= x"0000" when "00",
                               x"FFFF" when "11",
                               x"AAAA" when others;
        end if;
    end process seq;

end architecture rtl;

--------------------------------------------------------------------------
context work.my_ctx;

entity gen2008 is
    generic (width : positive := 4);
    port (a : in std_logic_vector(width - 1 downto 0);
          y : out std_logic_vector(width - 1 downto 0));
end entity gen2008;

architecture rtl of gen2008 is
begin
    -- if/elsif/else generate (2008 only) with alternative labels.
    g : for i in a'range generate
        g_low : if i < 2 generate
            y(i) <= a(i);
        elsif i = 2 generate
            y(i) <= not a(i);
        else generate
            y(i) <= '0';
        end generate g_low;
    end generate g;
end architecture rtl;
