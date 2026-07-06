library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.MATH_REAL.all;

entity sine_wave_440hz is
    port (
        clk : in std_logic;
        ce_48k : in std_logic;
        reset : in std_logic;
        audio_out : out std_logic_vector (23 downto 0)
    );
end sine_wave_440hz;

architecture Behavioral of sine_wave_440hz is
    -- We use a 16-bit counter to keep track of where we are in the wave.
    signal phase_acc : unsigned(15 downto 0) := (others => '0');

    -- Formula: Step = (Target_Hz * 2^Accumulator_Bits) / Sample_Rate
    -- Step = (440 * 65536) / 48000 = 600.74 (Round to 601)
    constant PHASE_STEP : unsigned(15 downto 0) := to_unsigned(601, 16);

    -- Define the Wheel (ROM type: 256 entries of 24-bit audio)
    type rom_type is array (0 to 255) of signed(23 downto 0);

    -- Calculates sine values during compilation
    impure function init_sine_rom return rom_type is
        variable temp_rom : rom_type;
        variable x : real;
        variable sin_val : real;
    begin
        for i in 0 to 255 loop
            -- Convert the 0-255 loop index into 0 to 2*Pi radians
            x := real(i) * 2.0 * MATH_PI / 256.0;
            sin_val := sin(x);
            -- Scale the decimal sine value (-1.0 to 1.0) into 24-bit integers.
            -- Max 24-bit signed value is roughly +/- 8,388,607
            temp_rom(i) := to_signed(integer(sin_val * 8388607.0), 24);
        end loop;
        return temp_rom;
    end function;

    -- Create the actual physical ROM memory and fill it using the function
    constant SINE_ROM : rom_type := init_sine_rom;

    -- Signal to hold the top 8 bits of the accumulator (our ROM address)
    signal rom_addr : integer range 0 to 255;

begin

    -- Grab the top 8 bits of the 16-bit pointer to use as the 256-entry ROM address
    rom_addr <= to_integer(phase_acc(15 downto 8));

    -- Output the audio sample from the ROM continuously
    audio_out <= std_logic_vector(SINE_ROM(rom_addr));

    -- Process to spin the pointer
    process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                phase_acc <= (others => '0');
            elsif ce_48k = '1' then
                -- Move the pointer forward by the step size every audio sample
                phase_acc <= phase_acc + PHASE_STEP;
            end if;
        end if;
    end process;

end Behavioral;