library ieee;
use ieee.std_logic_1164.all;
entity xor2_flat is
	port (
		a: in std_logic;
		b: in std_logic;
		y: out std_logic
	);
end xor2_flat;

architecture rtl of xor2_flat is
begin
	y <= a Xor b;
end rtl;

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
	u_x1 : entity work.xor2_flat
		port map (
			a => a,
			b => b,
			y => s1
		);
	u_x2 : entity work.xor2_flat
		port map (
			a => s1,
			b => cin,
			y => sum
		);
	u_a1 : entity work.and2_flat
		port map (
			y => c1,
			a => a,
			b => b
		);
	u_a2 : entity work.and2_flat
		port map (
			a => s1,
			b => cin,
			y => c2
		);
	u_o1 : entity work.xor2_flat
		port map (
			a => c1,
			b => c2,
			y => cout
		);
end struct;

