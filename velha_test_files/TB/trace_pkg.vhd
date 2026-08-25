-- Trace helpers for the differential bench.
--
-- CRITICAL: everything here writes to STDOUT via std.textio, never via
-- 'report'. GHDL prefixes assertion output with "file:line:col:", and those
-- line numbers WILL differ between your hand-written source and whatever
-- your parser regenerates. Comparing report output would produce spurious
-- diffs. The bench captures stdout only and discards stderr.
library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;

package trace_pkg is

    function img (s : std_logic)                return string;
    function img (v : std_logic_vector)         return string;
    function img (b : boolean)                  return string;
    function img (i : integer)                  return string;

    -- Current simulation time in whole nanoseconds, as a plain integer.
    -- Avoids time'image, whose unit spelling is implementation-flavoured.
    function now_ns return string;

    procedure trace (s : string);

end package trace_pkg;

package body trace_pkg is

    function img (s : std_logic) return string is
        variable r : string(1 to 1);
    begin
        case s is
            when 'U' => r := "U";
            when 'X' => r := "X";
            when '0' => r := "0";
            when '1' => r := "1";
            when 'Z' => r := "Z";
            when 'W' => r := "W";
            when 'L' => r := "L";
            when 'H' => r := "H";
            when others => r := "-";
        end case;
        return r;
    end function img;

    function img (v : std_logic_vector) return string is
        variable r : string(1 to v'length);
        variable k : positive := 1;
    begin
        for i in v'range loop
            r(k to k) := img(v(i));
            k := k + 1;
        end loop;
        return r;
    end function img;

    function img (b : boolean) return string is
    begin
        if b then return "T"; else return "F"; end if;
    end function img;

    function img (i : integer) return string is
    begin
        return integer'image(i);
    end function img;

    function now_ns return string is
    begin
        return integer'image(now / 1 ns);
    end function now_ns;

    procedure trace (s : string) is
        variable l : line;
    begin
        write(l, s);
        writeline(output, l);
    end procedure trace;

end package body trace_pkg;
