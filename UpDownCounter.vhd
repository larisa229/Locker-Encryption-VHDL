library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity UpDownCounter is
    Port ( clock : in STD_LOGIC;
           UP : in STD_LOGIC;
           DOWN : in STD_LOGIC;
           SEG : out STD_LOGIC_VECTOR(6 downto 0));
end UpDownCounter;

architecture Behavioral of UpDownCounter is
    component debouncer is
      Port (BTN : in STD_LOGIC;
            CLK_DB : in STD_LOGIC; -- (CLK100)
            BTN_DB : out STD_LOGIC);
    end component;
    
    component freqDividerCounter is
        Port (clk100 : in STD_LOGIC;
              clk1 : out STD_LOGIC);
    end component;

    signal btn_up_db : STD_LOGIC;
    signal btn_down_db : STD_LOGIC;
    signal counter : unsigned(3 downto 0) := (others => '0');
    signal clk_div : STD_LOGIC;
    
begin
    freq1: freqDividerCounter port map (clk100 => clock, clk1 => clk_div);

    debouncer_up: debouncer port map (BTN => UP, CLK_DB => clk_div, BTN_DB => btn_up_db);
    debouncer_down: debouncer port map (BTN => DOWN, CLK_DB => clk_div, BTN_DB => btn_down_db);

    process(clk_div)
    begin
        if rising_edge(clk_div) then
            if btn_up_db = '1' then
                counter <= counter + 1;
            elsif btn_down_db = '1' then
                counter <= counter - 1;
            end if;
        end if;
    end process;

    process(counter)
    begin
        case to_integer(counter) is
            when 0 => SEG <= "1000000"; -- 0
            when 1 => SEG <= "1111001"; -- 1
            when 2 => SEG <= "0100100"; -- 2
            when 3 => SEG <= "0110000"; -- 3
            when 4 => SEG <= "0011001"; -- 4
            when 5 => SEG <= "0010010"; -- 5
            when 6 => SEG <= "0000010"; -- 6
            when 7 => SEG <= "1111000"; -- 7
            when 8 => SEG <= "0000000"; -- 8
            when 9 => SEG <= "0010000"; -- 9
            when 10 => SEG <= "0001000"; -- A
            when 11 => SEG <= "0000011"; -- B
            when 12 => SEG <= "1000110"; -- C
            when 13 => SEG <= "0100001"; -- D
            when 14 => SEG <= "0000110"; -- E
            when 15 => SEG <= "0001110"; -- F
            when others => SEG <= "1111111"; -- Display nothing for other values
        end case;
    end process;
end Behavioral;