library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ssdSpecial is
    Port ( clock : in STD_LOGIC;
           digit1 : in STD_LOGIC_VECTOR (3 downto 0);
           digit2 : in STD_LOGIC_VECTOR (3 downto 0);
           digit3 : in STD_LOGIC_VECTOR (3 downto 0);
           ca : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end ssdSpecial;

architecture Behavioral of ssdSpecial is

-- FREQUENCY DIVIDER COMPONENT
component freqDividerSSD is
    Port ( clk100 : in STD_LOGIC;
            clk1: out STD_LOGIC);
end component;

-- MUX ANODES COMPONENT
component MUX_an is
    Port ( sel : in STD_LOGIC_VECTOR (1 downto 0);
           data_out : out STD_LOGIC_VECTOR (3 downto 0));
end component;

-- MUX CATHODES COMPONENT
component MUX_ca is
    Port ( digit1 : in STD_LOGIC_VECTOR (3 downto 0); 
           digit2 : in STD_LOGIC_VECTOR (3 downto 0);
           digit3 : in STD_LOGIC_VECTOR (3 downto 0);
           sel : in STD_LOGIC_VECTOR (1 downto 0);
           data_out : out STD_LOGIC_VECTOR (3 downto 0));
end component;

-- DECODER HEXADECIMAL TO SSD
component HEX2Seg is
    Port ( hex : in STD_LOGIC_VECTOR (3 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0));
end component;

signal selection : STD_LOGIC_VECTOR (1 downto 0);
signal input_dcd : STD_LOGIC_VECTOR (3 downto 0);
signal clk_div : STD_LOGIC;

begin
-- DIVIDE THE FREQUENCY OF THE CLOCK
freq1: freqDividerSSD port map (clk100 => clock, clk1 => clk_div);
-- INSTANTIATE THE ANODES COMPONENT
c1: MUX_an port map (sel => selection, data_out => an);
-- INSTANTIATE THE CATHODES COMPONENT AND USE THE OUTPUT AS INPUT FOR THE DECODER
c2: MUX_ca port map (digit1 => digit1, digit2 => digit2, digit3 => digit3, sel => selection, data_out => input_dcd);
c3: HEX2Seg port map (hex => input_dcd, seg => ca);

process(clk_div)
  begin
    if(rising_edge(clk_div)) then
      selection <= selection + 1; -- UPDATE THE SELECTION ON THE RISING EDGE
     end if;
end process;
end Behavioral;
