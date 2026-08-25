-- Rung 6: aggregates.
-- The token '=>' has three unrelated productions in VHDL:
--   1. element association in an aggregate      (others => '0')
--   2. formal/actual association in a map       port map (a => b)
--   3. choice in a case alternative             when "00" =>
-- A parser that shares one production across all three will accept
-- nonsense and reject legal code. All three appear below.
--
-- Also exercises: aggregate TARGETS on the left of an assignment, nested
-- aggregates, record aggregates with mixed positional/named parts, choice
-- lists and ranges inside aggregates, and the (x) vs (x => y) ambiguity
-- where a one-element aggregate is indistinguishable from a parenthesised
-- expression.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package agg_pkg is
    type point_t is record
        x : integer;
        y : integer;
    end record point_t;

    type frame_t is record
        origin : point_t;
        tag    : std_logic_vector(3 downto 0);
        valid  : boolean;
    end record frame_t;

    type row_t   is array (0 to 3) of std_logic_vector(7 downto 0);
    type grid_t  is array (0 to 1, 0 to 2) of std_logic;
end package agg_pkg;

--------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.agg_pkg.all;

entity aggregates is
    port (
        d      : in  std_logic_vector(7 downto 0);
        sel    : in  std_logic_vector(1 downto 0);
        a_out  : out std_logic;
        b_out  : out std_logic;
        q      : out std_logic_vector(7 downto 0)
    );
end entity aggregates;

architecture rtl of aggregates is

    -- Aggregates in constant initialisers.
    constant ALL_ZERO : std_logic_vector(7 downto 0) := (others => '0');
    constant MASK     : std_logic_vector(7 downto 0) := (7 | 0 => '1', others => '0');
    constant RANGED   : std_logic_vector(7 downto 0) := (7 downto 4 => '1', 3 downto 0 => '0');
    constant MIXED    : std_logic_vector(7 downto 0) := ('1', '0', others => 'Z');

    -- Record aggregates: positional, named, and mixed.
    constant P_POS    : point_t := (3, 4);
    constant P_NAMED  : point_t := (y => 4, x => 3);
    constant P_MULTI  : point_t := (x | y => 0);

    -- Nested aggregate: record containing a record and an array.
    constant F0 : frame_t := (
        origin => (x => 0, y => 0),
        tag    => (others => '0'),
        valid  => false
    );

    constant F1 : frame_t := (P_POS, "1010", true);   -- fully positional

    -- Array-of-array aggregate.
    constant ROWS : row_t := (
        0      => (others => '0'),
        1      => "11110000",
        others => (7 downto 4 => '1', others => '0')
    );

    -- Multidimensional aggregate.
    constant GRID : grid_t := (
        ('0', '1', '0'),
        ('1', '0', '1')
    );

    -- One-element aggregate vs parenthesised expression: the first is an
    -- aggregate only because the target type is an array; the second is
    -- just a parenthesised integer. Same syntax.
    constant ONE_ELEM : std_logic_vector(0 downto 0) := (others => '1');
    constant PARENTH  : integer := (42);

    signal ta, tb : std_logic;
    signal frame  : frame_t;

begin

    -- AGGREGATE TARGET on the left-hand side of a concurrent assignment.
    (ta, tb) <= d(1 downto 0);

    -- Aggregate target with named association on the left.
    (0 => a_out, 1 => b_out) <= std_logic_vector'(ta, tb);

    process (d, sel) is
        variable v : std_logic_vector(7 downto 0);
    begin
        -- Aggregate target in a sequential (variable) assignment.
        v := (others => '0');

        -- '=>' as a case choice, immediately adjacent to '=>' in aggregates.
        case sel is
            when "00"   => v := (others => '0');
            when "01"   => v := (7 downto 4 => '1', others => '0');
            when others => v := (d(0), d(1), d(2), d(3),
                                 d(4), d(5), d(6), d(7));
        end case;

        -- Record aggregate assigned to a signal, nested one level.
        frame <= (origin => (x => 1, y => 2), tag => sel & "00", valid => true);
    end process;

    -- '=>' as formal/actual association, in the same architecture.
    u_inv : entity work.inv
        port map (
            a => d(7),
            y => q(7)
        );

    q(6 downto 0) <= (d(6 downto 0) and MASK(6 downto 0)) or ALL_ZERO(6 downto 0);

end architecture rtl;
