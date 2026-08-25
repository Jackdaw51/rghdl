-- Rung 7: THE ambiguity file. This is the single most valuable test here.
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
        y   : out std_logic;
        w   : out byte_t;
        m   : out byte_t
    );
end entity ambiguity;

architecture rtl of ambiguity is

    signal mem   : mem_t;
    signal slice : std_logic_vector(3 downto 0);
    signal n     : integer;
    signal c     : character;

begin

    ----------------------------------------------------------------------
    -- Five syntactically identical constructs, five different meanings.
    ----------------------------------------------------------------------
    y     <= v(3);                            -- indexed name
    slice <= v(3 downto 0);                   -- slice name
    w     <= g(v);                            -- function call
    m     <= std_logic_vector(u);             -- type conversion

    process (v) is
        variable q : byte_t;
    begin
        q := byte_t'(others => '0');          -- qualified expression
        q := byte_t'("10101010");             -- qualified string literal
        q := g(g(v));                         -- nested call
        q := g(std_logic_vector(u));          -- call wrapping a conversion
    end process;

    ----------------------------------------------------------------------
    -- Tick disambiguation.
    ----------------------------------------------------------------------
    c <= '0';                                 -- character literal
    n <= v'length;                            -- attribute name
    n <= v'high - v'low;                      -- attributes in an expression
    n <= byte_t'length;                       -- attribute on a type mark

    -- Character literal immediately after a closing paren: the lexer must
    -- not read (v'length) '0' as an attribute tick.
    y <= f(v'length) and '0';

    -- Attribute used as a discrete range, and 'range on a slice of a
    -- multidimensional-ish selected name.
    gen : for i in v'range generate
        dummy : if i = 0 generate
            y <= v(v'low);
        end generate dummy;
    end generate gen;

    ----------------------------------------------------------------------
    -- Nested indexing on an array-of-array: mem(idx)(2) is an indexed name
    -- applied to the result of an indexed name.
    ----------------------------------------------------------------------
    y <= mem(idx)(2);
    w <= mem(idx);
    slice <= mem(idx)(3 downto 0);
    y <= g(mem(idx))(7);                      -- index into a call result

    ----------------------------------------------------------------------
    -- Signature-bearing and selected names.
    ----------------------------------------------------------------------
    y <= work.ambig_pkg.f(1);                 -- fully qualified call
    w <= work.ambig_pkg.g(v);

end architecture rtl;
