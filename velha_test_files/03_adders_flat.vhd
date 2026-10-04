library ieee;
use ieee.std_logic_1164.all;
entity xor2_flat is
	port (
		a: in std_logic;
		b: in std_logic;
		y: out std_logic
	);
end xor2_flat;

architecture gate_level of xor2_flat is
	signal n_a: std_logic;
	signal n_b: std_logic;
	signal t1: std_logic;
	signal t2: std_logic;
begin
	n_a <= not  a;
	n_b <= not  b;
	t1 <= a And n_b;
	t2 <= n_a And b;
	y <= t1 Or t2;
end gate_level;

library ieee;
use ieee.std_logic_1164.all;
entity and2_flat is
	port (
		a: in std_logic;
		b: in std_logic;
		y: out std_logic
	);
end and2_flat;

architecture rtl of and2_flat is
begin
	y <= a And b;
end rtl;

library ieee;
use ieee.std_logic_1164.all;
entity or2_flat is
	port (
		a: in std_logic;
		b: in std_logic;
		y: out std_logic
	);
end or2_flat;

architecture rtl of or2_flat is
begin
	y <= a Or b;
end rtl;

library ieee;
use ieee.std_logic_1164.all;
entity full_adder_flat is
	port (
		a: in std_logic;
		b: in std_logic;
		cin: in std_logic;
		sum: out std_logic;
		cout: out std_logic
	);
end full_adder_flat;

architecture struct of full_adder_flat is
	signal s1: std_logic;
	signal c1: std_logic;
	signal c2: std_logic;
begin
	ripple_adder_top_struct_u_adder_8bit_0_u_fa_u_x1 : entity work.xor2_flat
		port map (
			a => a,
			b => b,
			y => s1
		);
	ripple_adder_top_struct_u_adder_8bit_0_u_fa_u_x2 : entity work.xor2_flat
		port map (
			a => s1,
			b => cin,
			y => sum
		);
	ripple_adder_top_struct_u_adder_8bit_0_u_fa_u_a1 : entity work.and2_flat
		port map (
			y => c1,
			a => a,
			b => b
		);
	ripple_adder_top_struct_u_adder_8bit_0_u_fa_u_a2 : entity work.and2_flat
		port map (
			a => s1,
			b => cin,
			y => c2
		);
	ripple_adder_top_struct_u_adder_8bit_0_u_fa_u_o1 : entity work.or2_flat
		port map (
			a => c1,
			b => c2,
			y => cout
		);
end struct;

library ieee;
use ieee.std_logic_1164.all;
entity ripple_adder_flat is
	generic (
		width : integer := 8;
		tpd : integer := 2000000
	);
	port (
		a: in std_logic_vector(7 downto 0);
		b: in std_logic_vector(7 downto 0);
		cin: in std_logic;
		sum: out std_logic_vector(7 downto 0);
		cout: out std_logic;
		unused: out std_logic
	);
end ripple_adder_flat;

architecture struct of ripple_adder_flat is
	signal carry: std_logic_vector(8 downto 0);
	signal ripple_adder_top_struct_u_adder_8bit_1_local_c: std_logic;
	signal ripple_adder_top_struct_u_adder_8bit_2_local_c: std_logic;
	signal ripple_adder_top_struct_u_adder_8bit_3_local_c: std_logic;
	signal ripple_adder_top_struct_u_adder_8bit_4_local_c: std_logic;
	signal ripple_adder_top_struct_u_adder_8bit_5_local_c: std_logic;
	signal ripple_adder_top_struct_u_adder_8bit_6_local_c: std_logic;
	signal ripple_adder_top_struct_u_adder_8bit_7_local_c: std_logic;
begin
	carry(0) <= cin;
	cout <= carry(8);
	unused <= '0';
	carry(2) <= ripple_adder_top_struct_u_adder_8bit_1_local_c;
	carry(3) <= ripple_adder_top_struct_u_adder_8bit_2_local_c;
	carry(4) <= ripple_adder_top_struct_u_adder_8bit_3_local_c;
	carry(5) <= ripple_adder_top_struct_u_adder_8bit_4_local_c;
	carry(6) <= ripple_adder_top_struct_u_adder_8bit_5_local_c;
	carry(7) <= ripple_adder_top_struct_u_adder_8bit_6_local_c;
	carry(8) <= ripple_adder_top_struct_u_adder_8bit_7_local_c;
	ripple_adder_top_struct_u_adder_8bit_0_u_fa : entity work.full_adder_flat
		port map (
			a => a(0),
			b => b(0),
			cin => carry(0),
			sum => sum(0),
			cout => carry(1)
		);
	ripple_adder_top_struct_u_adder_8bit_1_u_fa : entity work.full_adder_flat
		port map (
			a => a(1),
			b => b(1),
			cin => carry(1),
			sum => sum(1),
			cout => ripple_adder_top_struct_u_adder_8bit_1_local_c
		);
	ripple_adder_top_struct_u_adder_8bit_2_u_fa : entity work.full_adder_flat
		port map (
			a => a(2),
			b => b(2),
			cin => carry(2),
			sum => sum(2),
			cout => ripple_adder_top_struct_u_adder_8bit_2_local_c
		);
	ripple_adder_top_struct_u_adder_8bit_3_u_fa : entity work.full_adder_flat
		port map (
			a => a(3),
			b => b(3),
			cin => carry(3),
			sum => sum(3),
			cout => ripple_adder_top_struct_u_adder_8bit_3_local_c
		);
	ripple_adder_top_struct_u_adder_8bit_4_u_fa : entity work.full_adder_flat
		port map (
			a => a(4),
			b => b(4),
			cin => carry(4),
			sum => sum(4),
			cout => ripple_adder_top_struct_u_adder_8bit_4_local_c
		);
	ripple_adder_top_struct_u_adder_8bit_5_u_fa : entity work.full_adder_flat
		port map (
			a => a(5),
			b => b(5),
			cin => carry(5),
			sum => sum(5),
			cout => ripple_adder_top_struct_u_adder_8bit_5_local_c
		);
	ripple_adder_top_struct_u_adder_8bit_6_u_fa : entity work.full_adder_flat
		port map (
			a => a(6),
			b => b(6),
			cin => carry(6),
			sum => sum(6),
			cout => ripple_adder_top_struct_u_adder_8bit_6_local_c
		);
	ripple_adder_top_struct_u_adder_8bit_7_u_fa : entity work.full_adder_flat
		port map (
			a => a(7),
			b => b(7),
			cin => carry(7),
			sum => sum(7),
			cout => ripple_adder_top_struct_u_adder_8bit_7_local_c
		);
end struct;

library ieee;
use ieee.std_logic_1164.all;
entity ripple_adder_top_flat is
	port (
		in1: in std_logic_vector(7 downto 0);
		in2: in std_logic_vector(7 downto 0);
		c_in: in std_logic;
		res: out std_logic_vector(7 downto 0);
		c_out: out std_logic
	);
end ripple_adder_top_flat;

architecture struct of ripple_adder_top_flat is
begin
	ripple_adder_top_struct_u_adder_8bit : entity work.ripple_adder_flat
		port map (
			a => in1,
			b => in2,
			cin => c_in,
			sum => res,
			cout => c_out
		);
end struct;

