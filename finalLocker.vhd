
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity finalLocker is
    Port ( ADD_DIGIT : in STD_LOGIC;
           ADD_CYPHER : in STD_LOGIC;
           COUNT_UP : in STD_LOGIC;
           COUNT_DOWN : in STD_LOGIC;
           RESET_CYPHER : in STD_LOGIC;
           RESET_PIN : in STD_LOGIC;
           CLK : in STD_LOGIC;
           FREE_OCCUP : out STD_LOGIC;
           ENTER_CH : out STD_LOGIC;
           ca : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0)
         );
end finalLocker;

architecture Behavioral of finalLocker is

-- THE FREQUENCY DIVIDER COMPONENT
component freqDividerCounter is
    Port (
        clk100 : in STD_LOGIC;
        clk1 : out STD_LOGIC
    );
end component;

-- COMPARATOR ON 4 BITS TO COMPARE THE DIGITS OF THE PINS
component comp4bits is
    Port ( a, b: in STD_LOGIC_VECTOR (3 downto 0);
           f_eq : out STD_LOGIC);
end component;

-- DEBOUNCER MONOIMPULSE FOR THE ADD_DIGIT AND ADD_CYPHER BUTTONS
component debounce is
    Port( button: in STD_LOGIC;
          clk: in STD_LOGIC;
          debounced_button: out STD_LOGIC);
end component;

-- SSD DISPLAY DIFFERENT DIGITS ON DIFFERENT POSITIONS
component ssdSpecial is
    Port ( clock : in STD_LOGIC;
           digit1 : in STD_LOGIC_VECTOR (3 downto 0);
           digit2 : in STD_LOGIC_VECTOR (3 downto 0);
           digit3 : in STD_LOGIC_VECTOR (3 downto 0);
           ca : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end component;

-- COUNTER TO GO UP AND DOWN WHEN SETTING THE PIN
component UpDownCounter is
    Port ( clock : in STD_LOGIC;
           UP : in STD_LOGIC;
           DOWN : in STD_LOGIC;
           RST : in STD_LOGIC;
           SEG : out STD_LOGIC_VECTOR(3 downto 0));
end component;

-- REGISTER TO LOAD AND HOLD THE PINS FOR LATER COMPARISON
component HoldRegister is
    Port ( clk : in STD_LOGIC;
           load : in STD_LOGIC;
           hold : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR(3 downto 0);
           data_out : out STD_LOGIC_VECTOR(3 downto 0));
end component;

type state is (StandBy, SetCypher1, SetCypher2, SetCypher3, CypherAdded, TryPin1, TryPin2, TryPin3, CheckPin); -- STATES DEFINITION
signal current_state, next_state : state;
signal ADD_CYPHER_DB, ADD_DIGIT_DB : STD_LOGIC; -- THE ADD_DIGIT AND ADD_CYPHER BUTTONS DEBOUNCED
signal EqualPins : STD_LOGIC;  -- THE RESULT OF THE PIN COMPARISON
signal CODE : STD_LOGIC_VECTOR(3 DOWNTO 0); -- THE CURRENT VALUE OF A DIGIT IN THE PIN
  -- INTERMEDIATE SIGNALS FOR THE DIGITS HOLD IN THE REGISTERS
signal int_digit1, int_digit2, int_digit3, int_digit4, int_digit5, int_digit6 : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
  -- INTERMEDIATE HOLD, LOAD AND DATA INPUTS SIGNALS FOR THE REGISTERS
signal sig_load1, sig_load2, sig_load3, sig_load4, sig_load5, sig_load6 : STD_LOGIC := '0';
signal sig_hold1, sig_hold2, sig_hold3, sig_hold4, sig_hold5, sig_hold6 : STD_LOGIC := '0';
signal sig_data1, sig_data2, sig_data3, sig_data4, sig_data5, sig_data6 : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
  -- SIGNALS FOR THE COMPARISON RESULTS
signal eq1, eq2, eq3, eq4, eq5, eq6 : STD_LOGIC;
  -- SIGNALS FOR THE SSD INPUTS
signal digit1, digit2, digit3 : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
signal int_reset : STD_LOGIC := '0';  -- RESET INTERMEDIATE SIGNAL
signal CLK1 : STD_LOGIC;  -- SIGNAL FOR THE DIVIDED CLOCK 
begin

-- DIVIDE CLOCK FREQUENCY
freq1: freqDividerCounter port map (clk100 => CLK, clk1 => CLK1);

-- DEBOUNCE ADD_CYPHER AND ADD_DIGIT BUTTONS
debouncerCypher: debounce port map(button => ADD_CYPHER, clk => CLK, debounced_button => ADD_CYPHER_DB);
debouncerPin: debounce port map(button => ADD_DIGIT, clk => CLK, debounced_button => ADD_DIGIT_DB);

-- INSTANTIATE COUNTER UP AND DOWN
CNTR: UpDownCounter port map(clock => CLK, UP => COUNT_UP, DOWN => COUNT_DOWN, RST => int_reset, SEG => CODE);

-- INSTANTIATE THE 6 REGISTERS FOR BOTH 3-DIGIT PINS
regDigit1 : HoldRegister port map (clk => CLK1, load => sig_load1, hold => sig_hold1, data_in => sig_data1, data_out => int_digit1);
regDigit2 : HoldRegister port map (clk => CLK1, load => sig_load2, hold => sig_hold2, data_in => sig_data2, data_out => int_digit2);
regDigit3 : HoldRegister port map (clk => CLK1, load => sig_load3, hold => sig_hold3, data_in => sig_data3, data_out => int_digit3);
regDigit4 : HoldRegister port map (clk => CLK1, load => sig_load4, hold => sig_hold4, data_in => sig_data4, data_out => int_digit4);
regDigit5 : HoldRegister port map (clk => CLK1, load => sig_load5, hold => sig_hold5, data_in => sig_data5, data_out => int_digit5);
regDigit6 : HoldRegister port map (clk => CLK1, load => sig_load6, hold => sig_hold6, data_in => sig_data6, data_out => int_digit6);

-- INSTANTIATE 6 COMPARATORS
-- FIRST 3 COMPARE THE 2 PINS
compDigit1 : comp4bits port map (a => int_digit1, b=> int_digit4, f_eq => eq1);
compDigit2 : comp4bits port map (a => int_digit2, b=> int_digit5, f_eq => eq2);
compDigit3 : comp4bits port map (a => int_digit3, b=> int_digit6, f_eq => eq3);

 -- NEXT 3 COMPARE THE PIN INTRODUCED WITH THE SAFETY CODE WHICH WAS SET TO "1111"
compDigit4 : comp4bits port map (a => "1111", b=> int_digit4, f_eq => eq4);
compDigit5 : comp4bits port map (a => "1111", b=> int_digit5, f_eq => eq5);
compDigit6 : comp4bits port map (a => "1111", b=> int_digit6, f_eq => eq6);

 -- INSTANTIATE SSD DISPLAY
display : ssdSpecial port map (clock => CLK, digit1 => digit1, digit2 => digit2, digit3 => digit3, ca => ca, an => an);

-- CLOCK PROCCES TO GO FROM THE CURRENT STATE TO THE NEXT
 clock: process(CLK1)
 begin
   if rising_edge(CLK1) then
      current_state <= next_state;
   end if;
 end process;
 
 -- TRANSITIONS BETWEEN STATES
 transitions: process(current_state, ADD_CYPHER_DB, ADD_DIGIT_DB, RESET_CYPHER, RESET_PIN, EqualPins)
 begin
 case current_state is
   when StandBy => if ADD_CYPHER_DB = '1' then  -- IF ADD_CYPHER IS PRESSED THE USER CAN START SETTING THE CYPHER
                      next_state <= SetCypher1;  
                   else next_state <= StandBy;
                   end if;
   when SetCypher1 => if RESET_CYPHER = '1' then  -- THERE IS THE POSSIBILITY TO RESET THE SETTING OF THE CYPHER
                        next_state <= StandBy;
                      elsif ADD_CYPHER_DB = '1' then -- IF ADD_CYPHER IS PRESSED, MOVE TO THE SECOND DIGIT
                        next_state <= SetCypher2;  
                      else next_state <= SetCypher1;
                      end if;
   when SetCypher2 => if RESET_CYPHER = '1' then
                        next_state <= StandBy;
                   elsif ADD_CYPHER_DB = '1' then  -- IF ADD_CYPHER IS PRESSED, MOVE TO THE THIRD DIGIT
                      next_state <= SetCypher3;  
                   else next_state <= SetCypher2;
                   end if;
   when SetCypher3 => if RESET_CYPHER = '1' then
                        next_state <= StandBy;
                   elsif ADD_CYPHER_DB = '1' then  -- IF ADD_CYPHER IS PRESSED, THE CYPHER IS SET
                      next_state <= CypherAdded;  
                   else next_state <= SetCypher3;
                   end if;
   when CypherAdded => if RESET_CYPHER = '1' then
                        next_state <= StandBy;
                   elsif ADD_DIGIT_DB = '1' then   -- IF ADD_DIGIT IS PRESSED, THE USER CAN START ENTERING THE PIN TO OPEN THE LOCKER
                      next_state <= TryPin1;  
                   else next_state <= CypherAdded;
                   end if;
   when TryPin1 => if RESET_PIN = '1' then  -- THE RESET_PIN CAUSES A RETURN TO THE STATE AFTER THE CYPHER IS SET
                        next_state <= CypherAdded;
                   elsif ADD_DIGIT_DB = '1' then  -- IF ADD_DIGIT IS PRESSED, MOVE TO THE SECOND DIGIT
                      next_state <= TryPin2;  
                   else next_state <= TryPin1;
                   end if;
    when TryPin2 => if RESET_PIN = '1' then
                        next_state <= CypherAdded;
                   elsif ADD_DIGIT_DB = '1' then  -- IF ADD_DIGIT IS PRESSED, MOVE TO THE SECOND DIGIT
                      next_state <= TryPin3;  
                   else next_state <= TryPin2;
                   end if; 
   when TryPin3 => if RESET_PIN = '1' then
                        next_state <= CypherAdded;
                   elsif ADD_DIGIT_DB = '1' then  -- IF ADD_DIGIT IS PRESSED, CHECK IF THE PIN IS CORRECT
                      next_state <= CheckPin;  
                   else next_state <= TryPin3;
                   end if;    
    when CheckPin => if EqualPins = '1' then -- IF THE PINS ARE EQUAL RETURN TO THE INITIAL STATE, RESET THE LOCKER FOR THE NEXT USE
                       next_state <= StandBy;
                     else next_state <= CypherAdded; -- IF THE PIN IS NOT CORRECT RETURN TO THE CYPHERADDED STATE AND TRY AGAIN
                     end if;     
    when others => next_state <= StandBy;                          
  end case;          
 end process;
 
 -- OUTPUTS DESCRIPTION (FREE-OCCUPIED AND ENTER CHARACTER LEDS)
 Outputs_process:
 process (current_state, ADD_CYPHER_DB, ADD_DIGIT_DB, EqualPins)
   begin
    case current_state is
     when Standby => FREE_OCCUP <= '0'; -- IN STANDBY BOTH LEDS ARE OFF
                     ENTER_CH <= '0';
     -- WHILE THE CYPHER IS BEING SET THE ENTER CHARACTER LED IS ON            
     when SetCypher1 => FREE_OCCUP <= '0'; 
                         ENTER_CH <= '1';    
     when SetCypher2 => FREE_OCCUP <= '0';
                        ENTER_CH <= '1';         
     when SetCypher3 => FREE_OCCUP <= '0';
                        ENTER_CH <= '1';
     -- AFTER THE CYPHER HAS BEEN SET THE FREE_OCCUP LET TURNS ON TO SIGNAL THAT THE LOCKER IS OCCUPIED     
     -- THE ENTER CHARACTER LED TURNS OFF              
     when CypherAdded => FREE_OCCUP <= '1';
                         ENTER_CH <= '0';
     -- WHILE THE PIN IS BEING INTRODUCED BOTH LEDS STAY ON                   
     when TryPin1 => FREE_OCCUP <= '1';
                     ENTER_CH <= '1';
     when TryPin2 => FREE_OCCUP <= '1';
                     ENTER_CH <= '1';   
     when TryPin3 => FREE_OCCUP <= '1';
                     ENTER_CH <= '1';
     when CheckPin => if EqualPins = '1' then  -- IF THE PINS ARE EQUAL BOTH LEDS TURN ON BECAUSE THE LOCKER IS FREE AGAIN
                        FREE_OCCUP <= '0';
                        ENTER_CH <= '0';
                      else 
                        FREE_OCCUP <= '1'; -- OTHERWISE THE FREE-OCCUPIED LED REMAINS ON BECAUSE THE LOCKER WAS NOT OPENED
                        ENTER_CH <= '0';
                      end if;
     -- DEFAULT: LEDS OFF                 
     when others => FREE_OCCUP <= '0';
                    ENTER_CH <= '0';    
    end case;
 end process;
 
 -- PUTTING THE COMPONENTS TOGETHER
Functionalities:
process (current_state, eq1, eq2, eq3, eq4, eq5, eq6, int_digit1, int_digit2, int_digit3, int_digit4, int_digit5, int_digit6, CODE)
begin
-- DEPENDING ON THE STATE WE WILL LOAD THE REGISTERS
    case current_state is
    -- IN STANDBY EVERYTHING IS INITIALIZED
        when Standby => 
            sig_load1 <= '0'; sig_load2 <= '0'; sig_load3 <= '0'; sig_load4 <= '0'; sig_load5 <= '0'; sig_load6 <= '0'; 
            sig_hold1 <= '0'; sig_hold2 <= '0'; sig_hold3 <= '0'; sig_hold4 <= '0'; sig_hold5 <= '0'; sig_hold6 <= '0';
            sig_data1 <= "0000"; sig_data2 <= "0000"; sig_data3 <= "0000"; sig_data4 <= "0000"; sig_data5 <= "0000"; sig_data6 <= "0000";
            digit1 <= "0000"; digit2 <= "0000"; digit3 <= "0000";
            int_reset <= '1';
    -- WE DISPLAY THE OUTPUT OF THE COUNTER ON THE SSD AND LOAD IT INTO THE FIRST REGISTER 
        when SetCypher1 => 
            sig_data1 <= CODE; sig_data2 <= "0000"; sig_data3 <= "0000"; sig_data4 <= "0000"; sig_data5 <= "0000"; sig_data6 <= "0000";
            sig_load1 <= '1'; sig_load2 <= '0'; sig_load3 <= '0'; sig_load4 <= '0'; sig_load5 <= '0'; sig_load6 <= '0';
            sig_hold1 <= '0'; sig_hold2 <= '0'; sig_hold3 <= '0'; sig_hold4 <= '0'; sig_hold5 <= '0'; sig_hold6 <= '0';
            digit1 <= CODE; digit2 <= "0000"; digit3 <= "0000";
            int_reset <= '0';
    -- WE HOLD THE FIRST DIGIT, WE DISPLAY THE OUTPUT OF THE COUNTER ON ANOTHER POSITION OF THE SSD AND LOAD IT INTO THE SECOND REGISTER       
        when SetCypher2 => 
            sig_hold1 <= '1'; sig_hold2 <= '0'; sig_hold3 <= '0'; sig_hold4 <= '0'; sig_hold5 <= '0'; sig_hold6 <= '0';
            sig_load1 <= '0'; sig_load2 <= '1'; sig_load3 <= '0'; sig_load4 <= '0'; sig_load5 <= '0'; sig_load6 <= '0';
            sig_data1 <= "0000"; sig_data2 <= CODE; sig_data3 <= "0000"; sig_data4 <= "0000"; sig_data5 <= "0000"; sig_data6 <= "0000";
            digit1 <= int_digit1; digit2 <= CODE; digit3 <= "0000";
            int_reset <= '0';
     -- HOLD THE FIRST 2 DIGITS, DISPLAY THE COUNTER OUTPUT ON ANOTHER POSITION AND LOAD IT TO THE THIRD REGISTER              
        when SetCypher3 => 
            sig_load1 <= '0'; sig_load2 <= '0'; sig_load3 <= '1'; sig_load4 <= '0'; sig_load5 <= '0'; sig_load6 <= '0';
            sig_hold1 <= '1'; sig_hold2 <= '1'; sig_hold3 <= '0'; sig_hold4 <= '0'; sig_hold5 <= '0'; sig_hold6 <= '0';
            sig_data1 <= "0000"; sig_data2 <= "0000"; sig_data3 <= CODE; sig_data4 <= "0000"; sig_data5 <= "0000"; sig_data6 <= "0000";
            digit1 <= int_digit1; digit2 <= int_digit2; digit3 <= CODE;
      -- HOLD ALL 3 DIGITS AND RESET THE COUNTER AND SSD             
        when CypherAdded => 
            sig_load1 <= '0'; sig_load2 <= '0'; sig_load3 <= '0'; sig_load4 <= '0'; sig_load5 <= '0'; sig_load6 <= '0';
            sig_hold1 <= '1'; sig_hold2 <= '1'; sig_hold3 <= '1'; sig_hold4 <= '0'; sig_hold5 <= '0'; sig_hold6 <= '0';                  
            digit1 <= "0000"; digit2 <= "0000"; digit3 <= "0000";
            int_reset <= '1';
      -- WE DISPLAY THE OUTPUT OF THE COUNTER ON THE SSD AND LOAD IT INTO THE FOURTH REGISTER        
        when TryPin1 => 
            int_reset <= '0';
            sig_load1 <= '0'; sig_load2 <= '0'; sig_load3 <= '0'; sig_load4 <= '1'; sig_load5 <= '0'; sig_load6 <= '0'; 
            sig_hold1 <= '1'; sig_hold2 <= '1'; sig_hold3 <= '1'; sig_hold4 <= '0'; sig_hold5 <= '0'; sig_hold6 <= '0';  
            sig_data1 <= "0000"; sig_data2 <= "0000"; sig_data3 <= "0000"; sig_data4 <= CODE; sig_data5 <= "0000"; sig_data6 <= "0000"; 
            digit1 <= CODE; digit2 <= "0000"; digit3 <= "0000";
       -- WE HOLD THE FIRST DIGIT, WE DISPLAY THE OUTPUT OF THE COUNTER ON ANOTHER POSITION OF THE SSD AND LOAD IT INTO THE FIFTH REGISTER        
        when TryPin2 => 
            int_reset <= '0';
            sig_load1 <= '0'; sig_load2 <= '0'; sig_load3 <= '0'; sig_load4 <= '0'; sig_load5 <= '1'; sig_load6 <= '0'; 
            sig_hold1 <= '1'; sig_hold2 <= '1'; sig_hold3 <= '1'; sig_hold4 <= '1'; sig_hold5 <= '0'; sig_hold6 <= '0';  
            sig_data1 <= "0000"; sig_data2 <= "0000"; sig_data3 <= "0000"; sig_data4 <= "0000"; sig_data5 <= CODE; sig_data6 <= "0000"; 
            digit1 <= int_digit4; digit2 <= CODE; digit3 <= "0000";
        -- HOLD THE FIRST 2 DIGITS, DISPLAY THE COUNTER OUTPUT ON ANOTHER POSITION AND LOAD IT TO THE SIXTH REGISTER         
        when TryPin3 => 
            int_reset <= '0';
            sig_load1 <= '0'; sig_load2 <= '0'; sig_load3 <= '0'; sig_load4 <= '0'; sig_load5 <= '0'; sig_load6 <= '1'; 
            sig_hold1 <= '1'; sig_hold2 <= '1'; sig_hold3 <= '1'; sig_hold4 <= '1'; sig_hold5 <= '1'; sig_hold6 <= '0';  
            sig_data1 <= "0000"; sig_data2 <= "0000"; sig_data3 <= "0000"; sig_data4 <= "0000"; sig_data5 <= "0000"; sig_data6 <= CODE; 
            digit1 <= int_digit4; digit2 <= int_digit5; digit3 <= CODE;
         -- HOLD ALL 3 DIGITS, RESET THE COUNTER AND SSD AND COMPARE THE PINS     
        when CheckPin => 
            sig_load1 <= '0'; sig_load2 <= '0'; sig_load3 <= '0'; sig_load4 <= '0'; sig_load5 <= '0'; sig_load6 <= '0'; 
            sig_hold1 <= '1'; sig_hold2 <= '1'; sig_hold3 <= '1'; sig_hold4 <= '1'; sig_hold5 <= '1'; sig_hold6 <= '1'; 
            if (eq1 = '1' and eq2 = '1' and eq3 = '1') or (eq4 = '1' and eq5 = '1' and eq6 = '1') then
                EqualPins <= '1';
            else
                EqualPins <= '0';
            end if;
            int_reset <= '1';
    end case;
end process;

end Behavioral;

