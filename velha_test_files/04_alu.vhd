-- Rung 4: behavioural description.
-- Exercises: process with sensitivity list, process with WAIT forms,
-- variables vs signals, function and procedure in the declarative part,
-- if/elsif/else, case with range and choice-list alternatives, for/while/loop,
-- next/exit with labels, assertion and report, sequential signal assignment
-- with multiple waveform elements, concurrent procedure call.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
    generic (
        width : positive := 8   -- here you could try with different sizes to check that everything is working
    );
    port (
        clk    : in  std_logic;
        rst_n  : in  std_logic;
        opcode : in  std_logic_vector(2 downto 0);
        op_a   : in  std_logic_vector(width - 1 downto 0);
        op_b   : in  std_logic_vector(width - 1 downto 0);
        result : out std_logic_vector(width - 1 downto 0);
        zero   : out std_logic;
        parity : out std_logic
    );
end entity alu;

architecture behav of alu is

    -- Function declared in the architecture declarative part.
    function popcount (v : std_logic_vector) return natural is
        variable n : natural := 0;
    begin
        for i in v'range loop
            if v(i) = '1' then
                n := n + 1;
            end if;
        end loop;
        return n;
    end function popcount;

    -- Procedure with an inout parameter and a default-valued parameter.
    procedure saturate (
        signal   s       : out std_logic;
        constant value   : in  natural;
        constant thresh  : in  natural := 4
    ) is
    begin
        if value >= thresh then
            s <= '1';
        else
            s <= '0';
        end if;
    end procedure saturate;

    signal acc     : std_logic_vector(width - 1 downto 0) := (others => '0');
    signal nbits   : natural := 0;
    signal heartbeat : std_logic := '0';

begin

    -- Clocked process, sensitivity list form, asynchronous reset.
    regs : process (clk, rst_n)
        variable tmp   : unsigned(width - 1 downto 0);
        variable shamt : natural range 0 to width - 1;
    begin
        if rst_n = '0' then
            acc <= (others => '0');
        elsif clk'event and clk = '1' then

            shamt := to_integer(unsigned(op_b(2 downto 0)));

            case opcode is
                when "000" =>
                    tmp := unsigned(op_a) + unsigned(op_b);
                when "001" =>
                    tmp := unsigned(op_a) - unsigned(op_b);
                when "010" | "011" =>            -- choice list
                    tmp := unsigned(op_a and op_b);
                when "100" | "101" | "110" =>
                    tmp := shift_left(unsigned(op_a), shamt);
                when others =>
                    tmp := (others => '0');
            end case;

            -- Range choices are legal only on discrete types.
            case shamt is
                when 0          => null;
                when 1 to 3     => tmp := tmp + 1;
                when 4 to 7     => tmp := tmp - 1;
                when others     => null;
            end case;

            acc <= std_logic_vector(tmp);
        end if;
    end process regs;

    -- Combinational process, loop with next/exit and labels.
    flags : process (acc)
        variable n : natural;
    begin
        n    := 0;
        zero <= '1';

        scan : for i in acc'low to acc'high loop
            next scan when acc(i) = '0';
            n := n + 1;
            zero <= '0';
            exit scan when n > width / 2;
        end loop scan;

        nbits <= n;
        assert n <= width
            report "popcount out of range"
            severity failure;
    end process flags;

    -- Process with no sensitivity list, driven by WAIT statements.
    stimulus : process
        variable cycles : natural := 0;
    begin
        wait until rising_edge(clk);
        heartbeat <= '1', '0' after 5 ns;   -- multiple waveform elements

        while cycles < 3 loop
            wait for 10 ns;
            cycles := cycles + 1;
        end loop;

        loop                                -- bare loop + exit
            wait on rst_n;
            exit when rst_n = '1';
        end loop;

        report "stimulus complete" severity note;
        wait;                               -- suspend forever
    end process stimulus;

    -- Concurrent procedure call.
    saturate (parity, popcount(op_a), width / 2);

    result <= acc;

end architecture behav;
