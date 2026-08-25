library ieee;
use ieee.std_logic_1164.all;
library ieee;
use ieee.std_logic_1164.all;
library ieee;
use ieee.std_logic_1164.all;
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

