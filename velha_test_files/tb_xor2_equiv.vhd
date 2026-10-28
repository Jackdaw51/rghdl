library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity tb_xor2_equiv is
end entity tb_xor2_equiv;

architecture behavioral of tb_xor2_equiv is
    signal a : std_logic;
    signal b : std_logic;
    signal y_rtl : std_logic;
    signal y_rtl_flat : std_logic;
    signal y_gate_level : std_logic;
    signal y_gate_level_flat : std_logic;

begin
    U_RTL: entity work.xor2(rtl)
        port map (
        a => a,
        b => b,
        y => y_rtl
        );

    U_GATE_LEVEL: entity work.xor2(gate_level)
        port map (
        a => a,
        b => b,
        y => y_gate_level
        );

    U_RTL_FLAT: entity work.xor2_flat(rtl)
        port map (
        a => a,
        b => b,
        y => y_rtl_flat
        );

    U_GATE_LEVEL_FLAT: entity work.xor2_flat(gate_level)
        port map (
        a => a,
        b => b,
        y => y_gate_level_flat
        );

    STIMULUS_PROC: process
    begin
	for i_0 in std_logic loop
        a <= i_0;
	for i_1 in std_logic loop
        b <= i_1;
        wait for 10 ns;
        assert y_rtl_flat = y_rtl
            report "Equivalence Mismatch on entity 'xor2', port 'y' (arch 'rtl')" severity error;
        assert y_gate_level_flat = y_gate_level
            report "Equivalence Mismatch on entity 'xor2', port 'y' (arch 'gate_level')" severity error;

	end loop;
	end loop;
        wait;
    end process;
end architecture;
-- ========================================================

