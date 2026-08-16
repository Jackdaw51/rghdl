library ieee;
use ieee.std_logic_1164.all;
entity and_gate_flat is
	port (
		a: In std_logic;
		b: In std_logic;
		z: Out std_logic
	);
end and_gate_flat;

architecture dataflow of and_gate_flat is
begin
	z <= a And b;
end dataflow;

