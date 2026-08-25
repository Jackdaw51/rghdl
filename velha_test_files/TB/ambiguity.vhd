-- Rung 5: THE ambiguity file. This is the single most valuable test here.
--
-- Every construct below of the form  name ( ... )  is syntactically
-- identical. A parser CANNOT decide which is which; it must emit a uniform
-- "parenthesised name" node and defer to the elaborator, which needs the
-- symbol table to resolve it.
--
--   v(3)                     indexed name
--   v(3 downto 0)            slice name
--   f(3)                     function call
--   std_logic_vector(u)      type conversion
--   byte_t'(others => '0')   qualified expression
--
-- Likewise the tick character is overloaded at the LEXER level:
--   '0'          character literal
--   v'length     attribute name
--   byte_t'(..)  qualified expression
--   v'range      attribute used as a discrete range
-- Resolving it requires looking at the preceding token.
--
-- IMPORTANT FOR THE DIFFERENTIAL BENCH: every construct drives its own
-- dedicated signal, one driver each. An earlier draft piled several
-- constructs onto one output; because std_logic resolution collapses
-- disagreeing drivers to 'X' (and undriven ones to 'U'), the trace showed
-- 'U' no matter what the design did, and would have passed even if the
-- elaborator had resolved every name wrongly. One driver per construct is
-- what makes this file diagnostic rather than decorative.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package ambig_pkg is
    subtype byte_t is std_logic_vector(7 downto 0);
    type    mem_t  is array (0 to 3) of byte_t;

    function f (i : integer) return std_logic;
    function g (v : byte_t)  return byte_t;
end package ambig_pkg;

package body ambig_pkg is
    function f (i : integer) return std_logic is
    begin
        if i > 0 then return '1'; else return '0'; end if;
    end function f;

    function g (v : byte_t) return byte_t is
    begin
        return not v;
    end function g;
end package body ambig_pkg;

--------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.ambig_pkg.all;

entity ambiguity is
    port (
        v   : in  byte_t;
        u   : in  unsigned(7 downto 0);
        idx : in  integer range 0 to 3;

        -- One output per name form, so a mis-resolution is visible.
        o_indexed   : out std_logic;                     -- v(3)
        o_slice     : out std_logic_vector(3 downto 0);  -- v(3 downto 0)
        o_call      : out byte_t;                        -- g(v)
        o_conv      : out byte_t;                        -- std_logic_vector(u)
        o_qualified : out byte_t;                        -- byte_t'(...)
        o_nested    : out byte_t;                        -- g(g(v))
        o_mixed     : out byte_t;                        -- g(conv(u))
        o_memelem   : out byte_t;                        -- mem(idx)
        o_membit    : out std_logic;                     -- mem(idx)(2)
        o_memslice  : out std_logic_vector(3 downto 0);  -- mem(idx)(3 downto 0)
        o_callidx   : out std_logic;                     -- g(mem(idx))(7)
        o_selected  : out std_logic;                     -- work.pkg.f(1)
        o_selcall   : out byte_t;                        -- work.pkg.g(v)
        o_attrlen   : out integer;                       -- v'length
        o_attrspan  : out integer;                       -- v'high - v'low
        o_typeattr  : out integer;                       -- byte_t'length
        o_tickparen : out std_logic;                     -- f(v'length) and '0'
        o_genrange  : out std_logic                      -- v'range in generate
    );
end entity ambiguity;

architecture rtl of ambiguity is

    -- Initialised so the memory reads are defined values rather than 'U'.
    signal mem : mem_t := (x"00", x"55", x"AA", x"F0");

    -- Character literal in a declaration, to keep the tick-vs-literal case
    -- present without needing a character-typed port.
    constant TICK_CHAR : character := '0';

begin

    ----------------------------------------------------------------------
    -- Five syntactically identical constructs, five different meanings.
    ----------------------------------------------------------------------
    o_indexed <= v(3);                            -- indexed name
    o_slice   <= v(3 downto 0);                   -- slice name
    o_call    <= g(v);                            -- function call
    o_conv    <= std_logic_vector(u);             -- type conversion

    qual : process (v) is
        variable q : byte_t;
    begin
        q := byte_t'(others => '0');              -- qualified expression
        q := q or byte_t'("10101010");            -- qualified string literal
        o_qualified <= q;
        o_nested    <= g(g(v));                   -- nested call
    end process qual;

    o_mixed <= g(std_logic_vector(u));            -- call wrapping a conversion

    ----------------------------------------------------------------------
    -- Tick disambiguation. Each on its own driver.
    ----------------------------------------------------------------------
    o_attrlen  <= v'length;                       -- attribute name
    o_attrspan <= v'high - v'low;                 -- attributes in expression
    o_typeattr <= byte_t'length;                  -- attribute on a type mark

    -- Character literal immediately after a closing paren: the lexer must
    -- not read the tick in (v'length) '0' as an attribute tick.
    o_tickparen <= f(v'length) and '0';

    -- Attribute used as a discrete range in a generate scheme.
    gen : for i in v'range generate
        only_low : if i = 0 generate
            o_genrange <= v(v'low);
        end generate only_low;
    end generate gen;

    ----------------------------------------------------------------------
    -- Nested indexing: mem(idx)(2) applies an indexed name to the result
    -- of an indexed name. o_callidx indexes into a FUNCTION CALL result.
    ----------------------------------------------------------------------
    o_memelem  <= mem(idx);
    o_membit   <= mem(idx)(2);
    o_memslice <= mem(idx)(3 downto 0);
    o_callidx  <= g(mem(idx))(7);

    ----------------------------------------------------------------------
    -- Fully qualified (selected) names denoting subprograms.
    ----------------------------------------------------------------------
    o_selected <= work.ambig_pkg.f(1) and f(character'pos(TICK_CHAR) - 47);
    o_selcall  <= work.ambig_pkg.g(v);

end architecture rtl;
