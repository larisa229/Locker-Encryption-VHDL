library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity freqDividerCounter is
    Port (
        clk100 : in STD_LOGIC;
        clk1 : out STD_LOGIC
    );
end freqDividerCounter;

architecture Behavioral of freqDividerCounter is
begin
    process (clk100)
    variable clk_divizat : STD_LOGIC := '0'; 
    variable count : STD_LOGIC_VECTOR (26 downto 0) := (others => '0'); 
    begin
        if clk100'EVENT and clk100 = '1' then
            count := count + 1;
            if CONV_INTEGER(count) = 50_000_000 then
             count := (others => '0');
             clk_divizat := not clk_divizat;
            end if;
        end if;
      clk1 <= clk_divizat;
    end process;
end Behavioral;
