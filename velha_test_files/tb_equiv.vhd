library ieee;
use ieee.std_logic_1164.all;

entity tb_equiv is
end entity tb_equiv;

architecture behavioral of tb_equiv is
    signal a : std_logic;
    signal y_orig : std_logic;
    signal y_flat : std_logic;

begin
    U_ORIG: entity work.inv
        port map (
            a => a,
            y => y_orig        );

    U_FLAT: entity work.inv_flat
        port map (
            a => a,
            y => y_flat        );

    STIMULUS_PROC: process
    begin
        -- Stimulus Vector 0
        a <= '0';
        wait for 10 ns;
        assert y_orig = y_flat
            report "Equivalence Mismatch on port 'y' for vector 0" severity error;

        -- Stimulus Vector 1
        a <= '1';
        wait for 10 ns;
        assert y_orig = y_flat
            report "Equivalence Mismatch on port 'y' for vector 1" severity error;

        wait;
    end process;
end architecture;