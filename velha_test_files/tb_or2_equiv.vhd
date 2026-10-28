library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity tb_or2_equiv is
end entity tb_or2_equiv;

architecture behavioral of tb_or2_equiv is
    signal a : std_logic;
    signal b : std_logic;
    signal y_rtl : std_logic;
    signal y_rtl_flat : std_logic;

begin
    U_RTL: entity work.or2(rtl)
        port map (
        a => a,
        b => b,
        y => y_rtl
        );

    U_RTL_FLAT: entity work.or2_flat(rtl)
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
            report "Equivalence Mismatch on entity 'or2', port 'y' (arch 'rtl')" severity error;

	end loop;
	end loop;
        wait;
    end process;
end architecture;
-- ========================================================

