library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity tb_d_contention_equiv is
end entity tb_d_contention_equiv;

architecture behavioral of tb_d_contention_equiv is
    signal a : std_logic;
    signal b : std_logic;
    signal y_rtl : integer;
    signal y_rtl_flat : integer;

begin
    U_RTL: entity work.d_contention(rtl)
        port map (
        a => a,
        b => b,
        y => y_rtl
        );

    U_RTL_FLAT: entity work.d_contention_flat(rtl)
        port map (
        a => a,
        b => b,
        y => y_rtl_flat
        );

    STIMULUS_PROC: process
    begin
        -- Stimulus Vector 0
        a <= '0';
        b <= '0';
        wait for 10 ns;
        assert y_rtl_flat = y_rtl
            report "Equivalence Mismatch on entity 'd_contention', port 'y' (arch 'rtl') for vector 0" severity error;

        -- Stimulus Vector 1
        a <= '1';
        b <= '0';
        wait for 10 ns;
        assert y_rtl_flat = y_rtl
            report "Equivalence Mismatch on entity 'd_contention', port 'y' (arch 'rtl') for vector 1" severity error;

        -- Stimulus Vector 2
        a <= '0';
        b <= '1';
        wait for 10 ns;
        assert y_rtl_flat = y_rtl
            report "Equivalence Mismatch on entity 'd_contention', port 'y' (arch 'rtl') for vector 2" severity error;

        -- Stimulus Vector 3
        a <= '1';
        b <= '1';
        wait for 10 ns;
        assert y_rtl_flat = y_rtl
            report "Equivalence Mismatch on entity 'd_contention', port 'y' (arch 'rtl') for vector 3" severity error;

        wait;
    end process;
end architecture;
-- ========================================================

