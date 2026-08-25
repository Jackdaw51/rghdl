-- Rung 9: the declarative surface. (might not be totally covered)
-- Most VHDL parsers cover statements well and declarations badly. This file exercises the parts people skip: physical types, deferred constants,
-- resolution functions, unconstrained arrays, access and file types,
-- subprogram overloading, operator overloading with a string designator,
-- aliases (object and non-object), and attribute specification with entity class and signatures.

library ieee;
use ieee.std_logic_1164.all;

package decls_pkg is

    -- Physical type declaration with a primary and several secondary units.
    type capacitance is range 0 to 2147483647
        units
            femtofarad;
            picofarad = 1000 femtofarad;
            nanofarad = 1000 picofarad;
            microfarad = 1000 nanofarad;
        end units capacitance;

    -- Integer, floating and enumeration types.
    type small_int  is range -128 to 127;
    type gain_t     is range -1.0e3 to 1.0e3;
    type severity_e is (low, medium, high, critical);

    -- Unconstrained array type, then a constrained subtype of it.
    type word_array is array (natural range <>) of std_logic_vector(15 downto 0);
    subtype quad_word is word_array(0 to 3);

    -- Array indexed by an enumeration.
    type sev_count is array (severity_e) of natural;

    -- Access type and an incomplete type declaration for a linked list.
    type node_t;
    type node_ptr is access node_t;
    type node_t is record
        value : integer;
        nxt   : node_ptr;
    end record node_t;

    -- File type declaration.
    type log_file is file of string;

    -- Deferred constant: value supplied in the package body.
    constant DEFAULT_LOAD : capacitance;

    -- Subprogram overloading: same name, different profiles.
    function scale (v : integer;  k : integer)  return integer;
    function scale (v : real;     k : real)     return real;
    function scale (v : small_int) return small_int;

    -- Operator overloading with a string designator.
    function "+" (l, r : severity_e) return severity_e;
    function "abs" (x : small_int) return small_int;

    -- Non-object alias of a type, and an alias of a subprogram with a
    -- signature (needed to pick among overloads).
    alias int_scale is scale [integer, integer return integer];
    alias warr is word_array;   -- aliasing an enum type would re-alias its literals

    -- Attribute declaration and specifications with different entity classes.
    attribute ram_style   : string;
    attribute is_critical : boolean;

end package decls_pkg;

--------------------------------------------------------------------------
package body decls_pkg is

    -- Deferred constant given its value here.
    constant DEFAULT_LOAD : capacitance := 250 femtofarad;

    function scale (v : integer; k : integer) return integer is
    begin
        return v * k;
    end function scale;

    function scale (v : real; k : real) return real is
    begin
        return v * k;
    end function scale;

    function scale (v : small_int) return small_int is
    begin
        return v;
    end function scale;

    function "+" (l, r : severity_e) return severity_e is
    begin
        if severity_e'pos(l) > severity_e'pos(r) then
            return l;
        else
            return r;
        end if;
    end function "+";

    function "abs" (x : small_int) return small_int is
    begin
        if x < 0 then return -x; else return x; end if;
    end function "abs";

end package body decls_pkg;

--------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.decls_pkg.all;

entity decls is
    generic (
        load : capacitance := 100 femtofarad
    );
    port (
        clk  : in  std_logic;
        din  : in  std_logic_vector(15 downto 0);
        dout : out std_logic_vector(15 downto 0)
    );
end entity decls;

architecture rtl of decls is

    signal ram : quad_word := (others => (others => '0'));
    signal ptr : natural range 0 to 3 := 0;

    -- Attribute specification on a signal.
    attribute ram_style of ram : signal is "block";

    -- Object alias, including an alias of a slice.
    alias upper_byte : std_logic_vector(7 downto 0) is din(15 downto 8);

    -- Alias with an explicit (reversed) subtype indication.
    alias din_rev : std_logic_vector(0 to 15) is din;

    -- Shared variable of an access type (VHDL-93 form).
    shared variable head : node_ptr;

begin

    store : process (clk) is
        variable tally : sev_count := (others => 0);
        file     lg    : log_file;
    begin
        if rising_edge(clk) then
            ram(ptr) <= din;
            ptr      <= (ptr + 1) mod 4;
            tally(high) := tally(high) + 1;
        end if;
    end process store;

    dout <= ram(ptr) when upper_byte /= x"00" else din_rev;

end architecture rtl;

--------------------------------------------------------------------------
-- Configuration declaration: binds component instances to entities.
-- GHDL elaborates these, so an elaborator targeting GHDL must handle them.
configuration decls_cfg of decls is
    for rtl
    end for;
end configuration decls_cfg;

--------------------------------------------------------------------------
-- A configuration with a nested block/component configuration, exercising
-- the 'for ... use entity ...' binding indication.
library ieee;
use ieee.std_logic_1164.all;

configuration adder_cfg of work.full_adder is
    for struct
        for u_x1 : xor2
            use entity work.xor2(gate_level);
        end for;
        for others : and2
            use entity work.and2(rtl);
        end for;
    end for;
end configuration adder_cfg;
