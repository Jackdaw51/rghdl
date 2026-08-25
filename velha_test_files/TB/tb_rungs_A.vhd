-- Testbenches for rungs 1 and 2.
--
-- Design rules used throughout the bench, all aimed at making the trace a
-- deterministic function of the DESIGN SEMANTICS and nothing else:
--
--   * Stimulus is applied at fixed absolute times with 'wait for', never
--     derived from a free-running clock inside the DUT.
--   * Outputs are sampled at an offset from the stimulus edge, after all
--     delta cycles and all 'after' delays have settled. If your parser
--     reorders concurrent statements, delta ordering can change; sampling
--     late makes the trace insensitive to that while still catching real
--     semantic differences.
--   * Every TB ends with an explicit 'wait;' so the run terminates without
--     needing --stop-time.

library ieee;
use ieee.std_logic_1164.all;
use work.trace_pkg.all;

entity tb_nand2 is
end entity tb_nand2;

architecture bench of tb_nand2 is
    signal a, b, y : std_logic := '0';
begin
    --adjust name
    dut : entity work.nand2      
        generic map (tpd => 1 ns)
        port map (a => a, b => b, y => y);

    stim : process
        type pair_t is array (0 to 3) of std_logic_vector(1 downto 0);
        constant vectors : pair_t := ("00", "01", "10", "11");
    begin
        trace("# tb_nand2");
        for i in vectors'range loop
            a <= vectors(i)(1);
            b <= vectors(i)(0);
            wait for 10 ns;                     -- well past tpd
            trace(now_ns & " a=" & img(a) & " b=" & img(b) & " y=" & img(y));
        end loop;
        wait;
    end process stim;

end architecture bench;

--------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.trace_pkg.all;

entity tb_primitives is
end entity tb_primitives;

architecture bench of tb_primitives is
    signal a, b            : std_logic := '0';
    signal y_inv, y_and    : std_logic;
    signal y_or            : std_logic;
    signal y_xor_rtl       : std_logic;
    signal y_xor_gate      : std_logic;
begin

    u_inv : entity work.inv  port map (a => a, y => y_inv);
    u_and : entity work.and2 port map (a => a, b => b, y => y_and);
    u_or  : entity work.or2  port map (a => a, b => b, y => y_or);

    -- Both architectures of xor2 instantiated side by side. If your
    -- elaborator collapses the two architectures into one, this diverges.
    u_x_rtl  : entity work.xor2(rtl)        port map (a => a, b => b, y => y_xor_rtl);
    u_x_gate : entity work.xor2(gate_level) port map (a => a, b => b, y => y_xor_gate);

    stim : process
    begin
        trace("# tb_primitives");
        for ia in 0 to 1 loop
            for ib in 0 to 1 loop
                if ia = 0 then a <= '0'; else a <= '1'; end if;
                if ib = 0 then b <= '0'; else b <= '1'; end if;
                wait for 10 ns;
                trace(now_ns
                      & " a=" & img(a) & " b=" & img(b)
                      & " inv=" & img(y_inv)
                      & " and=" & img(y_and)
                      & " or="  & img(y_or)
                      & " xr="  & img(y_xor_rtl)
                      & " xg="  & img(y_xor_gate));
            end loop;
        end loop;
        wait;
    end process stim;

end architecture bench;

--------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.trace_pkg.all;

entity tb_adders is
end entity tb_adders;

architecture bench of tb_adders is
    signal x, y  : std_logic_vector(7 downto 0) := (others => '0');
    signal carry : std_logic := '0';
    signal z     : std_logic_vector(7 downto 0);
    signal ovf   : std_logic;
begin

    dut : entity work.adder_top
        port map (x => x, y => y, carry => carry, z => z, ovf => ovf);

    stim : process
        -- Deliberately includes carry propagation across the whole width,
        -- which is what exercises the for-generate chain.
        type vec_t is array (natural range <>) of integer;
        constant xs : vec_t := (0,   1, 255, 128,  85, 255, 15,  7);
        constant ys : vec_t := (0, 254,   1, 128, 170,   0,  1, 248);
        constant cs : vec_t := (0,   0,   0,   0,   0,   1,  1,  1);
    begin
        trace("# tb_adders");
        for i in xs'range loop
            x     <= std_logic_vector(to_unsigned(xs(i), 8));
            y     <= std_logic_vector(to_unsigned(ys(i), 8));
            if cs(i) = 1 then carry <= '1'; else carry <= '0'; end if;
            wait for 20 ns;
            trace(now_ns
                  & " x=" & img(x) & " y=" & img(y) & " c=" & img(carry)
                  & " z=" & img(z) & " ovf=" & img(ovf));
        end loop;
        wait;
    end process stim;

end architecture bench;
