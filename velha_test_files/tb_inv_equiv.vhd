library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity tb_inv_equiv is
end entity tb_inv_equiv;

architecture behavioral of tb_inv_equiv is
    signal a : std_logic;
    signal y_rtl : std_logic;
    signal y_rtl_flat : std_logic;

begin
    U_RTL: entity work.inv(rtl)
        port map (
        a => a,
        y => y_rtl
        );

    U_RTL_FLAT: entity work.inv_flat(rtl)
        port map (
        a => a,
        y => y_rtl_flat
        );

    STIMULUS_PROC: process
    begin
        -- Stimulus Vector 0
        a <= '0';
        wait for 10 ns;
        assert y_rtl_flat = y_rtl
            report "Equivalence Mismatch on entity 'inv', port 'y' (arch 'rtl') for vector 0" severity error;

        -- Stimulus Vector 1
        a <= '1';
        wait for 10 ns;
        assert y_rtl_flat = y_rtl
            report "Equivalence Mismatch on entity 'inv', port 'y' (arch 'rtl') for vector 1" severity error;

        wait;
    end process;
end architecture;
-- ========================================================

