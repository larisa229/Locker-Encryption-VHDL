library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity HoldRegister is
    Port ( clk : in STD_LOGIC;
           load : in STD_LOGIC;
           hold : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR(3 downto 0);
           data_out : out STD_LOGIC_VECTOR(3 downto 0));
end HoldRegister;

architecture Behavioral of HoldRegister is
    signal reg : STD_LOGIC_VECTOR(3 downto 0); -- INTERMEDIATE SIGNAL REGISTER
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if load = '1' then
                reg <= data_in;  -- IF THE SELECTED MODE IS LOAD WE LOAD THE NEW SIGNAL ON THE DATA INPUT
            elsif hold = '1' then
                reg <= reg;  -- IF THE SELECTED MODE IS HOLD WE HOLD THE LOADED INPUT
            end if;
        end if;
    end process;

-- THE OUTPUT TAKES THE VALUE OF THE INTERMEDIATE REGISTER SIGNAL
    data_out <= reg;
end Behavioral;
