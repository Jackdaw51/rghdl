-- Rung 2: several design units in a single file.
-- A parser that assumes one entity per file breaks here. You might want to create different files if that breaks
-- Also exercises: entity WITHOUT a generic clause, 'end' with no keyword,
-- 'end' with no label, multiple architectures of the same entity.
library ieee;
use ieee.std_logic_1164.all;

entity inv is
    port (a : in std_logic; y : out std_logic);
end;                                    -- no 'entity' keyword, no label

architecture rtl of inv is
begin
    y <= not a;
end;

--------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity and2 is
    port (a, b : in std_logic; y : out std_logic);
end entity;                             -- keyword, no label

architecture rtl of and2 is
begin
    y <= a and b;
end architecture;

--------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity or2 is
    port (a, b : in std_logic; y : out std_logic);
end entity or2;

architecture rtl of or2 is
begin
    y <= a or b;
end architecture rtl;

--------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity xor2 is
    port (a, b : in std_logic; y : out std_logic);
end entity xor2;

-- Two architectures for one entity: the elaborator must keep them distinct.
architecture rtl of xor2 is
begin
    y <= a xor b;
end architecture rtl;

architecture gate_level of xor2 is
    signal n_a, n_b, t1, t2 : std_logic;
begin
    n_a <= not a;
    n_b <= not b;
    t1  <= a and n_b;
    t2  <= n_a and b;
    y   <= t1 or t2;
end architecture gate_level;
