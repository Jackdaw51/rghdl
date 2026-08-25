-- Standalone reproducer for a GHDL 4.1.0 (mcode) code-generation crash.
--
--   $ ghdl -a ghdl_bug_named_aggregate_target.vhd
--   $ ghdl -r rep --stop-time=1ns
--   translate_signal_target_array_aggr: cannot handle
--   IIR_KIND_CHOICE_BY_EXPRESSION
--   ******************** GHDL Bug occurred ***************************
--
-- Analysis succeeds; the abort happens during code generation, which with
-- the mcode backend runs at 'ghdl -r', not at 'ghdl -e'.
-- The positional form  (p, q) <= s;  works correctly.
library ieee;
use ieee.std_logic_1164.all;

entity rep is
end entity rep;

architecture a of rep is
    signal s    : std_logic_vector(1 downto 0) := "10";
    signal p, q : std_logic;
begin
    (0 => p, 1 => q) <= s;
end architecture a;
