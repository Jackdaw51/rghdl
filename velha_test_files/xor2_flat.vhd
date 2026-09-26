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

