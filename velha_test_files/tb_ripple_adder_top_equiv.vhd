library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity tb_ripple_adder_top_equiv is
end entity tb_ripple_adder_top_equiv;

architecture behavioral of tb_ripple_adder_top_equiv is
    signal in1 : std_logic_vector (3 downto 0);
    signal in2 : std_logic_vector (3 downto 0);
    signal c_in : std_logic;
    signal res_struct : std_logic_vector (3 downto 0);
    signal res_struct_flat : std_logic_vector (3 downto 0);
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
	for j_0 in std_logic loop
		in1(0) <= j_0;
	for j_1 in std_logic loop
		in1(1) <= j_1;
	for j_2 in std_logic loop
		in1(2) <= j_2;
	for j_3 in std_logic loop
		in1(3) <= j_3;
	for j_0 in std_logic loop
		in2(0) <= j_0;
	for j_1 in std_logic loop
		in2(1) <= j_1;
	for j_2 in std_logic loop
		in2(2) <= j_2;
	for j_3 in std_logic loop
		in2(3) <= j_3;
	for i_2 in std_logic loop
        c_in <= i_2;
        wait for 10 ns;
        assert res_struct_flat = res_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'res' (arch 'struct')" severity error;
        assert c_out_struct_flat = c_out_struct
            report "Equivalence Mismatch on entity 'ripple_adder_top', port 'c_out' (arch 'struct')" severity error;

	end loop;
	end loop;
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

