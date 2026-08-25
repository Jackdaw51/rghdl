library ieee;
use ieee.std_logic_1164.all;
entity nand2_flat is
	generic (
		tpd : integer := 1000000
	);
	port (
		a: In std_logic;
		b: In std_logic;
		y: Out std_logic
	);
end nand2_flat;

architecture rtl of nand2_flat is
begin
	y <= not  (a And b) after 1000000 fs;
end rtl;

