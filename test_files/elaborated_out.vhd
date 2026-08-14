entity and_gate_5 is
	port (
		a: In std_logic;
		b: In std_logic;
		z: Out std_logic
	);
end and_gate_5;

architecture dataflow of and_gate_5 is
begin
	z <= a And b;
end dataflow;

