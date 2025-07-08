library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;  

entity clock_enable is
         port( clk: in std_logic;  -- INPUT CLOCK SIGNAL
               clk1: out std_logic  -- CLOCK ENABLE SIGNAL
              );
end clock_enable;

architecture Behavioral of clock_enable is
   signal counter: unsigned(26 downto 0) := (others => '0');  
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if counter = 10_000_000 then  -- WHEN THE COUNTER REACHES 10_000_000 WE RESET IT
                counter <= (others => '0'); 
            else
                counter <= counter + 1;  -- OTHERWISE WE KEEP INCREMENTING
            end if;
        end if;
    end process;

    clk1 <= '1' when counter = 10_000_000 else '0';  -- THE SLOW CLOCK ENABLE SIGNAL WILL BE 1 EACH TIME THE COUNTER REACHES 10_000_000
end Behavioral;
