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
	for i_0 in std_logic loop
        a <= i_0;
	for i_1 in std_logic loop
        b <= i_1;
	for i_2 in std_logic loop
        cin <= i_2;
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'full_adder', port 'sum' (arch 'struct')" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'full_adder', port 'cout' (arch 'struct')" severity error;

	end loop;
	end loop;
	end loop;
        wait;
    end process;
end architecture;
-- ========================================================

