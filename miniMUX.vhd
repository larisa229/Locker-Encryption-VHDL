library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX_ca is
    Port ( digit1 : in STD_LOGIC_VECTOR (3 downto 0);
           digit2 : in STD_LOGIC_VECTOR (3 downto 0);
           digit3 : in STD_LOGIC_VECTOR (3 downto 0);
           sel : in STD_LOGIC_VECTOR (1 downto 0);
           data_out : out STD_LOGIC_VECTOR (3 downto 0)); -- 4 BIT OUTPUT FOR THE DECODER
end MUX_ca;

architecture Behavioral of MUX_ca is

begin

process (sel, digit1, digit2, digit3)
begin
case sel is 
    when "00" =>
        data_out <= digit3; -- SELECT THE THIRD DIGIT
    when "01" =>
        data_out <= digit2; -- SELECT THE SECOND DIGIT
    when "10" =>
        data_out <= digit1; -- SELECT THE FIRST DIGIT
    when others =>
        data_out <= "0000";
    
end case;
end process;

end Behavioral;
