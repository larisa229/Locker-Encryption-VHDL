library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity andGate3Inp is
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           c : in STD_LOGIC;
           y : out STD_LOGIC);
end andGate3Inp;

architecture Behavioral of andGate3Inp is

begin
y <= a and b and (not c);

end Behavioral;