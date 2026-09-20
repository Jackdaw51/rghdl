library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity tb_full_adder_equiv is
end entity tb_full_adder_equiv;

architecture behavioral of tb_full_adder_equiv is
    signal a : std_logic;
    signal b : std_logic;
    signal cin : std_logic;
    signal sum_struct : std_logic;
    signal sum_struct_flat : std_logic;
    signal cout_struct : std_logic;
    signal cout_struct_flat : std_logic;

begin
    U_STRUCT: entity work.full_adder(struct)
        port map (
        a => a,
        b => b,
        cin => cin,
        sum => sum_struct,
        cout => cout_struct
        );

    U_STRUCT_FLAT: entity work.full_adder_flat(struct)
        port map (
        a => a,
        b => b,
        cin => cin,
        sum => sum_struct_flat,
        cout => cout_struct_flat
        );

    STIMULUS_PROC: process
    begin
        -- Stimulus Vector 0
        a <= '0';
        b <= '0';
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'full_adder', port 'sum' (arch 'struct') for vector 0" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'full_adder', port 'cout' (arch 'struct') for vector 0" severity error;

        -- Stimulus Vector 1
        a <= '1';
        b <= '0';
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'full_adder', port 'sum' (arch 'struct') for vector 1" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'full_adder', port 'cout' (arch 'struct') for vector 1" severity error;

        -- Stimulus Vector 2
        a <= '0';
        b <= '1';
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'full_adder', port 'sum' (arch 'struct') for vector 2" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'full_adder', port 'cout' (arch 'struct') for vector 2" severity error;

        -- Stimulus Vector 3
        a <= '1';
        b <= '1';
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'full_adder', port 'sum' (arch 'struct') for vector 3" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'full_adder', port 'cout' (arch 'struct') for vector 3" severity error;

        -- Stimulus Vector 4
        a <= '0';
        b <= '0';
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'full_adder', port 'sum' (arch 'struct') for vector 4" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'full_adder', port 'cout' (arch 'struct') for vector 4" severity error;

        -- Stimulus Vector 5
        a <= '1';
        b <= '0';
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'full_adder', port 'sum' (arch 'struct') for vector 5" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'full_adder', port 'cout' (arch 'struct') for vector 5" severity error;

        -- Stimulus Vector 6
        a <= '0';
        b <= '1';
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'full_adder', port 'sum' (arch 'struct') for vector 6" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'full_adder', port 'cout' (arch 'struct') for vector 6" severity error;

        -- Stimulus Vector 7
        a <= '1';
        b <= '1';
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'full_adder', port 'sum' (arch 'struct') for vector 7" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'full_adder', port 'cout' (arch 'struct') for vector 7" severity error;

        wait;
    end process;
end architecture;
-- ========================================================

