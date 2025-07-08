library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity freqDivider is
    Port ( clk100 : in STD_LOGIC;
            clk1: out STD_LOGIC);
end freqDivider;

architecture Division of freqDivider is
begin
process (clk100)
variable count: std_logic_vector (15 downto 0) := (others => '0');

begin
if clk100'event and clk100 = '1' then
    count := count + 1;
end if;
clk1 <= count(15);
end process;
end Division;