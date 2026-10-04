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

