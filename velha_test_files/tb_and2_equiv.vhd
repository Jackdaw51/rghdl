library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity tb_and2_equiv is
end entity tb_and2_equiv;

architecture behavioral of tb_and2_equiv is
    signal a : std_logic;
    signal b : std_logic;
    signal y_rtl : std_logic;
    signal y_rtl_flat : std_logic;

begin
    U_RTL: entity work.and2(rtl)
        port map (
        a => a,
        b => b,
        y => y_rtl
        );

    U_RTL_FLAT: entity work.and2_flat(rtl)
        port map (
        a => a,
        b => b,
        y => y_rtl_flat
        );

    STIMULUS_PROC: process
    begin
	for i_0 in std_logic loop
        a <= i_0;
	for i_1 in std_logic loop
        b <= i_1;
        wait for 10 ns;
        assert y_rtl_flat = y_rtl
            report "Equivalence Mismatch on entity 'and2', port 'y' (arch 'rtl')" severity error;

	end loop;
	end loop;
        wait;
    end process;
end architecture;
-- ========================================================

