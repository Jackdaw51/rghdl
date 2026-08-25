-- Rung 1: smoke test.
-- Exercises: context clause, entity with generic + port clause, port modes,
-- architecture body, one concurrent signal assignment, physical literal,
-- 'after' waveform element, optional closing labels.
library ieee;
use ieee.std_logic_1164.all;

entity nand2 is
    generic (
        tpd : time := 1 ns
    );
    port (
        a, b : in  std_logic;
        y    : out std_logic
    );
end entity nand2;

architecture rtl of nand2 is
begin
    y <= not (a and b) after tpd;
end architecture rtl;
