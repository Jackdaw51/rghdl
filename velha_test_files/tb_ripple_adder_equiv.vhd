library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity tb_ripple_adder_equiv is
end entity tb_ripple_adder_equiv;

architecture behavioral of tb_ripple_adder_equiv is
    signal a : std_logic_vector (2 downto 0);
    signal b : std_logic_vector (2 downto 0);
    signal cin : std_logic;
    signal sum_struct : std_logic_vector (2 downto 0);
    signal sum_struct_flat : std_logic_vector (2 downto 0);
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
	for j_0 in std_logic loop
		a(0) <= j_0;
	for j_1 in std_logic loop
		a(1) <= j_1;
	for j_2 in std_logic loop
		a(2) <= j_2;
	for j_0 in std_logic loop
		b(0) <= j_0;
	for j_1 in std_logic loop
		b(1) <= j_1;
	for j_2 in std_logic loop
		b(2) <= j_2;
	for i_2 in std_logic loop
        cin <= i_2;
        wait for 10 ns;
        assert sum_struct_flat = sum_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'sum' (arch 'struct')" severity error;
        assert cout_struct_flat = cout_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'cout' (arch 'struct')" severity error;
        assert unused_struct_flat = unused_struct
            report "Equivalence Mismatch on entity 'ripple_adder', port 'unused' (arch 'struct')" severity error;

	end loop;
	end loop;
	end loop;
	end loop;
	end loop;
	end loop;
	end loop;
        wait;
    end process;
end architecture;
-- ========================================================

