library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity tb_ripple_adder_top_equiv is
end entity tb_ripple_adder_top_equiv;

architecture behavioral of tb_ripple_adder_top_equiv is
    signal in1 : std_logic_vector (7 downto 0);
    signal in2 : std_logic_vector (7 downto 0);
    signal c_in : std_logic;
    signal res_struct : std_logic_vector (7 downto 0);
    signal res_struct_flat : std_logic_vector (7 downto 0);
    signal c_out_struct : std_logic;
    signal c_out_struct_flat : std_logic;

begin
    U_STRUCT: entity work.ripple_adder_top(struct)
        port map (
        in1 => in1,
        in2 => in2,
        c_in => c_in,
        res => res_struct,
        c_out => c_out_struct
        );

    U_STRUCT_FLAT: entity work.ripple_adder_top_flat(struct)
        port map (
        in1 => in1,
        in2 => in2,
        c_in => c_in,
        res => res_struct_flat,
        c_out => c_out_struct_flat
        );

    STIMULUS_PROC: process
    begin
        -- Stimulus Vector 0
        in1 <= "00000000";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 0" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 0" severity error;

        -- Stimulus Vector 1
        in1 <= "00000001";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 1" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 1" severity error;

        -- Stimulus Vector 2
        in1 <= "00000010";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 2" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 2" severity error;

        -- Stimulus Vector 3
        in1 <= "00000011";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 3" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 3" severity error;

        -- Stimulus Vector 4
        in1 <= "00000100";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 4" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 4" severity error;

        -- Stimulus Vector 5
        in1 <= "00000101";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 5" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 5" severity error;

        -- Stimulus Vector 6
        in1 <= "00000110";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 6" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 6" severity error;

        -- Stimulus Vector 7
        in1 <= "00000111";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 7" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 7" severity error;

        -- Stimulus Vector 8
        in1 <= "00001000";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 8" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 8" severity error;

        -- Stimulus Vector 9
        in1 <= "00001001";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 9" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 9" severity error;

        -- Stimulus Vector 10
        in1 <= "00001010";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 10" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 10" severity error;

        -- Stimulus Vector 11
        in1 <= "00001011";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 11" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 11" severity error;

        -- Stimulus Vector 12
        in1 <= "00001100";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 12" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 12" severity error;

        -- Stimulus Vector 13
        in1 <= "00001101";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 13" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 13" severity error;

        -- Stimulus Vector 14
        in1 <= "00001110";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 14" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 14" severity error;

        -- Stimulus Vector 15
        in1 <= "00001111";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 15" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 15" severity error;

        -- Stimulus Vector 16
        in1 <= "00010000";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 16" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 16" severity error;

        -- Stimulus Vector 17
        in1 <= "00010001";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 17" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 17" severity error;

        -- Stimulus Vector 18
        in1 <= "00010010";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 18" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 18" severity error;

        -- Stimulus Vector 19
        in1 <= "00010011";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 19" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 19" severity error;

        -- Stimulus Vector 20
        in1 <= "00010100";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 20" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 20" severity error;

        -- Stimulus Vector 21
        in1 <= "00010101";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 21" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 21" severity error;

        -- Stimulus Vector 22
        in1 <= "00010110";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 22" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 22" severity error;

        -- Stimulus Vector 23
        in1 <= "00010111";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 23" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 23" severity error;

        -- Stimulus Vector 24
        in1 <= "00011000";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 24" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 24" severity error;

        -- Stimulus Vector 25
        in1 <= "00011001";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 25" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 25" severity error;

        -- Stimulus Vector 26
        in1 <= "00011010";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 26" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 26" severity error;

        -- Stimulus Vector 27
        in1 <= "00011011";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 27" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 27" severity error;

        -- Stimulus Vector 28
        in1 <= "00011100";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 28" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 28" severity error;

        -- Stimulus Vector 29
        in1 <= "00011101";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 29" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 29" severity error;

        -- Stimulus Vector 30
        in1 <= "00011110";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 30" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 30" severity error;

        -- Stimulus Vector 31
        in1 <= "00011111";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 31" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 31" severity error;

        -- Stimulus Vector 32
        in1 <= "00100000";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 32" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 32" severity error;

        -- Stimulus Vector 33
        in1 <= "00100001";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 33" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 33" severity error;

        -- Stimulus Vector 34
        in1 <= "00100010";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 34" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 34" severity error;

        -- Stimulus Vector 35
        in1 <= "00100011";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 35" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 35" severity error;

        -- Stimulus Vector 36
        in1 <= "00100100";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 36" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 36" severity error;

        -- Stimulus Vector 37
        in1 <= "00100101";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 37" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 37" severity error;

        -- Stimulus Vector 38
        in1 <= "00100110";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 38" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 38" severity error;

        -- Stimulus Vector 39
        in1 <= "00100111";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 39" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 39" severity error;

        -- Stimulus Vector 40
        in1 <= "00101000";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 40" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 40" severity error;

        -- Stimulus Vector 41
        in1 <= "00101001";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 41" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 41" severity error;

        -- Stimulus Vector 42
        in1 <= "00101010";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 42" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 42" severity error;

        -- Stimulus Vector 43
        in1 <= "00101011";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 43" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 43" severity error;

        -- Stimulus Vector 44
        in1 <= "00101100";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 44" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 44" severity error;

        -- Stimulus Vector 45
        in1 <= "00101101";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 45" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 45" severity error;

        -- Stimulus Vector 46
        in1 <= "00101110";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 46" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 46" severity error;

        -- Stimulus Vector 47
        in1 <= "00101111";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 47" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 47" severity error;

        -- Stimulus Vector 48
        in1 <= "00110000";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 48" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 48" severity error;

        -- Stimulus Vector 49
        in1 <= "00110001";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 49" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 49" severity error;

        -- Stimulus Vector 50
        in1 <= "00110010";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 50" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 50" severity error;

        -- Stimulus Vector 51
        in1 <= "00110011";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 51" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 51" severity error;

        -- Stimulus Vector 52
        in1 <= "00110100";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 52" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 52" severity error;

        -- Stimulus Vector 53
        in1 <= "00110101";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 53" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 53" severity error;

        -- Stimulus Vector 54
        in1 <= "00110110";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 54" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 54" severity error;

        -- Stimulus Vector 55
        in1 <= "00110111";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 55" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 55" severity error;

        -- Stimulus Vector 56
        in1 <= "00111000";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 56" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 56" severity error;

        -- Stimulus Vector 57
        in1 <= "00111001";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 57" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 57" severity error;

        -- Stimulus Vector 58
        in1 <= "00111010";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 58" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 58" severity error;

        -- Stimulus Vector 59
        in1 <= "00111011";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 59" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 59" severity error;

        -- Stimulus Vector 60
        in1 <= "00111100";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 60" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 60" severity error;

        -- Stimulus Vector 61
        in1 <= "00111101";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 61" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 61" severity error;

        -- Stimulus Vector 62
        in1 <= "00111110";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 62" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 62" severity error;

        -- Stimulus Vector 63
        in1 <= "00111111";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 63" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 63" severity error;

        -- Stimulus Vector 64
        in1 <= "01000000";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 64" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 64" severity error;

        -- Stimulus Vector 65
        in1 <= "01000001";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 65" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 65" severity error;

        -- Stimulus Vector 66
        in1 <= "01000010";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 66" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 66" severity error;

        -- Stimulus Vector 67
        in1 <= "01000011";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 67" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 67" severity error;

        -- Stimulus Vector 68
        in1 <= "01000100";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 68" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 68" severity error;

        -- Stimulus Vector 69
        in1 <= "01000101";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 69" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 69" severity error;

        -- Stimulus Vector 70
        in1 <= "01000110";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 70" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 70" severity error;

        -- Stimulus Vector 71
        in1 <= "01000111";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 71" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 71" severity error;

        -- Stimulus Vector 72
        in1 <= "01001000";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 72" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 72" severity error;

        -- Stimulus Vector 73
        in1 <= "01001001";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 73" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 73" severity error;

        -- Stimulus Vector 74
        in1 <= "01001010";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 74" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 74" severity error;

        -- Stimulus Vector 75
        in1 <= "01001011";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 75" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 75" severity error;

        -- Stimulus Vector 76
        in1 <= "01001100";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 76" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 76" severity error;

        -- Stimulus Vector 77
        in1 <= "01001101";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 77" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 77" severity error;

        -- Stimulus Vector 78
        in1 <= "01001110";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 78" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 78" severity error;

        -- Stimulus Vector 79
        in1 <= "01001111";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 79" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 79" severity error;

        -- Stimulus Vector 80
        in1 <= "01010000";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 80" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 80" severity error;

        -- Stimulus Vector 81
        in1 <= "01010001";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 81" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 81" severity error;

        -- Stimulus Vector 82
        in1 <= "01010010";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 82" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 82" severity error;

        -- Stimulus Vector 83
        in1 <= "01010011";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 83" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 83" severity error;

        -- Stimulus Vector 84
        in1 <= "01010100";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 84" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 84" severity error;

        -- Stimulus Vector 85
        in1 <= "01010101";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 85" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 85" severity error;

        -- Stimulus Vector 86
        in1 <= "01010110";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 86" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 86" severity error;

        -- Stimulus Vector 87
        in1 <= "01010111";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 87" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 87" severity error;

        -- Stimulus Vector 88
        in1 <= "01011000";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 88" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 88" severity error;

        -- Stimulus Vector 89
        in1 <= "01011001";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 89" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 89" severity error;

        -- Stimulus Vector 90
        in1 <= "01011010";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 90" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 90" severity error;

        -- Stimulus Vector 91
        in1 <= "01011011";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 91" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 91" severity error;

        -- Stimulus Vector 92
        in1 <= "01011100";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 92" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 92" severity error;

        -- Stimulus Vector 93
        in1 <= "01011101";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 93" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 93" severity error;

        -- Stimulus Vector 94
        in1 <= "01011110";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 94" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 94" severity error;

        -- Stimulus Vector 95
        in1 <= "01011111";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 95" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 95" severity error;

        -- Stimulus Vector 96
        in1 <= "01100000";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 96" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 96" severity error;

        -- Stimulus Vector 97
        in1 <= "01100001";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 97" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 97" severity error;

        -- Stimulus Vector 98
        in1 <= "01100010";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 98" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 98" severity error;

        -- Stimulus Vector 99
        in1 <= "01100011";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 99" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 99" severity error;

        -- Stimulus Vector 100
        in1 <= "01100100";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 100" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 100" severity error;

        -- Stimulus Vector 101
        in1 <= "01100101";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 101" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 101" severity error;

        -- Stimulus Vector 102
        in1 <= "01100110";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 102" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 102" severity error;

        -- Stimulus Vector 103
        in1 <= "01100111";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 103" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 103" severity error;

        -- Stimulus Vector 104
        in1 <= "01101000";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 104" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 104" severity error;

        -- Stimulus Vector 105
        in1 <= "01101001";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 105" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 105" severity error;

        -- Stimulus Vector 106
        in1 <= "01101010";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 106" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 106" severity error;

        -- Stimulus Vector 107
        in1 <= "01101011";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 107" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 107" severity error;

        -- Stimulus Vector 108
        in1 <= "01101100";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 108" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 108" severity error;

        -- Stimulus Vector 109
        in1 <= "01101101";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 109" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 109" severity error;

        -- Stimulus Vector 110
        in1 <= "01101110";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 110" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 110" severity error;

        -- Stimulus Vector 111
        in1 <= "01101111";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 111" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 111" severity error;

        -- Stimulus Vector 112
        in1 <= "01110000";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 112" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 112" severity error;

        -- Stimulus Vector 113
        in1 <= "01110001";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 113" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 113" severity error;

        -- Stimulus Vector 114
        in1 <= "01110010";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 114" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 114" severity error;

        -- Stimulus Vector 115
        in1 <= "01110011";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 115" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 115" severity error;

        -- Stimulus Vector 116
        in1 <= "01110100";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 116" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 116" severity error;

        -- Stimulus Vector 117
        in1 <= "01110101";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 117" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 117" severity error;

        -- Stimulus Vector 118
        in1 <= "01110110";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 118" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 118" severity error;

        -- Stimulus Vector 119
        in1 <= "01110111";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 119" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 119" severity error;

        -- Stimulus Vector 120
        in1 <= "01111000";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 120" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 120" severity error;

        -- Stimulus Vector 121
        in1 <= "01111001";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 121" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 121" severity error;

        -- Stimulus Vector 122
        in1 <= "01111010";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 122" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 122" severity error;

        -- Stimulus Vector 123
        in1 <= "01111011";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 123" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 123" severity error;

        -- Stimulus Vector 124
        in1 <= "01111100";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 124" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 124" severity error;

        -- Stimulus Vector 125
        in1 <= "01111101";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 125" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 125" severity error;

        -- Stimulus Vector 126
        in1 <= "01111110";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 126" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 126" severity error;

        -- Stimulus Vector 127
        in1 <= "01111111";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 127" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 127" severity error;

        -- Stimulus Vector 128
        in1 <= "10000000";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 128" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 128" severity error;

        -- Stimulus Vector 129
        in1 <= "10000001";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 129" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 129" severity error;

        -- Stimulus Vector 130
        in1 <= "10000010";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 130" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 130" severity error;

        -- Stimulus Vector 131
        in1 <= "10000011";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 131" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 131" severity error;

        -- Stimulus Vector 132
        in1 <= "10000100";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 132" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 132" severity error;

        -- Stimulus Vector 133
        in1 <= "10000101";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 133" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 133" severity error;

        -- Stimulus Vector 134
        in1 <= "10000110";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 134" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 134" severity error;

        -- Stimulus Vector 135
        in1 <= "10000111";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 135" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 135" severity error;

        -- Stimulus Vector 136
        in1 <= "10001000";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 136" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 136" severity error;

        -- Stimulus Vector 137
        in1 <= "10001001";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 137" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 137" severity error;

        -- Stimulus Vector 138
        in1 <= "10001010";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 138" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 138" severity error;

        -- Stimulus Vector 139
        in1 <= "10001011";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 139" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 139" severity error;

        -- Stimulus Vector 140
        in1 <= "10001100";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 140" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 140" severity error;

        -- Stimulus Vector 141
        in1 <= "10001101";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 141" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 141" severity error;

        -- Stimulus Vector 142
        in1 <= "10001110";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 142" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 142" severity error;

        -- Stimulus Vector 143
        in1 <= "10001111";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 143" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 143" severity error;

        -- Stimulus Vector 144
        in1 <= "10010000";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 144" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 144" severity error;

        -- Stimulus Vector 145
        in1 <= "10010001";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 145" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 145" severity error;

        -- Stimulus Vector 146
        in1 <= "10010010";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 146" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 146" severity error;

        -- Stimulus Vector 147
        in1 <= "10010011";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 147" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 147" severity error;

        -- Stimulus Vector 148
        in1 <= "10010100";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 148" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 148" severity error;

        -- Stimulus Vector 149
        in1 <= "10010101";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 149" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 149" severity error;

        -- Stimulus Vector 150
        in1 <= "10010110";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 150" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 150" severity error;

        -- Stimulus Vector 151
        in1 <= "10010111";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 151" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 151" severity error;

        -- Stimulus Vector 152
        in1 <= "10011000";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 152" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 152" severity error;

        -- Stimulus Vector 153
        in1 <= "10011001";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 153" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 153" severity error;

        -- Stimulus Vector 154
        in1 <= "10011010";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 154" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 154" severity error;

        -- Stimulus Vector 155
        in1 <= "10011011";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 155" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 155" severity error;

        -- Stimulus Vector 156
        in1 <= "10011100";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 156" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 156" severity error;

        -- Stimulus Vector 157
        in1 <= "10011101";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 157" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 157" severity error;

        -- Stimulus Vector 158
        in1 <= "10011110";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 158" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 158" severity error;

        -- Stimulus Vector 159
        in1 <= "10011111";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 159" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 159" severity error;

        -- Stimulus Vector 160
        in1 <= "10100000";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 160" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 160" severity error;

        -- Stimulus Vector 161
        in1 <= "10100001";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 161" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 161" severity error;

        -- Stimulus Vector 162
        in1 <= "10100010";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 162" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 162" severity error;

        -- Stimulus Vector 163
        in1 <= "10100011";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 163" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 163" severity error;

        -- Stimulus Vector 164
        in1 <= "10100100";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 164" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 164" severity error;

        -- Stimulus Vector 165
        in1 <= "10100101";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 165" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 165" severity error;

        -- Stimulus Vector 166
        in1 <= "10100110";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 166" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 166" severity error;

        -- Stimulus Vector 167
        in1 <= "10100111";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 167" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 167" severity error;

        -- Stimulus Vector 168
        in1 <= "10101000";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 168" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 168" severity error;

        -- Stimulus Vector 169
        in1 <= "10101001";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 169" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 169" severity error;

        -- Stimulus Vector 170
        in1 <= "10101010";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 170" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 170" severity error;

        -- Stimulus Vector 171
        in1 <= "10101011";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 171" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 171" severity error;

        -- Stimulus Vector 172
        in1 <= "10101100";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 172" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 172" severity error;

        -- Stimulus Vector 173
        in1 <= "10101101";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 173" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 173" severity error;

        -- Stimulus Vector 174
        in1 <= "10101110";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 174" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 174" severity error;

        -- Stimulus Vector 175
        in1 <= "10101111";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 175" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 175" severity error;

        -- Stimulus Vector 176
        in1 <= "10110000";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 176" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 176" severity error;

        -- Stimulus Vector 177
        in1 <= "10110001";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 177" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 177" severity error;

        -- Stimulus Vector 178
        in1 <= "10110010";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 178" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 178" severity error;

        -- Stimulus Vector 179
        in1 <= "10110011";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 179" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 179" severity error;

        -- Stimulus Vector 180
        in1 <= "10110100";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 180" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 180" severity error;

        -- Stimulus Vector 181
        in1 <= "10110101";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 181" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 181" severity error;

        -- Stimulus Vector 182
        in1 <= "10110110";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 182" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 182" severity error;

        -- Stimulus Vector 183
        in1 <= "10110111";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 183" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 183" severity error;

        -- Stimulus Vector 184
        in1 <= "10111000";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 184" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 184" severity error;

        -- Stimulus Vector 185
        in1 <= "10111001";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 185" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 185" severity error;

        -- Stimulus Vector 186
        in1 <= "10111010";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 186" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 186" severity error;

        -- Stimulus Vector 187
        in1 <= "10111011";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 187" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 187" severity error;

        -- Stimulus Vector 188
        in1 <= "10111100";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 188" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 188" severity error;

        -- Stimulus Vector 189
        in1 <= "10111101";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 189" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 189" severity error;

        -- Stimulus Vector 190
        in1 <= "10111110";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 190" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 190" severity error;

        -- Stimulus Vector 191
        in1 <= "10111111";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 191" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 191" severity error;

        -- Stimulus Vector 192
        in1 <= "11000000";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 192" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 192" severity error;

        -- Stimulus Vector 193
        in1 <= "11000001";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 193" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 193" severity error;

        -- Stimulus Vector 194
        in1 <= "11000010";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 194" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 194" severity error;

        -- Stimulus Vector 195
        in1 <= "11000011";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 195" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 195" severity error;

        -- Stimulus Vector 196
        in1 <= "11000100";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 196" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 196" severity error;

        -- Stimulus Vector 197
        in1 <= "11000101";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 197" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 197" severity error;

        -- Stimulus Vector 198
        in1 <= "11000110";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 198" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 198" severity error;

        -- Stimulus Vector 199
        in1 <= "11000111";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 199" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 199" severity error;

        -- Stimulus Vector 200
        in1 <= "11001000";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 200" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 200" severity error;

        -- Stimulus Vector 201
        in1 <= "11001001";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 201" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 201" severity error;

        -- Stimulus Vector 202
        in1 <= "11001010";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 202" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 202" severity error;

        -- Stimulus Vector 203
        in1 <= "11001011";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 203" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 203" severity error;

        -- Stimulus Vector 204
        in1 <= "11001100";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 204" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 204" severity error;

        -- Stimulus Vector 205
        in1 <= "11001101";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 205" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 205" severity error;

        -- Stimulus Vector 206
        in1 <= "11001110";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 206" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 206" severity error;

        -- Stimulus Vector 207
        in1 <= "11001111";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 207" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 207" severity error;

        -- Stimulus Vector 208
        in1 <= "11010000";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 208" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 208" severity error;

        -- Stimulus Vector 209
        in1 <= "11010001";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 209" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 209" severity error;

        -- Stimulus Vector 210
        in1 <= "11010010";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 210" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 210" severity error;

        -- Stimulus Vector 211
        in1 <= "11010011";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 211" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 211" severity error;

        -- Stimulus Vector 212
        in1 <= "11010100";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 212" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 212" severity error;

        -- Stimulus Vector 213
        in1 <= "11010101";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 213" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 213" severity error;

        -- Stimulus Vector 214
        in1 <= "11010110";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 214" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 214" severity error;

        -- Stimulus Vector 215
        in1 <= "11010111";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 215" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 215" severity error;

        -- Stimulus Vector 216
        in1 <= "11011000";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 216" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 216" severity error;

        -- Stimulus Vector 217
        in1 <= "11011001";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 217" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 217" severity error;

        -- Stimulus Vector 218
        in1 <= "11011010";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 218" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 218" severity error;

        -- Stimulus Vector 219
        in1 <= "11011011";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 219" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 219" severity error;

        -- Stimulus Vector 220
        in1 <= "11011100";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 220" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 220" severity error;

        -- Stimulus Vector 221
        in1 <= "11011101";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 221" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 221" severity error;

        -- Stimulus Vector 222
        in1 <= "11011110";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 222" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 222" severity error;

        -- Stimulus Vector 223
        in1 <= "11011111";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 223" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 223" severity error;

        -- Stimulus Vector 224
        in1 <= "11100000";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 224" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 224" severity error;

        -- Stimulus Vector 225
        in1 <= "11100001";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 225" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 225" severity error;

        -- Stimulus Vector 226
        in1 <= "11100010";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 226" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 226" severity error;

        -- Stimulus Vector 227
        in1 <= "11100011";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 227" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 227" severity error;

        -- Stimulus Vector 228
        in1 <= "11100100";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 228" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 228" severity error;

        -- Stimulus Vector 229
        in1 <= "11100101";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 229" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 229" severity error;

        -- Stimulus Vector 230
        in1 <= "11100110";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 230" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 230" severity error;

        -- Stimulus Vector 231
        in1 <= "11100111";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 231" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 231" severity error;

        -- Stimulus Vector 232
        in1 <= "11101000";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 232" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 232" severity error;

        -- Stimulus Vector 233
        in1 <= "11101001";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 233" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 233" severity error;

        -- Stimulus Vector 234
        in1 <= "11101010";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 234" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 234" severity error;

        -- Stimulus Vector 235
        in1 <= "11101011";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 235" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 235" severity error;

        -- Stimulus Vector 236
        in1 <= "11101100";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 236" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 236" severity error;

        -- Stimulus Vector 237
        in1 <= "11101101";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 237" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 237" severity error;

        -- Stimulus Vector 238
        in1 <= "11101110";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 238" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 238" severity error;

        -- Stimulus Vector 239
        in1 <= "11101111";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 239" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 239" severity error;

        -- Stimulus Vector 240
        in1 <= "11110000";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 240" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 240" severity error;

        -- Stimulus Vector 241
        in1 <= "11110001";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 241" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 241" severity error;

        -- Stimulus Vector 242
        in1 <= "11110010";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 242" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 242" severity error;

        -- Stimulus Vector 243
        in1 <= "11110011";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 243" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 243" severity error;

        -- Stimulus Vector 244
        in1 <= "11110100";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 244" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 244" severity error;

        -- Stimulus Vector 245
        in1 <= "11110101";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 245" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 245" severity error;

        -- Stimulus Vector 246
        in1 <= "11110110";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 246" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 246" severity error;

        -- Stimulus Vector 247
        in1 <= "11110111";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 247" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 247" severity error;

        -- Stimulus Vector 248
        in1 <= "11111000";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 248" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 248" severity error;

        -- Stimulus Vector 249
        in1 <= "11111001";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 249" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 249" severity error;

        -- Stimulus Vector 250
        in1 <= "11111010";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 250" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 250" severity error;

        -- Stimulus Vector 251
        in1 <= "11111011";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 251" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 251" severity error;

        -- Stimulus Vector 252
        in1 <= "11111100";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 252" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 252" severity error;

        -- Stimulus Vector 253
        in1 <= "11111101";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 253" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 253" severity error;

        -- Stimulus Vector 254
        in1 <= "11111110";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 254" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 254" severity error;

        -- Stimulus Vector 255
        in1 <= "11111111";
        in2 <= "00000000";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 255" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 255" severity error;

        -- Stimulus Vector 256
        in1 <= "00000000";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 256" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 256" severity error;

        -- Stimulus Vector 257
        in1 <= "00000001";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 257" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 257" severity error;

        -- Stimulus Vector 258
        in1 <= "00000010";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 258" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 258" severity error;

        -- Stimulus Vector 259
        in1 <= "00000011";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 259" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 259" severity error;

        -- Stimulus Vector 260
        in1 <= "00000100";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 260" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 260" severity error;

        -- Stimulus Vector 261
        in1 <= "00000101";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 261" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 261" severity error;

        -- Stimulus Vector 262
        in1 <= "00000110";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 262" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 262" severity error;

        -- Stimulus Vector 263
        in1 <= "00000111";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 263" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 263" severity error;

        -- Stimulus Vector 264
        in1 <= "00001000";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 264" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 264" severity error;

        -- Stimulus Vector 265
        in1 <= "00001001";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 265" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 265" severity error;

        -- Stimulus Vector 266
        in1 <= "00001010";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 266" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 266" severity error;

        -- Stimulus Vector 267
        in1 <= "00001011";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 267" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 267" severity error;

        -- Stimulus Vector 268
        in1 <= "00001100";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 268" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 268" severity error;

        -- Stimulus Vector 269
        in1 <= "00001101";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 269" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 269" severity error;

        -- Stimulus Vector 270
        in1 <= "00001110";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 270" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 270" severity error;

        -- Stimulus Vector 271
        in1 <= "00001111";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 271" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 271" severity error;

        -- Stimulus Vector 272
        in1 <= "00010000";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 272" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 272" severity error;

        -- Stimulus Vector 273
        in1 <= "00010001";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 273" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 273" severity error;

        -- Stimulus Vector 274
        in1 <= "00010010";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 274" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 274" severity error;

        -- Stimulus Vector 275
        in1 <= "00010011";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 275" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 275" severity error;

        -- Stimulus Vector 276
        in1 <= "00010100";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 276" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 276" severity error;

        -- Stimulus Vector 277
        in1 <= "00010101";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 277" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 277" severity error;

        -- Stimulus Vector 278
        in1 <= "00010110";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 278" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 278" severity error;

        -- Stimulus Vector 279
        in1 <= "00010111";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 279" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 279" severity error;

        -- Stimulus Vector 280
        in1 <= "00011000";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 280" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 280" severity error;

        -- Stimulus Vector 281
        in1 <= "00011001";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 281" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 281" severity error;

        -- Stimulus Vector 282
        in1 <= "00011010";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 282" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 282" severity error;

        -- Stimulus Vector 283
        in1 <= "00011011";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 283" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 283" severity error;

        -- Stimulus Vector 284
        in1 <= "00011100";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 284" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 284" severity error;

        -- Stimulus Vector 285
        in1 <= "00011101";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 285" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 285" severity error;

        -- Stimulus Vector 286
        in1 <= "00011110";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 286" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 286" severity error;

        -- Stimulus Vector 287
        in1 <= "00011111";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 287" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 287" severity error;

        -- Stimulus Vector 288
        in1 <= "00100000";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 288" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 288" severity error;

        -- Stimulus Vector 289
        in1 <= "00100001";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 289" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 289" severity error;

        -- Stimulus Vector 290
        in1 <= "00100010";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 290" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 290" severity error;

        -- Stimulus Vector 291
        in1 <= "00100011";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 291" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 291" severity error;

        -- Stimulus Vector 292
        in1 <= "00100100";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 292" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 292" severity error;

        -- Stimulus Vector 293
        in1 <= "00100101";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 293" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 293" severity error;

        -- Stimulus Vector 294
        in1 <= "00100110";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 294" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 294" severity error;

        -- Stimulus Vector 295
        in1 <= "00100111";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 295" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 295" severity error;

        -- Stimulus Vector 296
        in1 <= "00101000";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 296" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 296" severity error;

        -- Stimulus Vector 297
        in1 <= "00101001";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 297" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 297" severity error;

        -- Stimulus Vector 298
        in1 <= "00101010";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 298" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 298" severity error;

        -- Stimulus Vector 299
        in1 <= "00101011";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 299" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 299" severity error;

        -- Stimulus Vector 300
        in1 <= "00101100";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 300" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 300" severity error;

        -- Stimulus Vector 301
        in1 <= "00101101";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 301" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 301" severity error;

        -- Stimulus Vector 302
        in1 <= "00101110";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 302" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 302" severity error;

        -- Stimulus Vector 303
        in1 <= "00101111";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 303" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 303" severity error;

        -- Stimulus Vector 304
        in1 <= "00110000";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 304" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 304" severity error;

        -- Stimulus Vector 305
        in1 <= "00110001";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 305" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 305" severity error;

        -- Stimulus Vector 306
        in1 <= "00110010";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 306" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 306" severity error;

        -- Stimulus Vector 307
        in1 <= "00110011";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 307" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 307" severity error;

        -- Stimulus Vector 308
        in1 <= "00110100";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 308" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 308" severity error;

        -- Stimulus Vector 309
        in1 <= "00110101";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 309" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 309" severity error;

        -- Stimulus Vector 310
        in1 <= "00110110";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 310" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 310" severity error;

        -- Stimulus Vector 311
        in1 <= "00110111";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 311" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 311" severity error;

        -- Stimulus Vector 312
        in1 <= "00111000";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 312" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 312" severity error;

        -- Stimulus Vector 313
        in1 <= "00111001";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 313" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 313" severity error;

        -- Stimulus Vector 314
        in1 <= "00111010";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 314" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 314" severity error;

        -- Stimulus Vector 315
        in1 <= "00111011";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 315" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 315" severity error;

        -- Stimulus Vector 316
        in1 <= "00111100";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 316" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 316" severity error;

        -- Stimulus Vector 317
        in1 <= "00111101";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 317" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 317" severity error;

        -- Stimulus Vector 318
        in1 <= "00111110";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 318" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 318" severity error;

        -- Stimulus Vector 319
        in1 <= "00111111";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 319" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 319" severity error;

        -- Stimulus Vector 320
        in1 <= "01000000";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 320" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 320" severity error;

        -- Stimulus Vector 321
        in1 <= "01000001";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 321" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 321" severity error;

        -- Stimulus Vector 322
        in1 <= "01000010";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 322" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 322" severity error;

        -- Stimulus Vector 323
        in1 <= "01000011";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 323" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 323" severity error;

        -- Stimulus Vector 324
        in1 <= "01000100";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 324" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 324" severity error;

        -- Stimulus Vector 325
        in1 <= "01000101";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 325" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 325" severity error;

        -- Stimulus Vector 326
        in1 <= "01000110";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 326" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 326" severity error;

        -- Stimulus Vector 327
        in1 <= "01000111";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 327" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 327" severity error;

        -- Stimulus Vector 328
        in1 <= "01001000";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 328" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 328" severity error;

        -- Stimulus Vector 329
        in1 <= "01001001";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 329" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 329" severity error;

        -- Stimulus Vector 330
        in1 <= "01001010";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 330" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 330" severity error;

        -- Stimulus Vector 331
        in1 <= "01001011";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 331" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 331" severity error;

        -- Stimulus Vector 332
        in1 <= "01001100";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 332" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 332" severity error;

        -- Stimulus Vector 333
        in1 <= "01001101";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 333" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 333" severity error;

        -- Stimulus Vector 334
        in1 <= "01001110";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 334" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 334" severity error;

        -- Stimulus Vector 335
        in1 <= "01001111";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 335" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 335" severity error;

        -- Stimulus Vector 336
        in1 <= "01010000";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 336" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 336" severity error;

        -- Stimulus Vector 337
        in1 <= "01010001";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 337" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 337" severity error;

        -- Stimulus Vector 338
        in1 <= "01010010";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 338" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 338" severity error;

        -- Stimulus Vector 339
        in1 <= "01010011";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 339" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 339" severity error;

        -- Stimulus Vector 340
        in1 <= "01010100";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 340" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 340" severity error;

        -- Stimulus Vector 341
        in1 <= "01010101";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 341" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 341" severity error;

        -- Stimulus Vector 342
        in1 <= "01010110";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 342" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 342" severity error;

        -- Stimulus Vector 343
        in1 <= "01010111";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 343" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 343" severity error;

        -- Stimulus Vector 344
        in1 <= "01011000";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 344" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 344" severity error;

        -- Stimulus Vector 345
        in1 <= "01011001";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 345" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 345" severity error;

        -- Stimulus Vector 346
        in1 <= "01011010";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 346" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 346" severity error;

        -- Stimulus Vector 347
        in1 <= "01011011";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 347" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 347" severity error;

        -- Stimulus Vector 348
        in1 <= "01011100";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 348" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 348" severity error;

        -- Stimulus Vector 349
        in1 <= "01011101";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 349" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 349" severity error;

        -- Stimulus Vector 350
        in1 <= "01011110";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 350" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 350" severity error;

        -- Stimulus Vector 351
        in1 <= "01011111";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 351" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 351" severity error;

        -- Stimulus Vector 352
        in1 <= "01100000";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 352" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 352" severity error;

        -- Stimulus Vector 353
        in1 <= "01100001";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 353" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 353" severity error;

        -- Stimulus Vector 354
        in1 <= "01100010";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 354" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 354" severity error;

        -- Stimulus Vector 355
        in1 <= "01100011";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 355" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 355" severity error;

        -- Stimulus Vector 356
        in1 <= "01100100";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 356" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 356" severity error;

        -- Stimulus Vector 357
        in1 <= "01100101";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 357" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 357" severity error;

        -- Stimulus Vector 358
        in1 <= "01100110";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 358" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 358" severity error;

        -- Stimulus Vector 359
        in1 <= "01100111";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 359" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 359" severity error;

        -- Stimulus Vector 360
        in1 <= "01101000";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 360" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 360" severity error;

        -- Stimulus Vector 361
        in1 <= "01101001";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 361" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 361" severity error;

        -- Stimulus Vector 362
        in1 <= "01101010";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 362" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 362" severity error;

        -- Stimulus Vector 363
        in1 <= "01101011";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 363" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 363" severity error;

        -- Stimulus Vector 364
        in1 <= "01101100";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 364" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 364" severity error;

        -- Stimulus Vector 365
        in1 <= "01101101";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 365" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 365" severity error;

        -- Stimulus Vector 366
        in1 <= "01101110";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 366" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 366" severity error;

        -- Stimulus Vector 367
        in1 <= "01101111";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 367" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 367" severity error;

        -- Stimulus Vector 368
        in1 <= "01110000";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 368" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 368" severity error;

        -- Stimulus Vector 369
        in1 <= "01110001";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 369" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 369" severity error;

        -- Stimulus Vector 370
        in1 <= "01110010";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 370" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 370" severity error;

        -- Stimulus Vector 371
        in1 <= "01110011";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 371" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 371" severity error;

        -- Stimulus Vector 372
        in1 <= "01110100";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 372" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 372" severity error;

        -- Stimulus Vector 373
        in1 <= "01110101";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 373" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 373" severity error;

        -- Stimulus Vector 374
        in1 <= "01110110";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 374" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 374" severity error;

        -- Stimulus Vector 375
        in1 <= "01110111";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 375" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 375" severity error;

        -- Stimulus Vector 376
        in1 <= "01111000";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 376" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 376" severity error;

        -- Stimulus Vector 377
        in1 <= "01111001";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 377" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 377" severity error;

        -- Stimulus Vector 378
        in1 <= "01111010";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 378" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 378" severity error;

        -- Stimulus Vector 379
        in1 <= "01111011";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 379" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 379" severity error;

        -- Stimulus Vector 380
        in1 <= "01111100";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 380" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 380" severity error;

        -- Stimulus Vector 381
        in1 <= "01111101";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 381" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 381" severity error;

        -- Stimulus Vector 382
        in1 <= "01111110";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 382" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 382" severity error;

        -- Stimulus Vector 383
        in1 <= "01111111";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 383" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 383" severity error;

        -- Stimulus Vector 384
        in1 <= "10000000";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 384" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 384" severity error;

        -- Stimulus Vector 385
        in1 <= "10000001";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 385" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 385" severity error;

        -- Stimulus Vector 386
        in1 <= "10000010";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 386" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 386" severity error;

        -- Stimulus Vector 387
        in1 <= "10000011";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 387" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 387" severity error;

        -- Stimulus Vector 388
        in1 <= "10000100";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 388" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 388" severity error;

        -- Stimulus Vector 389
        in1 <= "10000101";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 389" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 389" severity error;

        -- Stimulus Vector 390
        in1 <= "10000110";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 390" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 390" severity error;

        -- Stimulus Vector 391
        in1 <= "10000111";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 391" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 391" severity error;

        -- Stimulus Vector 392
        in1 <= "10001000";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 392" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 392" severity error;

        -- Stimulus Vector 393
        in1 <= "10001001";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 393" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 393" severity error;

        -- Stimulus Vector 394
        in1 <= "10001010";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 394" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 394" severity error;

        -- Stimulus Vector 395
        in1 <= "10001011";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 395" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 395" severity error;

        -- Stimulus Vector 396
        in1 <= "10001100";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 396" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 396" severity error;

        -- Stimulus Vector 397
        in1 <= "10001101";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 397" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 397" severity error;

        -- Stimulus Vector 398
        in1 <= "10001110";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 398" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 398" severity error;

        -- Stimulus Vector 399
        in1 <= "10001111";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 399" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 399" severity error;

        -- Stimulus Vector 400
        in1 <= "10010000";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 400" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 400" severity error;

        -- Stimulus Vector 401
        in1 <= "10010001";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 401" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 401" severity error;

        -- Stimulus Vector 402
        in1 <= "10010010";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 402" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 402" severity error;

        -- Stimulus Vector 403
        in1 <= "10010011";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 403" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 403" severity error;

        -- Stimulus Vector 404
        in1 <= "10010100";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 404" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 404" severity error;

        -- Stimulus Vector 405
        in1 <= "10010101";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 405" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 405" severity error;

        -- Stimulus Vector 406
        in1 <= "10010110";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 406" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 406" severity error;

        -- Stimulus Vector 407
        in1 <= "10010111";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 407" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 407" severity error;

        -- Stimulus Vector 408
        in1 <= "10011000";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 408" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 408" severity error;

        -- Stimulus Vector 409
        in1 <= "10011001";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 409" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 409" severity error;

        -- Stimulus Vector 410
        in1 <= "10011010";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 410" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 410" severity error;

        -- Stimulus Vector 411
        in1 <= "10011011";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 411" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 411" severity error;

        -- Stimulus Vector 412
        in1 <= "10011100";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 412" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 412" severity error;

        -- Stimulus Vector 413
        in1 <= "10011101";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 413" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 413" severity error;

        -- Stimulus Vector 414
        in1 <= "10011110";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 414" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 414" severity error;

        -- Stimulus Vector 415
        in1 <= "10011111";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 415" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 415" severity error;

        -- Stimulus Vector 416
        in1 <= "10100000";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 416" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 416" severity error;

        -- Stimulus Vector 417
        in1 <= "10100001";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 417" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 417" severity error;

        -- Stimulus Vector 418
        in1 <= "10100010";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 418" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 418" severity error;

        -- Stimulus Vector 419
        in1 <= "10100011";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 419" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 419" severity error;

        -- Stimulus Vector 420
        in1 <= "10100100";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 420" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 420" severity error;

        -- Stimulus Vector 421
        in1 <= "10100101";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 421" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 421" severity error;

        -- Stimulus Vector 422
        in1 <= "10100110";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 422" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 422" severity error;

        -- Stimulus Vector 423
        in1 <= "10100111";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 423" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 423" severity error;

        -- Stimulus Vector 424
        in1 <= "10101000";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 424" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 424" severity error;

        -- Stimulus Vector 425
        in1 <= "10101001";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 425" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 425" severity error;

        -- Stimulus Vector 426
        in1 <= "10101010";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 426" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 426" severity error;

        -- Stimulus Vector 427
        in1 <= "10101011";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 427" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 427" severity error;

        -- Stimulus Vector 428
        in1 <= "10101100";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 428" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 428" severity error;

        -- Stimulus Vector 429
        in1 <= "10101101";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 429" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 429" severity error;

        -- Stimulus Vector 430
        in1 <= "10101110";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 430" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 430" severity error;

        -- Stimulus Vector 431
        in1 <= "10101111";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 431" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 431" severity error;

        -- Stimulus Vector 432
        in1 <= "10110000";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 432" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 432" severity error;

        -- Stimulus Vector 433
        in1 <= "10110001";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 433" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 433" severity error;

        -- Stimulus Vector 434
        in1 <= "10110010";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 434" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 434" severity error;

        -- Stimulus Vector 435
        in1 <= "10110011";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 435" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 435" severity error;

        -- Stimulus Vector 436
        in1 <= "10110100";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 436" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 436" severity error;

        -- Stimulus Vector 437
        in1 <= "10110101";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 437" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 437" severity error;

        -- Stimulus Vector 438
        in1 <= "10110110";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 438" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 438" severity error;

        -- Stimulus Vector 439
        in1 <= "10110111";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 439" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 439" severity error;

        -- Stimulus Vector 440
        in1 <= "10111000";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 440" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 440" severity error;

        -- Stimulus Vector 441
        in1 <= "10111001";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 441" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 441" severity error;

        -- Stimulus Vector 442
        in1 <= "10111010";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 442" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 442" severity error;

        -- Stimulus Vector 443
        in1 <= "10111011";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 443" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 443" severity error;

        -- Stimulus Vector 444
        in1 <= "10111100";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 444" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 444" severity error;

        -- Stimulus Vector 445
        in1 <= "10111101";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 445" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 445" severity error;

        -- Stimulus Vector 446
        in1 <= "10111110";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 446" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 446" severity error;

        -- Stimulus Vector 447
        in1 <= "10111111";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 447" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 447" severity error;

        -- Stimulus Vector 448
        in1 <= "11000000";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 448" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 448" severity error;

        -- Stimulus Vector 449
        in1 <= "11000001";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 449" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 449" severity error;

        -- Stimulus Vector 450
        in1 <= "11000010";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 450" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 450" severity error;

        -- Stimulus Vector 451
        in1 <= "11000011";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 451" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 451" severity error;

        -- Stimulus Vector 452
        in1 <= "11000100";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 452" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 452" severity error;

        -- Stimulus Vector 453
        in1 <= "11000101";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 453" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 453" severity error;

        -- Stimulus Vector 454
        in1 <= "11000110";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 454" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 454" severity error;

        -- Stimulus Vector 455
        in1 <= "11000111";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 455" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 455" severity error;

        -- Stimulus Vector 456
        in1 <= "11001000";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 456" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 456" severity error;

        -- Stimulus Vector 457
        in1 <= "11001001";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 457" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 457" severity error;

        -- Stimulus Vector 458
        in1 <= "11001010";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 458" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 458" severity error;

        -- Stimulus Vector 459
        in1 <= "11001011";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 459" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 459" severity error;

        -- Stimulus Vector 460
        in1 <= "11001100";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 460" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 460" severity error;

        -- Stimulus Vector 461
        in1 <= "11001101";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 461" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 461" severity error;

        -- Stimulus Vector 462
        in1 <= "11001110";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 462" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 462" severity error;

        -- Stimulus Vector 463
        in1 <= "11001111";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 463" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 463" severity error;

        -- Stimulus Vector 464
        in1 <= "11010000";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 464" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 464" severity error;

        -- Stimulus Vector 465
        in1 <= "11010001";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 465" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 465" severity error;

        -- Stimulus Vector 466
        in1 <= "11010010";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 466" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 466" severity error;

        -- Stimulus Vector 467
        in1 <= "11010011";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 467" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 467" severity error;

        -- Stimulus Vector 468
        in1 <= "11010100";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 468" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 468" severity error;

        -- Stimulus Vector 469
        in1 <= "11010101";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 469" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 469" severity error;

        -- Stimulus Vector 470
        in1 <= "11010110";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 470" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 470" severity error;

        -- Stimulus Vector 471
        in1 <= "11010111";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 471" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 471" severity error;

        -- Stimulus Vector 472
        in1 <= "11011000";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 472" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 472" severity error;

        -- Stimulus Vector 473
        in1 <= "11011001";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 473" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 473" severity error;

        -- Stimulus Vector 474
        in1 <= "11011010";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 474" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 474" severity error;

        -- Stimulus Vector 475
        in1 <= "11011011";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 475" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 475" severity error;

        -- Stimulus Vector 476
        in1 <= "11011100";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 476" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 476" severity error;

        -- Stimulus Vector 477
        in1 <= "11011101";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 477" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 477" severity error;

        -- Stimulus Vector 478
        in1 <= "11011110";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 478" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 478" severity error;

        -- Stimulus Vector 479
        in1 <= "11011111";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 479" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 479" severity error;

        -- Stimulus Vector 480
        in1 <= "11100000";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 480" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 480" severity error;

        -- Stimulus Vector 481
        in1 <= "11100001";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 481" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 481" severity error;

        -- Stimulus Vector 482
        in1 <= "11100010";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 482" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 482" severity error;

        -- Stimulus Vector 483
        in1 <= "11100011";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 483" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 483" severity error;

        -- Stimulus Vector 484
        in1 <= "11100100";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 484" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 484" severity error;

        -- Stimulus Vector 485
        in1 <= "11100101";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 485" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 485" severity error;

        -- Stimulus Vector 486
        in1 <= "11100110";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 486" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 486" severity error;

        -- Stimulus Vector 487
        in1 <= "11100111";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 487" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 487" severity error;

        -- Stimulus Vector 488
        in1 <= "11101000";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 488" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 488" severity error;

        -- Stimulus Vector 489
        in1 <= "11101001";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 489" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 489" severity error;

        -- Stimulus Vector 490
        in1 <= "11101010";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 490" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 490" severity error;

        -- Stimulus Vector 491
        in1 <= "11101011";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 491" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 491" severity error;

        -- Stimulus Vector 492
        in1 <= "11101100";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 492" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 492" severity error;

        -- Stimulus Vector 493
        in1 <= "11101101";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 493" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 493" severity error;

        -- Stimulus Vector 494
        in1 <= "11101110";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 494" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 494" severity error;

        -- Stimulus Vector 495
        in1 <= "11101111";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 495" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 495" severity error;

        -- Stimulus Vector 496
        in1 <= "11110000";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 496" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 496" severity error;

        -- Stimulus Vector 497
        in1 <= "11110001";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 497" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 497" severity error;

        -- Stimulus Vector 498
        in1 <= "11110010";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 498" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 498" severity error;

        -- Stimulus Vector 499
        in1 <= "11110011";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 499" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 499" severity error;

        -- Stimulus Vector 500
        in1 <= "11110100";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 500" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 500" severity error;

        -- Stimulus Vector 501
        in1 <= "11110101";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 501" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 501" severity error;

        -- Stimulus Vector 502
        in1 <= "11110110";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 502" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 502" severity error;

        -- Stimulus Vector 503
        in1 <= "11110111";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 503" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 503" severity error;

        -- Stimulus Vector 504
        in1 <= "11111000";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 504" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 504" severity error;

        -- Stimulus Vector 505
        in1 <= "11111001";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 505" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 505" severity error;

        -- Stimulus Vector 506
        in1 <= "11111010";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 506" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 506" severity error;

        -- Stimulus Vector 507
        in1 <= "11111011";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 507" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 507" severity error;

        -- Stimulus Vector 508
        in1 <= "11111100";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 508" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 508" severity error;

        -- Stimulus Vector 509
        in1 <= "11111101";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 509" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 509" severity error;

        -- Stimulus Vector 510
        in1 <= "11111110";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 510" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 510" severity error;

        -- Stimulus Vector 511
        in1 <= "11111111";
        in2 <= "00000001";
        c_in <= '0';
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct') for vector 511" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct') for vector 511" severity error;

        wait;
    end process;
end architecture;
-- ========================================================

