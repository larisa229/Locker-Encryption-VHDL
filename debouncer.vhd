library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity debouncer is
  Port (BTN : in STD_LOGIC;
        CLK_DB : in STD_LOGIC; -- (CLK100)
        BTN_DB : out STD_LOGIC
   );
end debouncer;

architecture Behavioral of debouncer is

component freqDivider is
    Port (
        clk100 : in STD_LOGIC;
        clk1 : out STD_LOGIC
    );
end component;

component D_FF is
    Port ( D : in STD_LOGIC;
           EN : in STD_LOGIC;
           CLK : in STD_LOGIC;
           Q : out STD_LOGIC);
end component;

component andGate3Inp is
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           c : in STD_LOGIC;
           y : out STD_LOGIC);
end component;

-- Intermediate signals
signal int_clk : STD_LOGIC;
signal int1 : STD_LOGIC;
signal int2 : STD_LOGIC;
signal int3 : STD_LOGIC;

begin

freq1: freqDivider port map (clk100 => CLK_DB, clk1 => int_clk);
dff1: D_FF port map (D => BTN, EN => int_clk, CLK => CLK_DB, Q => int1);
dff2: D_FF port map (D => int1, EN => '1', CLK => CLK_DB, Q => int2);
dff3: D_FF port map (D => int2, EN => '1', CLK => CLK_DB, Q => int3);
andgate1: andGate3Inp port map (a => int1, b => int2, c => int3, y => BTN_DB);

end Behavioral;
