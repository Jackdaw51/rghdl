library ieee;
use ieee.std_logic_1164.all;
entity test_flat is
	port (
		a: in std_logic;
		v: out std_logic
	);
end test_flat;

architecture b of test_flat is
begin
	v <= '1';
end b;

