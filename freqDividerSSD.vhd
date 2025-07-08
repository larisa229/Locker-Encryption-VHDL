library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity freqDividerSSD is
    Port ( clk100 : in STD_LOGIC;
            clk1: out STD_LOGIC);
end freqDividerSSD;

architecture Division of freqDividerSSD is
signal count: std_logic_vector (16 downto 0) := (others => '0');
begin
process (clk100)

begin
if rising_edge(clk100)  then
    count <= count + 1;
end if;
end process;
clk1 <= count(16);
end Division;
