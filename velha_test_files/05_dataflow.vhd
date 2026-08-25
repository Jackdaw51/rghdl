-- Rung 5: concurrent statement forms.
-- Exercises: conditional signal assignment (when/else), selected signal assignment (with/select), guarded and transport/inertial assignment,
-- concurrent assertion, and the '<=' assignment vs '<=' relational operator appearing in the same file.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dataflow is
    port (
        sel   : in  std_logic_vector(1 downto 0);
        a, b  : in  std_logic_vector(3 downto 0);
        en    : in  std_logic;
        y     : out std_logic_vector(3 downto 0);
        z     : out std_logic_vector(3 downto 0);
        le    : out boolean
    );
end entity dataflow;

architecture rtl of dataflow is
    signal muxed : std_logic_vector(3 downto 0);
begin
    -- Conditional signal assignment.
    muxed <= a          when sel = "00" else
             b          when sel = "01" else
             a and b    when sel = "10" else
             (others => '0');

    -- Selected signal assignment.
    with sel select
        z <= a              when "00",
             b              when "01",
             a xor b        when "10" | "11",
             (others => 'X') when others;

    -- transport delay, and the relational '<=' in an expression on the
    -- right-hand side of an assignment that itself uses '<='.
    le <= unsigned(a) <= unsigned(b);

    y <= transport muxed after 3 ns when en = '1' else (others => 'Z');

    -- Concurrent assertion.
    assert not (en = '1' and sel = "11")
        report "illegal combination"
        severity warning;

end architecture rtl;
