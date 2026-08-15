entity and_gate_19 is
	port (
		a: In boolean;
		b: In boolean;
		z: Out boolean
	);
end and_gate_19;

architecture dataflow of and_gate_19 is
begin
	z <= a And b;
end dataflow;

