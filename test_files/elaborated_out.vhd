entity and_gate is
	port (
		a: In boolean;
		b: In boolean;
		z: Out boolean
	);
end and_gate;

architecture dataflow of and_gate is
begin
	z <= a And b;
end dataflow;

