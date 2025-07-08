library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity debounce is
         port( button: in std_logic; -- BUTTON INPUT
               clk: in std_logic;
               debounced_button: out std_logic -- DEBOUNCED BUTTON OUTPUT
              );
end debounce;
architecture Behavioral of debounce is

signal clk1: std_logic; -- SLOW CLOCK SIGNAL
signal Q1,Q2,Q2B,Q0: std_logic; -- FLIP-FLOP OUTPUTS

-- CLOCK ENABLE COMPONENT
component clock_enable is
port(
 clk: in std_logic; 
   clk1: out std_logic);   
 end component;

-- D FLIP-FLOP COMPONENT
component DFF_Debouncing_Button is
    port(
     clk: in std_logic;
     clock_enable: in std_logic;
     D: in std_logic;
     Q: out std_logic:='0'
    );
 end component;

begin

Clock_enable_generator:clock_enable port map
      ( clk => clk,
        clk1 => clk1
      );
      
-- INSTANTIATE THE 3 D FLIP-FLOP COMPONENTS
D_FF0: DFF_Debouncing_Button port map 
      ( clk => clk,
        clock_enable => clk1,
        D => button,
        Q => Q0
      ); 
D_FF1:DFF_Debouncing_Button port map 
      ( clk => clk,
        clock_enable => clk1,
        D => Q0,
        Q => Q1
      );      
D_FF2: DFF_Debouncing_Button port map 
      ( clk => clk,
        clock_enable => clk1,
        D => Q1,
        Q => Q2
      ); 
 
 -- NEGATE THE OUTPUT OF THE THIRD FLIP-FLOP
 Q2B <= not Q2;
 -- GENERATE THE DEBOUNCED BUTTON SIGNAL
 debounced_button <= Q1 and Q2B;
 end Behavioral;