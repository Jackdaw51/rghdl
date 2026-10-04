library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity tb_ripple_adder_equiv is
end entity tb_ripple_adder_equiv;

architecture behavioral of tb_ripple_adder_equiv is
    signal a : std_logic_vector (3 downto 0);
    signal b : std_logic_vector (3 downto 0);
    signal cin : std_logic;
    signal sum_struct : std_logic_vector (3 downto 0);
    signal sum_struct_flat : std_logic_vector (3 downto 0);
    signal cout_struct : std_logic;
    signal cout_struct_flat : std_logic;
    signal unused_struct : std_logic;
    signal unused_struct_flat : std_logic;

begin
    U_STRUCT: entity work.ripple_adder(struct)
        port map (
        a => a,
        b => b,
        cin => cin,
        sum => sum_struct,
        cout => cout_struct,
        unused => unused_struct
        );

    U_STRUCT_FLAT: entity work.ripple_adder_flat(struct)
        port map (
        a => a,
        b => b,
        cin => cin,
        sum => sum_struct_flat,
        cout => cout_struct_flat,
        unused => unused_struct_flat
        );

    STIMULUS_PROC: process
    begin
        -- Stimulus Vector 0
        a <= "0000";
        b <= "0000";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 0" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 0" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 0" severity error;

        -- Stimulus Vector 1
        a <= "0001";
        b <= "0000";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 1" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 1" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 1" severity error;

        -- Stimulus Vector 2
        a <= "0010";
        b <= "0000";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 2" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 2" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 2" severity error;

        -- Stimulus Vector 3
        a <= "0011";
        b <= "0000";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 3" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 3" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 3" severity error;

        -- Stimulus Vector 4
        a <= "0100";
        b <= "0000";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 4" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 4" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 4" severity error;

        -- Stimulus Vector 5
        a <= "0101";
        b <= "0000";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 5" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 5" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 5" severity error;

        -- Stimulus Vector 6
        a <= "0110";
        b <= "0000";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 6" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 6" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 6" severity error;

        -- Stimulus Vector 7
        a <= "0111";
        b <= "0000";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 7" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 7" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 7" severity error;

        -- Stimulus Vector 8
        a <= "1000";
        b <= "0000";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 8" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 8" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 8" severity error;

        -- Stimulus Vector 9
        a <= "1001";
        b <= "0000";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 9" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 9" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 9" severity error;

        -- Stimulus Vector 10
        a <= "1010";
        b <= "0000";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 10" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 10" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 10" severity error;

        -- Stimulus Vector 11
        a <= "1011";
        b <= "0000";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 11" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 11" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 11" severity error;

        -- Stimulus Vector 12
        a <= "1100";
        b <= "0000";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 12" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 12" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 12" severity error;

        -- Stimulus Vector 13
        a <= "1101";
        b <= "0000";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 13" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 13" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 13" severity error;

        -- Stimulus Vector 14
        a <= "1110";
        b <= "0000";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 14" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 14" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 14" severity error;

        -- Stimulus Vector 15
        a <= "1111";
        b <= "0000";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 15" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 15" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 15" severity error;

        -- Stimulus Vector 16
        a <= "0000";
        b <= "0001";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 16" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 16" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 16" severity error;

        -- Stimulus Vector 17
        a <= "0001";
        b <= "0001";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 17" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 17" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 17" severity error;

        -- Stimulus Vector 18
        a <= "0010";
        b <= "0001";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 18" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 18" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 18" severity error;

        -- Stimulus Vector 19
        a <= "0011";
        b <= "0001";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 19" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 19" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 19" severity error;

        -- Stimulus Vector 20
        a <= "0100";
        b <= "0001";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 20" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 20" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 20" severity error;

        -- Stimulus Vector 21
        a <= "0101";
        b <= "0001";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 21" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 21" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 21" severity error;

        -- Stimulus Vector 22
        a <= "0110";
        b <= "0001";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 22" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 22" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 22" severity error;

        -- Stimulus Vector 23
        a <= "0111";
        b <= "0001";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 23" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 23" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 23" severity error;

        -- Stimulus Vector 24
        a <= "1000";
        b <= "0001";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 24" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 24" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 24" severity error;

        -- Stimulus Vector 25
        a <= "1001";
        b <= "0001";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 25" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 25" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 25" severity error;

        -- Stimulus Vector 26
        a <= "1010";
        b <= "0001";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 26" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 26" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 26" severity error;

        -- Stimulus Vector 27
        a <= "1011";
        b <= "0001";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 27" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 27" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 27" severity error;

        -- Stimulus Vector 28
        a <= "1100";
        b <= "0001";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 28" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 28" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 28" severity error;

        -- Stimulus Vector 29
        a <= "1101";
        b <= "0001";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 29" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 29" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 29" severity error;

        -- Stimulus Vector 30
        a <= "1110";
        b <= "0001";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 30" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 30" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 30" severity error;

        -- Stimulus Vector 31
        a <= "1111";
        b <= "0001";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 31" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 31" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 31" severity error;

        -- Stimulus Vector 32
        a <= "0000";
        b <= "0010";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 32" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 32" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 32" severity error;

        -- Stimulus Vector 33
        a <= "0001";
        b <= "0010";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 33" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 33" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 33" severity error;

        -- Stimulus Vector 34
        a <= "0010";
        b <= "0010";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 34" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 34" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 34" severity error;

        -- Stimulus Vector 35
        a <= "0011";
        b <= "0010";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 35" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 35" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 35" severity error;

        -- Stimulus Vector 36
        a <= "0100";
        b <= "0010";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 36" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 36" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 36" severity error;

        -- Stimulus Vector 37
        a <= "0101";
        b <= "0010";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 37" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 37" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 37" severity error;

        -- Stimulus Vector 38
        a <= "0110";
        b <= "0010";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 38" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 38" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 38" severity error;

        -- Stimulus Vector 39
        a <= "0111";
        b <= "0010";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 39" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 39" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 39" severity error;

        -- Stimulus Vector 40
        a <= "1000";
        b <= "0010";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 40" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 40" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 40" severity error;

        -- Stimulus Vector 41
        a <= "1001";
        b <= "0010";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 41" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 41" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 41" severity error;

        -- Stimulus Vector 42
        a <= "1010";
        b <= "0010";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 42" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 42" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 42" severity error;

        -- Stimulus Vector 43
        a <= "1011";
        b <= "0010";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 43" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 43" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 43" severity error;

        -- Stimulus Vector 44
        a <= "1100";
        b <= "0010";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 44" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 44" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 44" severity error;

        -- Stimulus Vector 45
        a <= "1101";
        b <= "0010";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 45" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 45" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 45" severity error;

        -- Stimulus Vector 46
        a <= "1110";
        b <= "0010";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 46" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 46" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 46" severity error;

        -- Stimulus Vector 47
        a <= "1111";
        b <= "0010";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 47" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 47" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 47" severity error;

        -- Stimulus Vector 48
        a <= "0000";
        b <= "0011";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 48" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 48" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 48" severity error;

        -- Stimulus Vector 49
        a <= "0001";
        b <= "0011";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 49" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 49" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 49" severity error;

        -- Stimulus Vector 50
        a <= "0010";
        b <= "0011";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 50" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 50" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 50" severity error;

        -- Stimulus Vector 51
        a <= "0011";
        b <= "0011";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 51" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 51" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 51" severity error;

        -- Stimulus Vector 52
        a <= "0100";
        b <= "0011";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 52" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 52" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 52" severity error;

        -- Stimulus Vector 53
        a <= "0101";
        b <= "0011";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 53" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 53" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 53" severity error;

        -- Stimulus Vector 54
        a <= "0110";
        b <= "0011";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 54" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 54" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 54" severity error;

        -- Stimulus Vector 55
        a <= "0111";
        b <= "0011";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 55" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 55" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 55" severity error;

        -- Stimulus Vector 56
        a <= "1000";
        b <= "0011";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 56" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 56" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 56" severity error;

        -- Stimulus Vector 57
        a <= "1001";
        b <= "0011";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 57" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 57" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 57" severity error;

        -- Stimulus Vector 58
        a <= "1010";
        b <= "0011";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 58" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 58" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 58" severity error;

        -- Stimulus Vector 59
        a <= "1011";
        b <= "0011";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 59" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 59" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 59" severity error;

        -- Stimulus Vector 60
        a <= "1100";
        b <= "0011";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 60" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 60" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 60" severity error;

        -- Stimulus Vector 61
        a <= "1101";
        b <= "0011";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 61" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 61" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 61" severity error;

        -- Stimulus Vector 62
        a <= "1110";
        b <= "0011";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 62" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 62" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 62" severity error;

        -- Stimulus Vector 63
        a <= "1111";
        b <= "0011";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 63" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 63" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 63" severity error;

        -- Stimulus Vector 64
        a <= "0000";
        b <= "0100";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 64" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 64" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 64" severity error;

        -- Stimulus Vector 65
        a <= "0001";
        b <= "0100";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 65" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 65" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 65" severity error;

        -- Stimulus Vector 66
        a <= "0010";
        b <= "0100";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 66" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 66" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 66" severity error;

        -- Stimulus Vector 67
        a <= "0011";
        b <= "0100";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 67" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 67" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 67" severity error;

        -- Stimulus Vector 68
        a <= "0100";
        b <= "0100";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 68" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 68" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 68" severity error;

        -- Stimulus Vector 69
        a <= "0101";
        b <= "0100";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 69" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 69" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 69" severity error;

        -- Stimulus Vector 70
        a <= "0110";
        b <= "0100";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 70" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 70" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 70" severity error;

        -- Stimulus Vector 71
        a <= "0111";
        b <= "0100";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 71" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 71" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 71" severity error;

        -- Stimulus Vector 72
        a <= "1000";
        b <= "0100";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 72" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 72" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 72" severity error;

        -- Stimulus Vector 73
        a <= "1001";
        b <= "0100";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 73" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 73" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 73" severity error;

        -- Stimulus Vector 74
        a <= "1010";
        b <= "0100";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 74" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 74" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 74" severity error;

        -- Stimulus Vector 75
        a <= "1011";
        b <= "0100";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 75" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 75" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 75" severity error;

        -- Stimulus Vector 76
        a <= "1100";
        b <= "0100";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 76" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 76" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 76" severity error;

        -- Stimulus Vector 77
        a <= "1101";
        b <= "0100";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 77" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 77" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 77" severity error;

        -- Stimulus Vector 78
        a <= "1110";
        b <= "0100";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 78" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 78" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 78" severity error;

        -- Stimulus Vector 79
        a <= "1111";
        b <= "0100";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 79" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 79" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 79" severity error;

        -- Stimulus Vector 80
        a <= "0000";
        b <= "0101";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 80" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 80" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 80" severity error;

        -- Stimulus Vector 81
        a <= "0001";
        b <= "0101";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 81" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 81" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 81" severity error;

        -- Stimulus Vector 82
        a <= "0010";
        b <= "0101";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 82" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 82" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 82" severity error;

        -- Stimulus Vector 83
        a <= "0011";
        b <= "0101";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 83" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 83" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 83" severity error;

        -- Stimulus Vector 84
        a <= "0100";
        b <= "0101";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 84" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 84" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 84" severity error;

        -- Stimulus Vector 85
        a <= "0101";
        b <= "0101";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 85" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 85" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 85" severity error;

        -- Stimulus Vector 86
        a <= "0110";
        b <= "0101";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 86" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 86" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 86" severity error;

        -- Stimulus Vector 87
        a <= "0111";
        b <= "0101";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 87" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 87" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 87" severity error;

        -- Stimulus Vector 88
        a <= "1000";
        b <= "0101";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 88" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 88" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 88" severity error;

        -- Stimulus Vector 89
        a <= "1001";
        b <= "0101";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 89" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 89" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 89" severity error;

        -- Stimulus Vector 90
        a <= "1010";
        b <= "0101";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 90" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 90" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 90" severity error;

        -- Stimulus Vector 91
        a <= "1011";
        b <= "0101";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 91" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 91" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 91" severity error;

        -- Stimulus Vector 92
        a <= "1100";
        b <= "0101";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 92" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 92" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 92" severity error;

        -- Stimulus Vector 93
        a <= "1101";
        b <= "0101";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 93" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 93" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 93" severity error;

        -- Stimulus Vector 94
        a <= "1110";
        b <= "0101";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 94" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 94" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 94" severity error;

        -- Stimulus Vector 95
        a <= "1111";
        b <= "0101";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 95" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 95" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 95" severity error;

        -- Stimulus Vector 96
        a <= "0000";
        b <= "0110";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 96" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 96" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 96" severity error;

        -- Stimulus Vector 97
        a <= "0001";
        b <= "0110";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 97" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 97" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 97" severity error;

        -- Stimulus Vector 98
        a <= "0010";
        b <= "0110";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 98" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 98" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 98" severity error;

        -- Stimulus Vector 99
        a <= "0011";
        b <= "0110";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 99" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 99" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 99" severity error;

        -- Stimulus Vector 100
        a <= "0100";
        b <= "0110";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 100" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 100" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 100" severity error;

        -- Stimulus Vector 101
        a <= "0101";
        b <= "0110";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 101" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 101" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 101" severity error;

        -- Stimulus Vector 102
        a <= "0110";
        b <= "0110";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 102" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 102" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 102" severity error;

        -- Stimulus Vector 103
        a <= "0111";
        b <= "0110";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 103" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 103" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 103" severity error;

        -- Stimulus Vector 104
        a <= "1000";
        b <= "0110";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 104" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 104" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 104" severity error;

        -- Stimulus Vector 105
        a <= "1001";
        b <= "0110";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 105" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 105" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 105" severity error;

        -- Stimulus Vector 106
        a <= "1010";
        b <= "0110";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 106" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 106" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 106" severity error;

        -- Stimulus Vector 107
        a <= "1011";
        b <= "0110";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 107" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 107" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 107" severity error;

        -- Stimulus Vector 108
        a <= "1100";
        b <= "0110";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 108" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 108" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 108" severity error;

        -- Stimulus Vector 109
        a <= "1101";
        b <= "0110";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 109" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 109" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 109" severity error;

        -- Stimulus Vector 110
        a <= "1110";
        b <= "0110";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 110" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 110" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 110" severity error;

        -- Stimulus Vector 111
        a <= "1111";
        b <= "0110";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 111" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 111" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 111" severity error;

        -- Stimulus Vector 112
        a <= "0000";
        b <= "0111";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 112" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 112" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 112" severity error;

        -- Stimulus Vector 113
        a <= "0001";
        b <= "0111";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 113" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 113" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 113" severity error;

        -- Stimulus Vector 114
        a <= "0010";
        b <= "0111";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 114" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 114" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 114" severity error;

        -- Stimulus Vector 115
        a <= "0011";
        b <= "0111";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 115" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 115" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 115" severity error;

        -- Stimulus Vector 116
        a <= "0100";
        b <= "0111";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 116" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 116" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 116" severity error;

        -- Stimulus Vector 117
        a <= "0101";
        b <= "0111";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 117" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 117" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 117" severity error;

        -- Stimulus Vector 118
        a <= "0110";
        b <= "0111";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 118" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 118" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 118" severity error;

        -- Stimulus Vector 119
        a <= "0111";
        b <= "0111";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 119" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 119" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 119" severity error;

        -- Stimulus Vector 120
        a <= "1000";
        b <= "0111";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 120" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 120" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 120" severity error;

        -- Stimulus Vector 121
        a <= "1001";
        b <= "0111";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 121" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 121" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 121" severity error;

        -- Stimulus Vector 122
        a <= "1010";
        b <= "0111";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 122" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 122" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 122" severity error;

        -- Stimulus Vector 123
        a <= "1011";
        b <= "0111";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 123" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 123" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 123" severity error;

        -- Stimulus Vector 124
        a <= "1100";
        b <= "0111";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 124" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 124" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 124" severity error;

        -- Stimulus Vector 125
        a <= "1101";
        b <= "0111";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 125" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 125" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 125" severity error;

        -- Stimulus Vector 126
        a <= "1110";
        b <= "0111";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 126" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 126" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 126" severity error;

        -- Stimulus Vector 127
        a <= "1111";
        b <= "0111";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 127" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 127" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 127" severity error;

        -- Stimulus Vector 128
        a <= "0000";
        b <= "1000";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 128" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 128" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 128" severity error;

        -- Stimulus Vector 129
        a <= "0001";
        b <= "1000";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 129" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 129" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 129" severity error;

        -- Stimulus Vector 130
        a <= "0010";
        b <= "1000";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 130" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 130" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 130" severity error;

        -- Stimulus Vector 131
        a <= "0011";
        b <= "1000";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 131" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 131" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 131" severity error;

        -- Stimulus Vector 132
        a <= "0100";
        b <= "1000";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 132" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 132" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 132" severity error;

        -- Stimulus Vector 133
        a <= "0101";
        b <= "1000";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 133" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 133" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 133" severity error;

        -- Stimulus Vector 134
        a <= "0110";
        b <= "1000";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 134" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 134" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 134" severity error;

        -- Stimulus Vector 135
        a <= "0111";
        b <= "1000";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 135" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 135" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 135" severity error;

        -- Stimulus Vector 136
        a <= "1000";
        b <= "1000";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 136" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 136" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 136" severity error;

        -- Stimulus Vector 137
        a <= "1001";
        b <= "1000";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 137" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 137" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 137" severity error;

        -- Stimulus Vector 138
        a <= "1010";
        b <= "1000";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 138" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 138" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 138" severity error;

        -- Stimulus Vector 139
        a <= "1011";
        b <= "1000";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 139" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 139" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 139" severity error;

        -- Stimulus Vector 140
        a <= "1100";
        b <= "1000";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 140" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 140" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 140" severity error;

        -- Stimulus Vector 141
        a <= "1101";
        b <= "1000";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 141" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 141" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 141" severity error;

        -- Stimulus Vector 142
        a <= "1110";
        b <= "1000";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 142" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 142" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 142" severity error;

        -- Stimulus Vector 143
        a <= "1111";
        b <= "1000";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 143" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 143" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 143" severity error;

        -- Stimulus Vector 144
        a <= "0000";
        b <= "1001";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 144" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 144" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 144" severity error;

        -- Stimulus Vector 145
        a <= "0001";
        b <= "1001";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 145" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 145" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 145" severity error;

        -- Stimulus Vector 146
        a <= "0010";
        b <= "1001";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 146" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 146" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 146" severity error;

        -- Stimulus Vector 147
        a <= "0011";
        b <= "1001";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 147" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 147" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 147" severity error;

        -- Stimulus Vector 148
        a <= "0100";
        b <= "1001";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 148" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 148" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 148" severity error;

        -- Stimulus Vector 149
        a <= "0101";
        b <= "1001";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 149" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 149" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 149" severity error;

        -- Stimulus Vector 150
        a <= "0110";
        b <= "1001";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 150" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 150" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 150" severity error;

        -- Stimulus Vector 151
        a <= "0111";
        b <= "1001";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 151" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 151" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 151" severity error;

        -- Stimulus Vector 152
        a <= "1000";
        b <= "1001";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 152" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 152" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 152" severity error;

        -- Stimulus Vector 153
        a <= "1001";
        b <= "1001";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 153" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 153" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 153" severity error;

        -- Stimulus Vector 154
        a <= "1010";
        b <= "1001";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 154" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 154" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 154" severity error;

        -- Stimulus Vector 155
        a <= "1011";
        b <= "1001";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 155" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 155" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 155" severity error;

        -- Stimulus Vector 156
        a <= "1100";
        b <= "1001";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 156" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 156" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 156" severity error;

        -- Stimulus Vector 157
        a <= "1101";
        b <= "1001";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 157" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 157" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 157" severity error;

        -- Stimulus Vector 158
        a <= "1110";
        b <= "1001";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 158" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 158" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 158" severity error;

        -- Stimulus Vector 159
        a <= "1111";
        b <= "1001";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 159" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 159" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 159" severity error;

        -- Stimulus Vector 160
        a <= "0000";
        b <= "1010";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 160" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 160" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 160" severity error;

        -- Stimulus Vector 161
        a <= "0001";
        b <= "1010";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 161" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 161" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 161" severity error;

        -- Stimulus Vector 162
        a <= "0010";
        b <= "1010";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 162" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 162" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 162" severity error;

        -- Stimulus Vector 163
        a <= "0011";
        b <= "1010";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 163" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 163" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 163" severity error;

        -- Stimulus Vector 164
        a <= "0100";
        b <= "1010";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 164" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 164" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 164" severity error;

        -- Stimulus Vector 165
        a <= "0101";
        b <= "1010";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 165" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 165" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 165" severity error;

        -- Stimulus Vector 166
        a <= "0110";
        b <= "1010";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 166" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 166" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 166" severity error;

        -- Stimulus Vector 167
        a <= "0111";
        b <= "1010";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 167" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 167" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 167" severity error;

        -- Stimulus Vector 168
        a <= "1000";
        b <= "1010";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 168" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 168" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 168" severity error;

        -- Stimulus Vector 169
        a <= "1001";
        b <= "1010";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 169" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 169" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 169" severity error;

        -- Stimulus Vector 170
        a <= "1010";
        b <= "1010";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 170" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 170" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 170" severity error;

        -- Stimulus Vector 171
        a <= "1011";
        b <= "1010";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 171" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 171" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 171" severity error;

        -- Stimulus Vector 172
        a <= "1100";
        b <= "1010";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 172" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 172" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 172" severity error;

        -- Stimulus Vector 173
        a <= "1101";
        b <= "1010";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 173" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 173" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 173" severity error;

        -- Stimulus Vector 174
        a <= "1110";
        b <= "1010";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 174" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 174" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 174" severity error;

        -- Stimulus Vector 175
        a <= "1111";
        b <= "1010";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 175" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 175" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 175" severity error;

        -- Stimulus Vector 176
        a <= "0000";
        b <= "1011";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 176" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 176" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 176" severity error;

        -- Stimulus Vector 177
        a <= "0001";
        b <= "1011";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 177" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 177" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 177" severity error;

        -- Stimulus Vector 178
        a <= "0010";
        b <= "1011";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 178" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 178" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 178" severity error;

        -- Stimulus Vector 179
        a <= "0011";
        b <= "1011";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 179" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 179" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 179" severity error;

        -- Stimulus Vector 180
        a <= "0100";
        b <= "1011";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 180" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 180" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 180" severity error;

        -- Stimulus Vector 181
        a <= "0101";
        b <= "1011";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 181" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 181" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 181" severity error;

        -- Stimulus Vector 182
        a <= "0110";
        b <= "1011";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 182" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 182" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 182" severity error;

        -- Stimulus Vector 183
        a <= "0111";
        b <= "1011";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 183" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 183" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 183" severity error;

        -- Stimulus Vector 184
        a <= "1000";
        b <= "1011";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 184" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 184" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 184" severity error;

        -- Stimulus Vector 185
        a <= "1001";
        b <= "1011";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 185" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 185" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 185" severity error;

        -- Stimulus Vector 186
        a <= "1010";
        b <= "1011";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 186" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 186" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 186" severity error;

        -- Stimulus Vector 187
        a <= "1011";
        b <= "1011";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 187" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 187" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 187" severity error;

        -- Stimulus Vector 188
        a <= "1100";
        b <= "1011";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 188" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 188" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 188" severity error;

        -- Stimulus Vector 189
        a <= "1101";
        b <= "1011";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 189" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 189" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 189" severity error;

        -- Stimulus Vector 190
        a <= "1110";
        b <= "1011";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 190" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 190" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 190" severity error;

        -- Stimulus Vector 191
        a <= "1111";
        b <= "1011";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 191" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 191" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 191" severity error;

        -- Stimulus Vector 192
        a <= "0000";
        b <= "1100";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 192" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 192" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 192" severity error;

        -- Stimulus Vector 193
        a <= "0001";
        b <= "1100";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 193" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 193" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 193" severity error;

        -- Stimulus Vector 194
        a <= "0010";
        b <= "1100";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 194" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 194" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 194" severity error;

        -- Stimulus Vector 195
        a <= "0011";
        b <= "1100";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 195" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 195" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 195" severity error;

        -- Stimulus Vector 196
        a <= "0100";
        b <= "1100";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 196" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 196" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 196" severity error;

        -- Stimulus Vector 197
        a <= "0101";
        b <= "1100";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 197" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 197" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 197" severity error;

        -- Stimulus Vector 198
        a <= "0110";
        b <= "1100";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 198" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 198" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 198" severity error;

        -- Stimulus Vector 199
        a <= "0111";
        b <= "1100";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 199" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 199" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 199" severity error;

        -- Stimulus Vector 200
        a <= "1000";
        b <= "1100";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 200" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 200" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 200" severity error;

        -- Stimulus Vector 201
        a <= "1001";
        b <= "1100";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 201" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 201" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 201" severity error;

        -- Stimulus Vector 202
        a <= "1010";
        b <= "1100";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 202" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 202" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 202" severity error;

        -- Stimulus Vector 203
        a <= "1011";
        b <= "1100";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 203" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 203" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 203" severity error;

        -- Stimulus Vector 204
        a <= "1100";
        b <= "1100";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 204" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 204" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 204" severity error;

        -- Stimulus Vector 205
        a <= "1101";
        b <= "1100";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 205" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 205" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 205" severity error;

        -- Stimulus Vector 206
        a <= "1110";
        b <= "1100";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 206" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 206" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 206" severity error;

        -- Stimulus Vector 207
        a <= "1111";
        b <= "1100";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 207" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 207" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 207" severity error;

        -- Stimulus Vector 208
        a <= "0000";
        b <= "1101";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 208" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 208" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 208" severity error;

        -- Stimulus Vector 209
        a <= "0001";
        b <= "1101";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 209" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 209" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 209" severity error;

        -- Stimulus Vector 210
        a <= "0010";
        b <= "1101";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 210" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 210" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 210" severity error;

        -- Stimulus Vector 211
        a <= "0011";
        b <= "1101";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 211" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 211" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 211" severity error;

        -- Stimulus Vector 212
        a <= "0100";
        b <= "1101";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 212" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 212" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 212" severity error;

        -- Stimulus Vector 213
        a <= "0101";
        b <= "1101";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 213" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 213" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 213" severity error;

        -- Stimulus Vector 214
        a <= "0110";
        b <= "1101";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 214" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 214" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 214" severity error;

        -- Stimulus Vector 215
        a <= "0111";
        b <= "1101";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 215" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 215" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 215" severity error;

        -- Stimulus Vector 216
        a <= "1000";
        b <= "1101";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 216" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 216" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 216" severity error;

        -- Stimulus Vector 217
        a <= "1001";
        b <= "1101";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 217" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 217" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 217" severity error;

        -- Stimulus Vector 218
        a <= "1010";
        b <= "1101";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 218" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 218" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 218" severity error;

        -- Stimulus Vector 219
        a <= "1011";
        b <= "1101";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 219" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 219" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 219" severity error;

        -- Stimulus Vector 220
        a <= "1100";
        b <= "1101";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 220" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 220" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 220" severity error;

        -- Stimulus Vector 221
        a <= "1101";
        b <= "1101";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 221" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 221" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 221" severity error;

        -- Stimulus Vector 222
        a <= "1110";
        b <= "1101";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 222" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 222" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 222" severity error;

        -- Stimulus Vector 223
        a <= "1111";
        b <= "1101";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 223" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 223" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 223" severity error;

        -- Stimulus Vector 224
        a <= "0000";
        b <= "1110";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 224" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 224" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 224" severity error;

        -- Stimulus Vector 225
        a <= "0001";
        b <= "1110";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 225" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 225" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 225" severity error;

        -- Stimulus Vector 226
        a <= "0010";
        b <= "1110";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 226" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 226" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 226" severity error;

        -- Stimulus Vector 227
        a <= "0011";
        b <= "1110";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 227" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 227" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 227" severity error;

        -- Stimulus Vector 228
        a <= "0100";
        b <= "1110";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 228" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 228" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 228" severity error;

        -- Stimulus Vector 229
        a <= "0101";
        b <= "1110";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 229" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 229" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 229" severity error;

        -- Stimulus Vector 230
        a <= "0110";
        b <= "1110";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 230" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 230" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 230" severity error;

        -- Stimulus Vector 231
        a <= "0111";
        b <= "1110";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 231" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 231" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 231" severity error;

        -- Stimulus Vector 232
        a <= "1000";
        b <= "1110";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 232" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 232" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 232" severity error;

        -- Stimulus Vector 233
        a <= "1001";
        b <= "1110";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 233" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 233" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 233" severity error;

        -- Stimulus Vector 234
        a <= "1010";
        b <= "1110";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 234" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 234" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 234" severity error;

        -- Stimulus Vector 235
        a <= "1011";
        b <= "1110";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 235" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 235" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 235" severity error;

        -- Stimulus Vector 236
        a <= "1100";
        b <= "1110";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 236" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 236" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 236" severity error;

        -- Stimulus Vector 237
        a <= "1101";
        b <= "1110";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 237" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 237" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 237" severity error;

        -- Stimulus Vector 238
        a <= "1110";
        b <= "1110";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 238" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 238" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 238" severity error;

        -- Stimulus Vector 239
        a <= "1111";
        b <= "1110";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 239" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 239" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 239" severity error;

        -- Stimulus Vector 240
        a <= "0000";
        b <= "1111";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 240" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 240" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 240" severity error;

        -- Stimulus Vector 241
        a <= "0001";
        b <= "1111";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 241" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 241" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 241" severity error;

        -- Stimulus Vector 242
        a <= "0010";
        b <= "1111";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 242" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 242" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 242" severity error;

        -- Stimulus Vector 243
        a <= "0011";
        b <= "1111";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 243" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 243" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 243" severity error;

        -- Stimulus Vector 244
        a <= "0100";
        b <= "1111";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 244" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 244" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 244" severity error;

        -- Stimulus Vector 245
        a <= "0101";
        b <= "1111";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 245" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 245" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 245" severity error;

        -- Stimulus Vector 246
        a <= "0110";
        b <= "1111";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 246" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 246" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 246" severity error;

        -- Stimulus Vector 247
        a <= "0111";
        b <= "1111";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 247" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 247" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 247" severity error;

        -- Stimulus Vector 248
        a <= "1000";
        b <= "1111";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 248" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 248" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 248" severity error;

        -- Stimulus Vector 249
        a <= "1001";
        b <= "1111";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 249" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 249" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 249" severity error;

        -- Stimulus Vector 250
        a <= "1010";
        b <= "1111";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 250" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 250" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 250" severity error;

        -- Stimulus Vector 251
        a <= "1011";
        b <= "1111";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 251" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 251" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 251" severity error;

        -- Stimulus Vector 252
        a <= "1100";
        b <= "1111";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 252" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 252" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 252" severity error;

        -- Stimulus Vector 253
        a <= "1101";
        b <= "1111";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 253" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 253" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 253" severity error;

        -- Stimulus Vector 254
        a <= "1110";
        b <= "1111";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 254" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 254" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 254" severity error;

        -- Stimulus Vector 255
        a <= "1111";
        b <= "1111";
        cin <= '0';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 255" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 255" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 255" severity error;

        -- Stimulus Vector 256
        a <= "0000";
        b <= "0000";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 256" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 256" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 256" severity error;

        -- Stimulus Vector 257
        a <= "0001";
        b <= "0000";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 257" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 257" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 257" severity error;

        -- Stimulus Vector 258
        a <= "0010";
        b <= "0000";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 258" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 258" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 258" severity error;

        -- Stimulus Vector 259
        a <= "0011";
        b <= "0000";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 259" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 259" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 259" severity error;

        -- Stimulus Vector 260
        a <= "0100";
        b <= "0000";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 260" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 260" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 260" severity error;

        -- Stimulus Vector 261
        a <= "0101";
        b <= "0000";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 261" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 261" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 261" severity error;

        -- Stimulus Vector 262
        a <= "0110";
        b <= "0000";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 262" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 262" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 262" severity error;

        -- Stimulus Vector 263
        a <= "0111";
        b <= "0000";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 263" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 263" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 263" severity error;

        -- Stimulus Vector 264
        a <= "1000";
        b <= "0000";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 264" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 264" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 264" severity error;

        -- Stimulus Vector 265
        a <= "1001";
        b <= "0000";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 265" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 265" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 265" severity error;

        -- Stimulus Vector 266
        a <= "1010";
        b <= "0000";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 266" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 266" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 266" severity error;

        -- Stimulus Vector 267
        a <= "1011";
        b <= "0000";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 267" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 267" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 267" severity error;

        -- Stimulus Vector 268
        a <= "1100";
        b <= "0000";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 268" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 268" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 268" severity error;

        -- Stimulus Vector 269
        a <= "1101";
        b <= "0000";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 269" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 269" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 269" severity error;

        -- Stimulus Vector 270
        a <= "1110";
        b <= "0000";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 270" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 270" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 270" severity error;

        -- Stimulus Vector 271
        a <= "1111";
        b <= "0000";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 271" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 271" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 271" severity error;

        -- Stimulus Vector 272
        a <= "0000";
        b <= "0001";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 272" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 272" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 272" severity error;

        -- Stimulus Vector 273
        a <= "0001";
        b <= "0001";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 273" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 273" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 273" severity error;

        -- Stimulus Vector 274
        a <= "0010";
        b <= "0001";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 274" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 274" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 274" severity error;

        -- Stimulus Vector 275
        a <= "0011";
        b <= "0001";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 275" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 275" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 275" severity error;

        -- Stimulus Vector 276
        a <= "0100";
        b <= "0001";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 276" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 276" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 276" severity error;

        -- Stimulus Vector 277
        a <= "0101";
        b <= "0001";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 277" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 277" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 277" severity error;

        -- Stimulus Vector 278
        a <= "0110";
        b <= "0001";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 278" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 278" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 278" severity error;

        -- Stimulus Vector 279
        a <= "0111";
        b <= "0001";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 279" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 279" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 279" severity error;

        -- Stimulus Vector 280
        a <= "1000";
        b <= "0001";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 280" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 280" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 280" severity error;

        -- Stimulus Vector 281
        a <= "1001";
        b <= "0001";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 281" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 281" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 281" severity error;

        -- Stimulus Vector 282
        a <= "1010";
        b <= "0001";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 282" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 282" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 282" severity error;

        -- Stimulus Vector 283
        a <= "1011";
        b <= "0001";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 283" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 283" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 283" severity error;

        -- Stimulus Vector 284
        a <= "1100";
        b <= "0001";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 284" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 284" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 284" severity error;

        -- Stimulus Vector 285
        a <= "1101";
        b <= "0001";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 285" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 285" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 285" severity error;

        -- Stimulus Vector 286
        a <= "1110";
        b <= "0001";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 286" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 286" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 286" severity error;

        -- Stimulus Vector 287
        a <= "1111";
        b <= "0001";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 287" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 287" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 287" severity error;

        -- Stimulus Vector 288
        a <= "0000";
        b <= "0010";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 288" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 288" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 288" severity error;

        -- Stimulus Vector 289
        a <= "0001";
        b <= "0010";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 289" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 289" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 289" severity error;

        -- Stimulus Vector 290
        a <= "0010";
        b <= "0010";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 290" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 290" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 290" severity error;

        -- Stimulus Vector 291
        a <= "0011";
        b <= "0010";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 291" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 291" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 291" severity error;

        -- Stimulus Vector 292
        a <= "0100";
        b <= "0010";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 292" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 292" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 292" severity error;

        -- Stimulus Vector 293
        a <= "0101";
        b <= "0010";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 293" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 293" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 293" severity error;

        -- Stimulus Vector 294
        a <= "0110";
        b <= "0010";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 294" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 294" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 294" severity error;

        -- Stimulus Vector 295
        a <= "0111";
        b <= "0010";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 295" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 295" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 295" severity error;

        -- Stimulus Vector 296
        a <= "1000";
        b <= "0010";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 296" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 296" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 296" severity error;

        -- Stimulus Vector 297
        a <= "1001";
        b <= "0010";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 297" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 297" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 297" severity error;

        -- Stimulus Vector 298
        a <= "1010";
        b <= "0010";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 298" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 298" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 298" severity error;

        -- Stimulus Vector 299
        a <= "1011";
        b <= "0010";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 299" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 299" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 299" severity error;

        -- Stimulus Vector 300
        a <= "1100";
        b <= "0010";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 300" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 300" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 300" severity error;

        -- Stimulus Vector 301
        a <= "1101";
        b <= "0010";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 301" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 301" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 301" severity error;

        -- Stimulus Vector 302
        a <= "1110";
        b <= "0010";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 302" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 302" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 302" severity error;

        -- Stimulus Vector 303
        a <= "1111";
        b <= "0010";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 303" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 303" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 303" severity error;

        -- Stimulus Vector 304
        a <= "0000";
        b <= "0011";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 304" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 304" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 304" severity error;

        -- Stimulus Vector 305
        a <= "0001";
        b <= "0011";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 305" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 305" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 305" severity error;

        -- Stimulus Vector 306
        a <= "0010";
        b <= "0011";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 306" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 306" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 306" severity error;

        -- Stimulus Vector 307
        a <= "0011";
        b <= "0011";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 307" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 307" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 307" severity error;

        -- Stimulus Vector 308
        a <= "0100";
        b <= "0011";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 308" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 308" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 308" severity error;

        -- Stimulus Vector 309
        a <= "0101";
        b <= "0011";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 309" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 309" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 309" severity error;

        -- Stimulus Vector 310
        a <= "0110";
        b <= "0011";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 310" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 310" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 310" severity error;

        -- Stimulus Vector 311
        a <= "0111";
        b <= "0011";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 311" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 311" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 311" severity error;

        -- Stimulus Vector 312
        a <= "1000";
        b <= "0011";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 312" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 312" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 312" severity error;

        -- Stimulus Vector 313
        a <= "1001";
        b <= "0011";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 313" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 313" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 313" severity error;

        -- Stimulus Vector 314
        a <= "1010";
        b <= "0011";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 314" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 314" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 314" severity error;

        -- Stimulus Vector 315
        a <= "1011";
        b <= "0011";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 315" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 315" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 315" severity error;

        -- Stimulus Vector 316
        a <= "1100";
        b <= "0011";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 316" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 316" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 316" severity error;

        -- Stimulus Vector 317
        a <= "1101";
        b <= "0011";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 317" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 317" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 317" severity error;

        -- Stimulus Vector 318
        a <= "1110";
        b <= "0011";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 318" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 318" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 318" severity error;

        -- Stimulus Vector 319
        a <= "1111";
        b <= "0011";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 319" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 319" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 319" severity error;

        -- Stimulus Vector 320
        a <= "0000";
        b <= "0100";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 320" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 320" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 320" severity error;

        -- Stimulus Vector 321
        a <= "0001";
        b <= "0100";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 321" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 321" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 321" severity error;

        -- Stimulus Vector 322
        a <= "0010";
        b <= "0100";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 322" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 322" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 322" severity error;

        -- Stimulus Vector 323
        a <= "0011";
        b <= "0100";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 323" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 323" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 323" severity error;

        -- Stimulus Vector 324
        a <= "0100";
        b <= "0100";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 324" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 324" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 324" severity error;

        -- Stimulus Vector 325
        a <= "0101";
        b <= "0100";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 325" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 325" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 325" severity error;

        -- Stimulus Vector 326
        a <= "0110";
        b <= "0100";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 326" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 326" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 326" severity error;

        -- Stimulus Vector 327
        a <= "0111";
        b <= "0100";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 327" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 327" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 327" severity error;

        -- Stimulus Vector 328
        a <= "1000";
        b <= "0100";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 328" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 328" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 328" severity error;

        -- Stimulus Vector 329
        a <= "1001";
        b <= "0100";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 329" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 329" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 329" severity error;

        -- Stimulus Vector 330
        a <= "1010";
        b <= "0100";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 330" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 330" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 330" severity error;

        -- Stimulus Vector 331
        a <= "1011";
        b <= "0100";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 331" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 331" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 331" severity error;

        -- Stimulus Vector 332
        a <= "1100";
        b <= "0100";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 332" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 332" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 332" severity error;

        -- Stimulus Vector 333
        a <= "1101";
        b <= "0100";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 333" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 333" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 333" severity error;

        -- Stimulus Vector 334
        a <= "1110";
        b <= "0100";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 334" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 334" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 334" severity error;

        -- Stimulus Vector 335
        a <= "1111";
        b <= "0100";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 335" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 335" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 335" severity error;

        -- Stimulus Vector 336
        a <= "0000";
        b <= "0101";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 336" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 336" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 336" severity error;

        -- Stimulus Vector 337
        a <= "0001";
        b <= "0101";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 337" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 337" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 337" severity error;

        -- Stimulus Vector 338
        a <= "0010";
        b <= "0101";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 338" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 338" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 338" severity error;

        -- Stimulus Vector 339
        a <= "0011";
        b <= "0101";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 339" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 339" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 339" severity error;

        -- Stimulus Vector 340
        a <= "0100";
        b <= "0101";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 340" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 340" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 340" severity error;

        -- Stimulus Vector 341
        a <= "0101";
        b <= "0101";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 341" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 341" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 341" severity error;

        -- Stimulus Vector 342
        a <= "0110";
        b <= "0101";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 342" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 342" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 342" severity error;

        -- Stimulus Vector 343
        a <= "0111";
        b <= "0101";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 343" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 343" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 343" severity error;

        -- Stimulus Vector 344
        a <= "1000";
        b <= "0101";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 344" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 344" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 344" severity error;

        -- Stimulus Vector 345
        a <= "1001";
        b <= "0101";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 345" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 345" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 345" severity error;

        -- Stimulus Vector 346
        a <= "1010";
        b <= "0101";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 346" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 346" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 346" severity error;

        -- Stimulus Vector 347
        a <= "1011";
        b <= "0101";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 347" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 347" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 347" severity error;

        -- Stimulus Vector 348
        a <= "1100";
        b <= "0101";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 348" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 348" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 348" severity error;

        -- Stimulus Vector 349
        a <= "1101";
        b <= "0101";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 349" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 349" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 349" severity error;

        -- Stimulus Vector 350
        a <= "1110";
        b <= "0101";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 350" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 350" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 350" severity error;

        -- Stimulus Vector 351
        a <= "1111";
        b <= "0101";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 351" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 351" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 351" severity error;

        -- Stimulus Vector 352
        a <= "0000";
        b <= "0110";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 352" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 352" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 352" severity error;

        -- Stimulus Vector 353
        a <= "0001";
        b <= "0110";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 353" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 353" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 353" severity error;

        -- Stimulus Vector 354
        a <= "0010";
        b <= "0110";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 354" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 354" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 354" severity error;

        -- Stimulus Vector 355
        a <= "0011";
        b <= "0110";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 355" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 355" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 355" severity error;

        -- Stimulus Vector 356
        a <= "0100";
        b <= "0110";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 356" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 356" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 356" severity error;

        -- Stimulus Vector 357
        a <= "0101";
        b <= "0110";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 357" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 357" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 357" severity error;

        -- Stimulus Vector 358
        a <= "0110";
        b <= "0110";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 358" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 358" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 358" severity error;

        -- Stimulus Vector 359
        a <= "0111";
        b <= "0110";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 359" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 359" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 359" severity error;

        -- Stimulus Vector 360
        a <= "1000";
        b <= "0110";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 360" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 360" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 360" severity error;

        -- Stimulus Vector 361
        a <= "1001";
        b <= "0110";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 361" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 361" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 361" severity error;

        -- Stimulus Vector 362
        a <= "1010";
        b <= "0110";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 362" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 362" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 362" severity error;

        -- Stimulus Vector 363
        a <= "1011";
        b <= "0110";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 363" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 363" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 363" severity error;

        -- Stimulus Vector 364
        a <= "1100";
        b <= "0110";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 364" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 364" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 364" severity error;

        -- Stimulus Vector 365
        a <= "1101";
        b <= "0110";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 365" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 365" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 365" severity error;

        -- Stimulus Vector 366
        a <= "1110";
        b <= "0110";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 366" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 366" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 366" severity error;

        -- Stimulus Vector 367
        a <= "1111";
        b <= "0110";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 367" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 367" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 367" severity error;

        -- Stimulus Vector 368
        a <= "0000";
        b <= "0111";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 368" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 368" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 368" severity error;

        -- Stimulus Vector 369
        a <= "0001";
        b <= "0111";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 369" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 369" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 369" severity error;

        -- Stimulus Vector 370
        a <= "0010";
        b <= "0111";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 370" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 370" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 370" severity error;

        -- Stimulus Vector 371
        a <= "0011";
        b <= "0111";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 371" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 371" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 371" severity error;

        -- Stimulus Vector 372
        a <= "0100";
        b <= "0111";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 372" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 372" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 372" severity error;

        -- Stimulus Vector 373
        a <= "0101";
        b <= "0111";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 373" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 373" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 373" severity error;

        -- Stimulus Vector 374
        a <= "0110";
        b <= "0111";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 374" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 374" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 374" severity error;

        -- Stimulus Vector 375
        a <= "0111";
        b <= "0111";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 375" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 375" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 375" severity error;

        -- Stimulus Vector 376
        a <= "1000";
        b <= "0111";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 376" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 376" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 376" severity error;

        -- Stimulus Vector 377
        a <= "1001";
        b <= "0111";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 377" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 377" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 377" severity error;

        -- Stimulus Vector 378
        a <= "1010";
        b <= "0111";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 378" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 378" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 378" severity error;

        -- Stimulus Vector 379
        a <= "1011";
        b <= "0111";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 379" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 379" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 379" severity error;

        -- Stimulus Vector 380
        a <= "1100";
        b <= "0111";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 380" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 380" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 380" severity error;

        -- Stimulus Vector 381
        a <= "1101";
        b <= "0111";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 381" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 381" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 381" severity error;

        -- Stimulus Vector 382
        a <= "1110";
        b <= "0111";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 382" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 382" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 382" severity error;

        -- Stimulus Vector 383
        a <= "1111";
        b <= "0111";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 383" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 383" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 383" severity error;

        -- Stimulus Vector 384
        a <= "0000";
        b <= "1000";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 384" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 384" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 384" severity error;

        -- Stimulus Vector 385
        a <= "0001";
        b <= "1000";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 385" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 385" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 385" severity error;

        -- Stimulus Vector 386
        a <= "0010";
        b <= "1000";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 386" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 386" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 386" severity error;

        -- Stimulus Vector 387
        a <= "0011";
        b <= "1000";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 387" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 387" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 387" severity error;

        -- Stimulus Vector 388
        a <= "0100";
        b <= "1000";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 388" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 388" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 388" severity error;

        -- Stimulus Vector 389
        a <= "0101";
        b <= "1000";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 389" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 389" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 389" severity error;

        -- Stimulus Vector 390
        a <= "0110";
        b <= "1000";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 390" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 390" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 390" severity error;

        -- Stimulus Vector 391
        a <= "0111";
        b <= "1000";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 391" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 391" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 391" severity error;

        -- Stimulus Vector 392
        a <= "1000";
        b <= "1000";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 392" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 392" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 392" severity error;

        -- Stimulus Vector 393
        a <= "1001";
        b <= "1000";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 393" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 393" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 393" severity error;

        -- Stimulus Vector 394
        a <= "1010";
        b <= "1000";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 394" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 394" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 394" severity error;

        -- Stimulus Vector 395
        a <= "1011";
        b <= "1000";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 395" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 395" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 395" severity error;

        -- Stimulus Vector 396
        a <= "1100";
        b <= "1000";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 396" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 396" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 396" severity error;

        -- Stimulus Vector 397
        a <= "1101";
        b <= "1000";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 397" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 397" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 397" severity error;

        -- Stimulus Vector 398
        a <= "1110";
        b <= "1000";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 398" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 398" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 398" severity error;

        -- Stimulus Vector 399
        a <= "1111";
        b <= "1000";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 399" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 399" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 399" severity error;

        -- Stimulus Vector 400
        a <= "0000";
        b <= "1001";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 400" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 400" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 400" severity error;

        -- Stimulus Vector 401
        a <= "0001";
        b <= "1001";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 401" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 401" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 401" severity error;

        -- Stimulus Vector 402
        a <= "0010";
        b <= "1001";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 402" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 402" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 402" severity error;

        -- Stimulus Vector 403
        a <= "0011";
        b <= "1001";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 403" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 403" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 403" severity error;

        -- Stimulus Vector 404
        a <= "0100";
        b <= "1001";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 404" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 404" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 404" severity error;

        -- Stimulus Vector 405
        a <= "0101";
        b <= "1001";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 405" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 405" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 405" severity error;

        -- Stimulus Vector 406
        a <= "0110";
        b <= "1001";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 406" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 406" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 406" severity error;

        -- Stimulus Vector 407
        a <= "0111";
        b <= "1001";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 407" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 407" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 407" severity error;

        -- Stimulus Vector 408
        a <= "1000";
        b <= "1001";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 408" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 408" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 408" severity error;

        -- Stimulus Vector 409
        a <= "1001";
        b <= "1001";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 409" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 409" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 409" severity error;

        -- Stimulus Vector 410
        a <= "1010";
        b <= "1001";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 410" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 410" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 410" severity error;

        -- Stimulus Vector 411
        a <= "1011";
        b <= "1001";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 411" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 411" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 411" severity error;

        -- Stimulus Vector 412
        a <= "1100";
        b <= "1001";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 412" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 412" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 412" severity error;

        -- Stimulus Vector 413
        a <= "1101";
        b <= "1001";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 413" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 413" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 413" severity error;

        -- Stimulus Vector 414
        a <= "1110";
        b <= "1001";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 414" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 414" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 414" severity error;

        -- Stimulus Vector 415
        a <= "1111";
        b <= "1001";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 415" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 415" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 415" severity error;

        -- Stimulus Vector 416
        a <= "0000";
        b <= "1010";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 416" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 416" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 416" severity error;

        -- Stimulus Vector 417
        a <= "0001";
        b <= "1010";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 417" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 417" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 417" severity error;

        -- Stimulus Vector 418
        a <= "0010";
        b <= "1010";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 418" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 418" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 418" severity error;

        -- Stimulus Vector 419
        a <= "0011";
        b <= "1010";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 419" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 419" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 419" severity error;

        -- Stimulus Vector 420
        a <= "0100";
        b <= "1010";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 420" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 420" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 420" severity error;

        -- Stimulus Vector 421
        a <= "0101";
        b <= "1010";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 421" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 421" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 421" severity error;

        -- Stimulus Vector 422
        a <= "0110";
        b <= "1010";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 422" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 422" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 422" severity error;

        -- Stimulus Vector 423
        a <= "0111";
        b <= "1010";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 423" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 423" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 423" severity error;

        -- Stimulus Vector 424
        a <= "1000";
        b <= "1010";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 424" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 424" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 424" severity error;

        -- Stimulus Vector 425
        a <= "1001";
        b <= "1010";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 425" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 425" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 425" severity error;

        -- Stimulus Vector 426
        a <= "1010";
        b <= "1010";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 426" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 426" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 426" severity error;

        -- Stimulus Vector 427
        a <= "1011";
        b <= "1010";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 427" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 427" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 427" severity error;

        -- Stimulus Vector 428
        a <= "1100";
        b <= "1010";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 428" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 428" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 428" severity error;

        -- Stimulus Vector 429
        a <= "1101";
        b <= "1010";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 429" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 429" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 429" severity error;

        -- Stimulus Vector 430
        a <= "1110";
        b <= "1010";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 430" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 430" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 430" severity error;

        -- Stimulus Vector 431
        a <= "1111";
        b <= "1010";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 431" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 431" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 431" severity error;

        -- Stimulus Vector 432
        a <= "0000";
        b <= "1011";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 432" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 432" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 432" severity error;

        -- Stimulus Vector 433
        a <= "0001";
        b <= "1011";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 433" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 433" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 433" severity error;

        -- Stimulus Vector 434
        a <= "0010";
        b <= "1011";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 434" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 434" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 434" severity error;

        -- Stimulus Vector 435
        a <= "0011";
        b <= "1011";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 435" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 435" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 435" severity error;

        -- Stimulus Vector 436
        a <= "0100";
        b <= "1011";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 436" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 436" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 436" severity error;

        -- Stimulus Vector 437
        a <= "0101";
        b <= "1011";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 437" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 437" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 437" severity error;

        -- Stimulus Vector 438
        a <= "0110";
        b <= "1011";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 438" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 438" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 438" severity error;

        -- Stimulus Vector 439
        a <= "0111";
        b <= "1011";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 439" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 439" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 439" severity error;

        -- Stimulus Vector 440
        a <= "1000";
        b <= "1011";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 440" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 440" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 440" severity error;

        -- Stimulus Vector 441
        a <= "1001";
        b <= "1011";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 441" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 441" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 441" severity error;

        -- Stimulus Vector 442
        a <= "1010";
        b <= "1011";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 442" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 442" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 442" severity error;

        -- Stimulus Vector 443
        a <= "1011";
        b <= "1011";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 443" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 443" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 443" severity error;

        -- Stimulus Vector 444
        a <= "1100";
        b <= "1011";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 444" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 444" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 444" severity error;

        -- Stimulus Vector 445
        a <= "1101";
        b <= "1011";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 445" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 445" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 445" severity error;

        -- Stimulus Vector 446
        a <= "1110";
        b <= "1011";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 446" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 446" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 446" severity error;

        -- Stimulus Vector 447
        a <= "1111";
        b <= "1011";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 447" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 447" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 447" severity error;

        -- Stimulus Vector 448
        a <= "0000";
        b <= "1100";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 448" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 448" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 448" severity error;

        -- Stimulus Vector 449
        a <= "0001";
        b <= "1100";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 449" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 449" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 449" severity error;

        -- Stimulus Vector 450
        a <= "0010";
        b <= "1100";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 450" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 450" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 450" severity error;

        -- Stimulus Vector 451
        a <= "0011";
        b <= "1100";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 451" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 451" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 451" severity error;

        -- Stimulus Vector 452
        a <= "0100";
        b <= "1100";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 452" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 452" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 452" severity error;

        -- Stimulus Vector 453
        a <= "0101";
        b <= "1100";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 453" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 453" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 453" severity error;

        -- Stimulus Vector 454
        a <= "0110";
        b <= "1100";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 454" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 454" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 454" severity error;

        -- Stimulus Vector 455
        a <= "0111";
        b <= "1100";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 455" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 455" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 455" severity error;

        -- Stimulus Vector 456
        a <= "1000";
        b <= "1100";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 456" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 456" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 456" severity error;

        -- Stimulus Vector 457
        a <= "1001";
        b <= "1100";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 457" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 457" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 457" severity error;

        -- Stimulus Vector 458
        a <= "1010";
        b <= "1100";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 458" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 458" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 458" severity error;

        -- Stimulus Vector 459
        a <= "1011";
        b <= "1100";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 459" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 459" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 459" severity error;

        -- Stimulus Vector 460
        a <= "1100";
        b <= "1100";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 460" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 460" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 460" severity error;

        -- Stimulus Vector 461
        a <= "1101";
        b <= "1100";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 461" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 461" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 461" severity error;

        -- Stimulus Vector 462
        a <= "1110";
        b <= "1100";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 462" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 462" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 462" severity error;

        -- Stimulus Vector 463
        a <= "1111";
        b <= "1100";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 463" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 463" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 463" severity error;

        -- Stimulus Vector 464
        a <= "0000";
        b <= "1101";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 464" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 464" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 464" severity error;

        -- Stimulus Vector 465
        a <= "0001";
        b <= "1101";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 465" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 465" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 465" severity error;

        -- Stimulus Vector 466
        a <= "0010";
        b <= "1101";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 466" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 466" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 466" severity error;

        -- Stimulus Vector 467
        a <= "0011";
        b <= "1101";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 467" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 467" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 467" severity error;

        -- Stimulus Vector 468
        a <= "0100";
        b <= "1101";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 468" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 468" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 468" severity error;

        -- Stimulus Vector 469
        a <= "0101";
        b <= "1101";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 469" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 469" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 469" severity error;

        -- Stimulus Vector 470
        a <= "0110";
        b <= "1101";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 470" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 470" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 470" severity error;

        -- Stimulus Vector 471
        a <= "0111";
        b <= "1101";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 471" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 471" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 471" severity error;

        -- Stimulus Vector 472
        a <= "1000";
        b <= "1101";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 472" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 472" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 472" severity error;

        -- Stimulus Vector 473
        a <= "1001";
        b <= "1101";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 473" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 473" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 473" severity error;

        -- Stimulus Vector 474
        a <= "1010";
        b <= "1101";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 474" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 474" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 474" severity error;

        -- Stimulus Vector 475
        a <= "1011";
        b <= "1101";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 475" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 475" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 475" severity error;

        -- Stimulus Vector 476
        a <= "1100";
        b <= "1101";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 476" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 476" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 476" severity error;

        -- Stimulus Vector 477
        a <= "1101";
        b <= "1101";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 477" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 477" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 477" severity error;

        -- Stimulus Vector 478
        a <= "1110";
        b <= "1101";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 478" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 478" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 478" severity error;

        -- Stimulus Vector 479
        a <= "1111";
        b <= "1101";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 479" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 479" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 479" severity error;

        -- Stimulus Vector 480
        a <= "0000";
        b <= "1110";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 480" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 480" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 480" severity error;

        -- Stimulus Vector 481
        a <= "0001";
        b <= "1110";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 481" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 481" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 481" severity error;

        -- Stimulus Vector 482
        a <= "0010";
        b <= "1110";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 482" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 482" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 482" severity error;

        -- Stimulus Vector 483
        a <= "0011";
        b <= "1110";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 483" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 483" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 483" severity error;

        -- Stimulus Vector 484
        a <= "0100";
        b <= "1110";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 484" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 484" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 484" severity error;

        -- Stimulus Vector 485
        a <= "0101";
        b <= "1110";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 485" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 485" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 485" severity error;

        -- Stimulus Vector 486
        a <= "0110";
        b <= "1110";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 486" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 486" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 486" severity error;

        -- Stimulus Vector 487
        a <= "0111";
        b <= "1110";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 487" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 487" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 487" severity error;

        -- Stimulus Vector 488
        a <= "1000";
        b <= "1110";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 488" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 488" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 488" severity error;

        -- Stimulus Vector 489
        a <= "1001";
        b <= "1110";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 489" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 489" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 489" severity error;

        -- Stimulus Vector 490
        a <= "1010";
        b <= "1110";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 490" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 490" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 490" severity error;

        -- Stimulus Vector 491
        a <= "1011";
        b <= "1110";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 491" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 491" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 491" severity error;

        -- Stimulus Vector 492
        a <= "1100";
        b <= "1110";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 492" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 492" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 492" severity error;

        -- Stimulus Vector 493
        a <= "1101";
        b <= "1110";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 493" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 493" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 493" severity error;

        -- Stimulus Vector 494
        a <= "1110";
        b <= "1110";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 494" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 494" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 494" severity error;

        -- Stimulus Vector 495
        a <= "1111";
        b <= "1110";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 495" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 495" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 495" severity error;

        -- Stimulus Vector 496
        a <= "0000";
        b <= "1111";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 496" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 496" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 496" severity error;

        -- Stimulus Vector 497
        a <= "0001";
        b <= "1111";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 497" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 497" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 497" severity error;

        -- Stimulus Vector 498
        a <= "0010";
        b <= "1111";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 498" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 498" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 498" severity error;

        -- Stimulus Vector 499
        a <= "0011";
        b <= "1111";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 499" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 499" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 499" severity error;

        -- Stimulus Vector 500
        a <= "0100";
        b <= "1111";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 500" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 500" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 500" severity error;

        -- Stimulus Vector 501
        a <= "0101";
        b <= "1111";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 501" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 501" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 501" severity error;

        -- Stimulus Vector 502
        a <= "0110";
        b <= "1111";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 502" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 502" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 502" severity error;

        -- Stimulus Vector 503
        a <= "0111";
        b <= "1111";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 503" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 503" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 503" severity error;

        -- Stimulus Vector 504
        a <= "1000";
        b <= "1111";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 504" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 504" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 504" severity error;

        -- Stimulus Vector 505
        a <= "1001";
        b <= "1111";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 505" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 505" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 505" severity error;

        -- Stimulus Vector 506
        a <= "1010";
        b <= "1111";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 506" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 506" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 506" severity error;

        -- Stimulus Vector 507
        a <= "1011";
        b <= "1111";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 507" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 507" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 507" severity error;

        -- Stimulus Vector 508
        a <= "1100";
        b <= "1111";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 508" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 508" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 508" severity error;

        -- Stimulus Vector 509
        a <= "1101";
        b <= "1111";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 509" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 509" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 509" severity error;

        -- Stimulus Vector 510
        a <= "1110";
        b <= "1111";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 510" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 510" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 510" severity error;

        -- Stimulus Vector 511
        a <= "1111";
        b <= "1111";
        cin <= '1';
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct') for vector 511" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct') for vector 511" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct') for vector 511" severity error;

        wait;
    end process;
end architecture;
-- ========================================================

