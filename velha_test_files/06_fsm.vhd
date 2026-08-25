-- Rung 6: finite state machines.
-- Exercises: enumeration type declaration, attribute declaration + attribute specification (the synthesis-encoding idiom), subtype of an enumeration,
-- 'val / 'pos / 'succ attributes, case over an enumeration, record types as state bundles, and the one-process vs two-process coding styles.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fsm_moore is
    port (
        clk    : in  std_logic;
        rst_n  : in  std_logic;
        start  : in  std_logic;
        ack    : in  std_logic;
        busy   : out std_logic;
        done   : out std_logic
    );
end entity fsm_moore;

architecture two_process of fsm_moore is

    type state_t is (IDLE, LOAD, RUN, WAIT_ACK, DONE_ST);

    -- Attribute declaration followed by an attribute specification.
    attribute enum_encoding : string;
    attribute enum_encoding of state_t : type is "000 001 011 010 110"; --IEEE 1076.6 (the RTL synthesis standard, 
	-- which is where enum_encoding was standardised) specifies that the attribute value is a string made up of 
	-- tokens separated by one or more spaces, with as many tokens as there are literals in the enumeration type, 
	-- the first token corresponding to the first literal and so on

    -- Subtype of an enumeration: constrains the range.
    subtype active_t is state_t range LOAD to WAIT_ACK;

    signal current, nxt : state_t;

begin

    -- State register.
    seq : process (clk, rst_n)
    begin
        if rst_n = '0' then
            current <= IDLE;
        elsif rising_edge(clk) then
            current <= nxt;
        end if;
    end process seq;

    -- Next-state logic.
    comb : process (current, start, ack)
    begin
        nxt <= current;                 -- default assignment

        case current is
            when IDLE =>
                if start = '1' then
                    nxt <= LOAD;
                end if;

            when LOAD =>
                nxt <= RUN;

            when RUN =>
                nxt <= WAIT_ACK;

            when WAIT_ACK =>
                if ack = '1' then
                    nxt <= DONE_ST;
                end if;

            when DONE_ST =>
                nxt <= IDLE;
        end case;
    end process comb;

    -- Moore outputs: functions of the state only.
    busy <= '1' when current /= IDLE and current /= DONE_ST else '0';
    done <= '1' when current = DONE_ST else '0';

end architecture two_process;

--------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fsm_mealy is
    generic (
        timeout : positive := 16
    );
    port (
        clk     : in  std_logic;
        rst_n   : in  std_logic;
        rx      : in  std_logic;
        valid   : out std_logic;
        expired : out std_logic;
        state_o : out std_logic_vector(1 downto 0)
    );
end entity fsm_mealy;

architecture one_process of fsm_mealy is

    type state_t is (S0, S1, S2, S3);

    -- Record bundling the whole register set: exercises record type
    -- declaration, record aggregate, and selected names on a signal.
    type reg_t is record
        st    : state_t;
        count : natural range 0 to timeout;
        seen  : std_logic_vector(2 downto 0);
    end record reg_t;

    constant RESET_REGS : reg_t := (
        st    => S0,
        count => 0,
        seen  => (others => '0')
    );

    signal r : reg_t := RESET_REGS;

begin

    main : process (clk, rst_n)
        variable v : reg_t;
    begin
        if rst_n = '0' then
            r <= RESET_REGS;
        elsif rising_edge(clk) then

            v := r;                                 -- record variable copy
            v.seen  := v.seen(1 downto 0) & rx;     -- slice + concatenation
            valid   <= '0';

            case v.st is
                when S0 =>
                    if rx = '1' then
                        v.st  := S1;
                        valid <= '1';               -- Mealy: depends on input
                    end if;

                when S1 =>
                    v.st := S2;

                when S2 =>
                    if rx = '0' then
                        v.st := S0;
                    else
                        v.st := S3;
                    end if;

                when S3 =>
                    -- 'succ / 'pos / 'val attributes on an enumeration.
                    if v.count = timeout then
                        v.st    := state_t'val(0);
                        v.count := 0;
                    else
                        v.count := v.count + 1;
                    end if;
            end case;

            r <= v;
        end if;
    end process main;

    expired <= '1' when r.count = timeout else '0';
    state_o <= std_logic_vector(to_unsigned(state_t'pos(r.st), 2));

end architecture one_process;
