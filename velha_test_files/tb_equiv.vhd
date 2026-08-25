library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_nand2_equiv is
end entity tb_nand2_equiv;

architecture behavioral of tb_nand2_equiv is
    signal a : std_logic;
    signal b : std_logic;
    signal y_rtl : std_logic;
    signal y_flat : std_logic;

begin
    U_RTL: entity work.nand2(rtl)
        port map (
        a => a,
        b => b,
        y => y_rtl
        );

    U_FLAT: entity work.nand2_flat
        port map (
        a => a,
        b => b,
        y => y_flat
        );

    STIMULUS_PROC: process
    begin
        -- Stimulus Vector 0
        a <= '0';
        b <= '0';
        wait for 10 ns;
        assert y_flat = y_rtl
            report "Equivalence Mismatch on entity 'nand2', port 'y' (arch 'rtl') for vector 0" severity error;

        -- Stimulus Vector 1
        a <= '1';
        b <= '0';
        wait for 10 ns;
        assert y_flat = y_rtl
            report "Equivalence Mismatch on entity 'nand2', port 'y' (arch 'rtl') for vector 1" severity error;

        -- Stimulus Vector 2
        a <= '0';
        b <= '1';
        wait for 10 ns;
        assert y_flat = y_rtl
            report "Equivalence Mismatch on entity 'nand2', port 'y' (arch 'rtl') for vector 2" severity error;

        -- Stimulus Vector 3
        a <= '1';
        b <= '1';
        wait for 10 ns;
        assert y_flat = y_rtl
            report "Equivalence Mismatch on entity 'nand2', port 'y' (arch 'rtl') for vector 3" severity error;

        wait;
    end process;
end architecture;
-- ========================================================

