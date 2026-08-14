library ieee;
use ieee.std_logic_1164.all;

entity and_gate is
    port (
        a : in std_logic;
        b : in std_logic;
        z : out std_logic
    );
end entity and_gate;

architecture dataflow of and_gate is-- line comment in line
begin
    z <= a and b;
end architecture dataflow;
-- test line comment
/**/