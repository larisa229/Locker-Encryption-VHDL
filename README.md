# Digital Locker Encryption

### Project: Digital Locker with 3-digit PIN Setup and Verification  
### Language: VHDL (VHSIC Hardware Description Language)  
### Target Platform: FPGA (Xilinx Basys 3)

This VHDL project implements a secure digital locker system using
finite state machine (FSM) principles. It enables a user to:

1. Set a 3-digit PIN code using a counter.
2. Store the entered PIN using registers.
3. Lock the system after setting the PIN.
4. Enter a 3-digit PIN attempting to unlock.
5. Compare the entered PIN with the stored one and signal access.
6. It also provides a safety PIN that opens the locker at any time, in case of a forgotten PIN.

## Functionality

- **PIN Setup Phase**: 
  User presses `ADD_CYPHER` and uses `COUNT_UP/COUNT_DOWN` to set digits.
  The code is stored in registers using a debounced signal.

- **PIN Entry Phase**:
  After the code is set, pressing `ADD_DIGIT` allows PIN input.
  The digits are entered using the same counter and stored in another register.

- **PIN Check**:
  On completing the 3-digit input, the system compares the entered PIN
  with the stored code using 4-bit comparators.

- **Output Signals**:
  - `FREE_OCCUP`: LED signal indicates locker status (free/occupied).
  - `ENTER_CH`: LED indicates when to enter next character.
  - `SSD (ca, an)`: Displays current input or PIN setup digits.

- **Reset Options**:
  - `RESET_CYPHER`: Resets the code setup phase.
  - `RESET_PIN`: Resets the PIN entry phase.

- **Security**:
  Hardcoded comparison with "1111" to simulate an emergency override.


