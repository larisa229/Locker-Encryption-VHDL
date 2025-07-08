library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity D_FF is
    Port ( D : in STD_LOGIC;
           EN : in STD_LOGIC;
           CLK : in STD_LOGIC;
           Q : out STD_LOGIC);
end D_FF;

architecture Behavioral of D_FF is
begin
    process (CLK)
    begin
       if (rising_edge(CLK)) then
           if EN = '1' then
                Q <= D;
           end if;
       end if;
    end process;
end Behavioral;
