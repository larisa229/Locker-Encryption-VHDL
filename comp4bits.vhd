library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity comp4bits is
    Port ( a, b: in STD_LOGIC_VECTOR (3 downto 0);
           f_eq : out STD_LOGIC);
end comp4bits;

architecture comparator of comp4bits is

begin
 f_eq <= '1' when (a = b) -- CHECKS IF THE 2 NUMBERS ARE EQUAL
else '0';

end comparator;