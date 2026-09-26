library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity tb_test_equiv is
end entity tb_test_equiv;

architecture behavioral of tb_test_equiv is
    signal a : std_logic;
    signal v_b : std_logic;
    signal v_b_flat : std_logic;

begin
    U_B: entity work.test(b)
        port map (
        a => a,
        v => v_b
        );

    U_B_FLAT: entity work.test_flat(b)
        port map (
        a => a,
        v => v_b_flat
        );

    STIMULUS_PROC: process
    begin
        -- Stimulus Vector 0
        a <= '0';
        wait for 10 ns;
        assert v_b_flat = v_b
            report "Equivalence Mismatch on entity 'test', port 'v' (arch 'b') for vector 0" severity error;

        -- Stimulus Vector 1
        a <= '1';
        wait for 10 ns;
        assert v_b_flat = v_b
            report "Equivalence Mismatch on entity 'test', port 'v' (arch 'b') for vector 1" severity error;

        wait;
    end process;
end architecture;
-- ========================================================

