library ieee;
use ieee.std_logic_1164.all;
entity inv_flat is
	port (
		a: In std_logic;
		y: Out std_logic
	);
end inv_flat;

architecture rtl of inv_flat is
begin
	y <= not  a;
end rtl;

library ieee;
use ieee.std_logic_1164.all;
entity and2_flat is
	port (
		a: In std_logic;
		b: In std_logic;
		y: Out std_logic
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
		a: In std_logic;
		b: In std_logic;
		y: Out std_logic
	);
end or2_flat;

architecture rtl of or2_flat is
begin
	y <= a Or b;
end rtl;

library ieee;
use ieee.std_logic_1164.all;
entity xor2_flat is
	port (
		a: In std_logic;
		b: In std_logic;
		y: Out std_logic
	);
end xor2_flat;

architecture rtl of xor2_flat is
begin
	y <= a Xor b;
end rtl;

