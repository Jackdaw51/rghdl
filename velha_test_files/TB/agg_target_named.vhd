-- ANALYSIS-ONLY. Do not add to the simulation bench.
--
-- A signal-assignment target that is an aggregate with NAMED association.
-- This is legal VHDL and GHDL 4.1.0 accepts it at analysis, but its mcode
-- backend aborts during code generation:
--
--   translate_signal_target_array_aggr: cannot handle
--   IIR_KIND_CHOICE_BY_EXPRESSION
--
-- Your parser should accept this file. Your elaborator should too. It is
-- included precisely because a reference implementation gets it wrong,
-- which makes it a good check that you are not just cloning GHDL.
library ieee;
use ieee.std_logic_1164.all;

entity agg_target_named is
    port (
        d : in  std_logic_vector(1 downto 0);
        p : out std_logic;
        q : out std_logic
    );
end entity agg_target_named;

architecture rtl of agg_target_named is
    signal ta, tb : std_logic := '0';
begin
    (0 => p, 1 => q) <= d;
    (1 => ta, 0 => tb) <= d;
end architecture rtl;
