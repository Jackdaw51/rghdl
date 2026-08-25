-- Testbenches for rungs 3 through 7.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.trace_pkg.all;

entity tb_alu is
end entity tb_alu;

architecture bench of tb_alu is
    signal clk    : std_logic := '0';
    signal rst_n  : std_logic := '0';
    signal opcode : std_logic_vector(2 downto 0) := "000";
    signal op_a   : std_logic_vector(7 downto 0) := (others => '0');
    signal op_b   : std_logic_vector(7 downto 0) := (others => '0');
    signal result : std_logic_vector(7 downto 0);
    signal zero   : std_logic;
    signal parity : std_logic;
    signal run    : boolean := true;
begin

    dut : entity work.alu
        generic map (width => 8)
        port map (clk => clk, rst_n => rst_n, opcode => opcode,
                  op_a => op_a, op_b => op_b,
                  result => result, zero => zero, parity => parity);

    -- Bounded clock: stops when the stimulus process clears 'run', so the
    -- simulation terminates on its own.
    clk <= not clk after 5 ns when run else '0';

    stim : process
        procedure step (op : std_logic_vector(2 downto 0);
                        a  : integer;
                        b  : integer) is
        begin
            opcode <= op;
            op_a   <= std_logic_vector(to_unsigned(a, 8));
            op_b   <= std_logic_vector(to_unsigned(b, 8));
            wait until falling_edge(clk);
            wait for 1 ns;
            trace(now_ns & " op=" & img(op)
                  & " a=" & img(op_a) & " b=" & img(op_b)
                  & " r=" & img(result)
                  & " z=" & img(zero) & " p=" & img(parity));
        end procedure step;
    begin
        trace("# tb_alu");
        rst_n <= '0';
        wait for 12 ns;
        rst_n <= '1';

        step("000",  10,   5);      -- add
        step("001",  10,   5);      -- sub
        step("010", 240, 170);      -- and (choice list, first alternative)
        step("011", 240, 170);      -- and (choice list, second alternative)
        step("100",   1,   3);      -- shift, shamt = 3 -> hits 1 to 3 branch
        step("101",   1,   5);      -- shift, shamt = 5 -> hits 4 to 7 branch
        step("110",   1,   0);      -- shift, shamt = 0 -> hits 'when 0'
        step("111",  99,  99);      -- others
        step("000", 255,   1);      -- wraparound
        step("001",   0,   1);      -- underflow

        run <= false;
        wait;
    end process stim;

end architecture bench;

--------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.trace_pkg.all;

entity tb_dataflow is
end entity tb_dataflow;

architecture bench of tb_dataflow is
    signal sel  : std_logic_vector(1 downto 0) := "00";
    signal a, b : std_logic_vector(3 downto 0) := (others => '0');
    signal en   : std_logic := '0';
    signal y, z : std_logic_vector(3 downto 0);
    signal le   : boolean;
begin

    dut : entity work.dataflow
        port map (sel => sel, a => a, b => b, en => en,
                  y => y, z => z, le => le);

    stim : process
        type ivec is array (natural range <>) of integer;
        constant as : ivec := (0, 5, 10, 15,  3,  8, 12, 1);
        constant bs : ivec := (0, 5,  3, 15, 10,  8,  1, 12);
    begin
        trace("# tb_dataflow");
        for i in as'range loop
            a   <= std_logic_vector(to_unsigned(as(i), 4));
            b   <= std_logic_vector(to_unsigned(bs(i), 4));
            sel <= std_logic_vector(to_unsigned(i mod 4, 2));
            if i mod 2 = 0 then en <= '1'; else en <= '0'; end if;
            wait for 20 ns;                 -- past the 3 ns transport delay
            trace(now_ns & " sel=" & img(sel)
                  & " a=" & img(a) & " b=" & img(b) & " en=" & img(en)
                  & " y=" & img(y) & " z=" & img(z) & " le=" & img(le));
        end loop;
        wait;
    end process stim;

end architecture bench;

--------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.trace_pkg.all;

entity tb_fsm is
end entity tb_fsm;

architecture bench of tb_fsm is
    signal clk     : std_logic := '0';
    signal rst_n   : std_logic := '0';
    signal start   : std_logic := '0';
    signal ack     : std_logic := '0';
    signal busy    : std_logic;
    signal done    : std_logic;
    signal rx      : std_logic := '0';
    signal valid   : std_logic;
    signal expired : std_logic;
    signal state_o : std_logic_vector(1 downto 0);
    signal run     : boolean := true;
begin

    dut_moore : entity work.fsm_moore
        port map (clk => clk, rst_n => rst_n, start => start, ack => ack,
                  busy => busy, done => done);

    dut_mealy : entity work.fsm_mealy
        generic map (timeout => 4)
        port map (clk => clk, rst_n => rst_n, rx => rx,
                  valid => valid, expired => expired, state_o => state_o);

    clk <= not clk after 5 ns when run else '0';

    stim : process
        -- Walks the Moore machine through a full cycle, then drives the
        -- Mealy machine with a pattern that reaches the timeout branch.
        constant rx_seq : std_logic_vector(0 to 23) :=
            "101110001111111111000101";
    begin
        trace("# tb_fsm");
        rst_n <= '0';
        wait for 12 ns;
        rst_n <= '1';

        for i in rx_seq'range loop
            rx    <= rx_seq(i);
            start <= rx_seq(i);
            if i = 6 or i = 14 then ack <= '1'; else ack <= '0'; end if;

            wait until falling_edge(clk);
            wait for 1 ns;
            trace(now_ns
                  & " rx=" & img(rx) & " st=" & img(start) & " ak=" & img(ack)
                  & " busy=" & img(busy) & " done=" & img(done)
                  & " vld=" & img(valid) & " exp=" & img(expired)
                  & " sto=" & img(state_o));
        end loop;

        run <= false;
        wait;
    end process stim;

end architecture bench;

--------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.trace_pkg.all;

entity tb_ambiguity is
end entity tb_ambiguity;

architecture bench of tb_ambiguity is
    signal v   : std_logic_vector(7 downto 0) := (others => '0');
    signal u   : unsigned(7 downto 0) := (others => '0');
    signal idx : integer range 0 to 3 := 0;

    signal o_indexed, o_membit, o_callidx  : std_logic;
    signal o_selected, o_tickparen         : std_logic;
    signal o_genrange                      : std_logic;
    signal o_slice, o_memslice             : std_logic_vector(3 downto 0);
    signal o_call, o_conv, o_qualified     : std_logic_vector(7 downto 0);
    signal o_nested, o_mixed, o_memelem    : std_logic_vector(7 downto 0);
    signal o_selcall                       : std_logic_vector(7 downto 0);
    signal o_attrlen, o_attrspan           : integer;
    signal o_typeattr                      : integer;
begin

    dut : entity work.ambiguity
        port map (
            v => v, u => u, idx => idx,
            o_indexed => o_indexed, o_slice => o_slice, o_call => o_call,
            o_conv => o_conv, o_qualified => o_qualified,
            o_nested => o_nested, o_mixed => o_mixed,
            o_memelem => o_memelem, o_membit => o_membit,
            o_memslice => o_memslice, o_callidx => o_callidx,
            o_selected => o_selected, o_selcall => o_selcall,
            o_attrlen => o_attrlen, o_attrspan => o_attrspan,
            o_typeattr => o_typeattr, o_tickparen => o_tickparen,
            o_genrange => o_genrange);

    stim : process
    begin
        trace("# tb_ambiguity");
        for i in 0 to 7 loop
            v   <= std_logic_vector(to_unsigned(i * 37 mod 256, 8));
            u   <= to_unsigned(i * 61 mod 256, 8);
            idx <= i mod 4;
            wait for 10 ns;
            trace(now_ns & " v=" & img(v) & " idx=" & img(idx)
                  & " ix=" & img(o_indexed)
                  & " sl=" & img(o_slice)
                  & " cl=" & img(o_call)
                  & " cv=" & img(o_conv)
                  & " ql=" & img(o_qualified)
                  & " ns=" & img(o_nested)
                  & " mx=" & img(o_mixed));
            trace(now_ns & "   me=" & img(o_memelem)
                  & " mb=" & img(o_membit)
                  & " ms=" & img(o_memslice)
                  & " ci=" & img(o_callidx)
                  & " sd=" & img(o_selected)
                  & " sc=" & img(o_selcall)
                  & " al=" & img(o_attrlen)
                  & " as=" & img(o_attrspan)
                  & " ta=" & img(o_typeattr)
                  & " tp=" & img(o_tickparen)
                  & " gr=" & img(o_genrange));
        end loop;
        wait;
    end process stim;

end architecture bench;

--------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.trace_pkg.all;

entity tb_aggregates is
end entity tb_aggregates;

architecture bench of tb_aggregates is
    signal d     : std_logic_vector(7 downto 0) := (others => '0');
    signal sel   : std_logic_vector(1 downto 0) := "00";
    signal a_out : std_logic;
    signal b_out : std_logic;
    signal q     : std_logic_vector(7 downto 0);
begin

    dut : entity work.aggregates
        port map (d => d, sel => sel, a_out => a_out, b_out => b_out, q => q);

    stim : process
    begin
        trace("# tb_aggregates");
        for i in 0 to 11 loop
            d   <= std_logic_vector(to_unsigned(i * 23 mod 256, 8));
            sel <= std_logic_vector(to_unsigned(i mod 4, 2));
            wait for 10 ns;
            trace(now_ns & " d=" & img(d) & " sel=" & img(sel)
                  & " a=" & img(a_out) & " b=" & img(b_out)
                  & " q=" & img(q));
        end loop;
        wait;
    end process stim;

end architecture bench;

--------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.trace_pkg.all;

entity tb_decls is
end entity tb_decls;

architecture bench of tb_decls is
    signal clk  : std_logic := '0';
    signal din  : std_logic_vector(15 downto 0) := (others => '0');
    signal dout : std_logic_vector(15 downto 0);
    signal run  : boolean := true;
begin

    -- Exercises the RAM write pointer, the slice alias, and the reversed
    -- alias. If the elaborator mishandles alias direction, dout flips.
    dut : entity work.decls
        port map (clk => clk, din => din, dout => dout);

    clk <= not clk after 5 ns when run else '0';

    stim : process
        -- integer_vector is VHDL-2008 only; declare the type locally so
        -- this TB stays analysable under --std=93.
        type ivec_t is array (natural range <>) of integer;
        constant patterns : ivec_t(0 to 9) :=
            (0, 16#00FF#, 16#FF00#, 16#1234#, 16#8001#,
             16#0001#, 16#ABCD#, 16#0000#, 16#FFFF#, 16#00AA#);
    begin
        trace("# tb_decls");
        for i in patterns'range loop
            din <= std_logic_vector(to_unsigned(patterns(i), 16));
            wait until falling_edge(clk);
            wait for 1 ns;
            trace(now_ns & " din=" & img(din) & " dout=" & img(dout));
        end loop;
        run <= false;
        wait;
    end process stim;

end architecture bench;
