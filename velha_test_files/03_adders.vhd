-- Rung 2: structural composition.
-- Exercises: component declaration vs direct entity instantiation,
-- positional vs named association, OPEN, generic maps, for-generate,
-- if-generate, guarded block with a bus-kind signal, nested hierarchy.
library ieee;
use ieee.std_logic_1164.all;

entity full_adder is
    port (
        a, b, cin : in  std_logic;
        sum       : out std_logic;
        cout      : out std_logic
    );
end entity full_adder;

architecture struct of full_adder is

    -- Component declaration: the classic indirect binding path.
    component xor2 is
        port (a, b : in std_logic; y : out std_logic);
    end component xor2;

    component and2
        port (a, b : in std_logic; y : out std_logic);
    end component;                      -- no 'is', no closing label

    signal s1, c1, c2 : std_logic;

begin

    -- Component instantiation, positional association.
    u_x1 : xor2 port map (a, b, s1);

    -- Direct entity instantiation with an explicit architecture, named assoc.
    u_x2 : entity work.xor2(rtl)
        port map (
            a => s1,
            b => cin,
            y => sum
        );

    -- Component instantiation, named association, out of declaration order.
    u_a1 : and2 port map (y => c1, a => a, b => b);

    -- Direct entity instantiation without naming the architecture.
    u_a2 : entity work.and2
        port map (a => s1, b => cin, y => c2);

    u_o1 : entity work.or2
        port map (a => c1, b => c2, y => cout);

end architecture struct;

--------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity ripple_adder is
    generic (
        width : positive := 4;
        tpd   : time     := 0 ns
    );
    port (
        a, b   : in  std_logic_vector(width - 1 downto 0);
        cin    : in  std_logic;
        sum    : out std_logic_vector(width - 1 downto 0);
        cout   : out std_logic;
        unused : out std_logic          -- deliberately left OPEN by callers
    );
end entity ripple_adder;

architecture struct of ripple_adder is
    signal carry : std_logic_vector(width downto 0);
begin

    carry(0) <= cin;
    cout     <= carry(width);
    unused   <= '0';

    -- for ... generate with an implicitly declared iterator.
    gen_bits : for i in 0 to width - 1 generate

        -- if ... generate, VHDL-93 form (no else branch).
        gen_first : if i = 0 generate
            u_fa : entity work.full_adder
                port map (
                    a    => a(i),
                    b    => b(i),
                    cin  => carry(i),
                    sum  => sum(i),
                    cout => carry(i + 1)
                );
        end generate gen_first;

        gen_rest : if i > 0 generate
            -- Generate statements may carry their own declarative part.
            signal local_c : std_logic;
        begin
            u_fa : entity work.full_adder
                port map (a(i), b(i), carry(i), sum(i), local_c);
            carry(i + 1) <= local_c;
        end generate gen_rest;

    end generate gen_bits;

end architecture struct;

--------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity adder_top is
    port (
        x, y  : in  std_logic_vector(7 downto 0);
        carry : in  std_logic;
        z     : out std_logic_vector(7 downto 0);
        ovf   : out std_logic
    );
end entity adder_top;

architecture struct of adder_top is
    signal enable : std_logic := '1';
begin

    -- Generic map + port map, with one formal left OPEN.
    u_add : entity work.ripple_adder
        generic map (
            width => 8,
            tpd   => 2 ns
        )
        port map (
            a      => x,
            b      => y,
            cin    => carry,
            sum    => z,
            cout   => ovf,
            unused => open
        );

    -- Guarded block: declarative part, guard expression, GUARDED waveform,
    -- and a signal declared with the BUS signal kind.
    monitor_blk : block (enable = '1')
        signal probe : std_logic bus;
    begin
        probe <= guarded carry;
    end block monitor_blk;

end architecture struct;
