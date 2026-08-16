library ieee;
use ieee.std_logic_1164.all;

entity tb_equiv is
end entity tb_equiv;

architecture behavioral of tb_equiv is
    signal a : std_logic;
    signal b : std_logic;
    signal z_orig : std_logic;
    signal z_flat : std_logic;

begin
    U_ORIG: entity work.and_gate
        port map (
            a => a,
            b => b,
            z => z_orig        );

    U_FLAT: entity work.and_gate_flat
        port map (
            a => a,
            b => b,
            z => z_flat        );

    STIMULUS_PROC: process
    begin
        -- Stimulus Vector 0
        a <= '0';
        b <= '0';
        wait for 10 ns;
        assert z_orig = z_flat
            report "Equivalence Mismatch on port 'z' for vector 0" severity error;

        -- Stimulus Vector 1
        a <= '1';
        b <= '0';
        wait for 10 ns;
        assert z_orig = z_flat
            report "Equivalence Mismatch on port 'z' for vector 1" severity error;

        -- Stimulus Vector 2
        a <= '0';
        b <= '1';
        wait for 10 ns;
        assert z_orig = z_flat
            report "Equivalence Mismatch on port 'z' for vector 2" severity error;

        -- Stimulus Vector 3
        a <= '1';
        b <= '1';
        wait for 10 ns;
        assert z_orig = z_flat
            report "Equivalence Mismatch on port 'z' for vector 3" severity error;

        wait;
    end process;
end architecture;