library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX_an is
    Port ( sel : in STD_LOGIC_VECTOR (1 downto 0);
           data_out : out STD_LOGIC_VECTOR (3 downto 0)); -- 4 bit output for anodes
end MUX_an;

architecture Behavioral of MUX_an is

begin

process (sel)
begin
case sel is 
    when "00" =>
        data_out <= "1110"; -- ENABLE FIRST ANODE
    when "01" =>
        data_out <= "1101"; -- ENABLE SECOND ANODE
    when "10" =>
        data_out <= "1011"; -- ENABLE THIRD ANODE
    when others =>
        data_out <= "1111"; -- DISABLE THE OTHER ANODE
end case;
end process;

end Behavioral;
