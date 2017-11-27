# Project: BEL3 | WS2017 - VHDL Calculator

## Entitys
### Top Level Entity
  
The top-level module “calc_top” of the calculator consists of three sub-units named “io_ctrl”,  
“calc_ctrl” and “alu” which are described in the following. Table 3: Overview shows all I/Os of the top-level  
module “calc_top”.  
  
| Port Name     | Direction | Description                                                                                                 |
| ------------- |:---------:| ----------------------------------------------------------------------------------------------------------- |
| clk_i         | In        | System clock (100 MHz)                                                                                      |
| reset_i       | In        | Asynchronous high active reset (connected to push button BTNU)                                              |
| sw_i(15:0)    | In        | Connected to 16 switches SW0 - SW15                                                                         |
| pb_i(3:0)     | In        | Connected to 5 push buttons BTNL, BTNC, BTNR and BTND                                                       |
| ss_o(7:0)     | Out       | Contain the value for all four 7-segment digits (including the decimal point)                               |
| ss_sel_o(3:0) | Out       | Select one out of four 7-segment digits                                                                     |
| led_o(15:0)   | Out       | Connected to 16 LEDs                                                                                        |
  
### IO Control Unit Entity
  
The IO control unit “io_ctrl” controls all I/O ports (except the clock and the reset signal). It includes  
the multiplexer needed for the 7-segment digits, debounces the switches and push buttons and  
makes the debounced signals available for FPGA-internal logic on swsync_o(15:0) and  
pbsync_o(3:0). The IO control unit implements a generic interface for the I/O hardware of the  
Basys3 board. This means, that not all I/Os are used for the calculator project. For example, some  
of the LEDs are unused (see the distance learning letter “IO Control Unit” for details). Table 4: Overview  
shows all ports of the IO control unit.  
  
| Port Name      | Direction | Description                                                                                                |
| -------------- |:---------:| ---------------------------------------------------------------------------------------------------------- |
| clk_i          | In        | System clock (100 MHz)                                                                                     |
| reset_i        | In        | Asynchronous high active reset                                                                             |
| dig0_i(7:0)    | In        | State of 7 segments and decimal point of Digit 0 (from FPGA-internal logic)                                |
| dig1_i(7:0)    | In        | State of 7 segments and decimal point of Digit 1 (from FPGA-internal logic)                                |
| dig2_i(7:0)    | In        | State of 7 segments and decimal point of Digit 2 (from FPGA-internal logic)                                |
| dig3_i(7:0)    | In        | State of 7 segments and decimal point of Digit 3 (from FPGA-internal logic)                                |
| led_i(15:0)    | In        | State of 16 LEDs (from FPGA-internal logic)                                                                |
| sw_i(15:0)     | In        | State of 16 switches (from FPGA board)                                                                     |
| pb_i(7:0)      | In        | State of 4 push buttons (from FPGA board)                                                                  |
| ss_o(7:0)      | Out       | To 7-segment display of the FPGA board                                                                     |
| ss_sel_o(3:0)  | Out       | Selection of a 7-segment digit on the FPGA board                                                           |
| led_o(15:0)    | Out       | Connected to 16 LEDs of the FPGA board                                                                     |
| swsync_o(15:0) | Out       | State of 16 debounced switches (to FPGA-internal logic)                                                    |
| pbsync_o(3:0)  | Out       | State of 4 debounced push buttons (to FPGA-internal logic)                                                 |
  
### Calculator Control Unit Entity
  
The calculator control sub-unit “calc_ctrl” is the main control unit of the calculator. It provides the  
two operands OP1 and OP2 as well as the type of arithmetic/logic operation to the ALU (Arithmetic  
Logic Unit) and starts processing of an operation via signal “start_o”. Once the calculation is  
finished (indicated by the ALU via signal “finished_i”) the result of the calculation and the sign bit as  
well as special conditions like error or overflow will be evaluated and forwarded to the IO control  
unit. Table 5: Overview shows the ports of the calculator control unit while implementation details can be  
found in the distance learning letter “Calculator Control Unit”.  
  
| Port Name      | Direction | Description                                                                                                |
| -------------- |:---------:| ---------------------------------------------------------------------------------------------------------- |
| clk_i          | In        | System clock (100 MHz)                                                                                     |
| reset_i        | In        | Asynchronous high active reset                                                                             |
| swsync_i(15:0) | In        | State of 16 debounced switches (from IO control unit)                                                      |
| pbsync_i(15:0) | In        | State of 4 debounced push buttons (from IO control unit)                                                   |
| finished_i     | In        | ALU indicates that calculation of an arithmetic / logic operation is finished                              |
| result_i(15:0) | In        | 16-bit result of an arithmetic / logic operation coming from the ALU                                       |
| sign_i         | In        | Sign bit of the result (0 = positive, 1 = negative)                                                        |
| overflow_i     | In        | Indicates that the result of an operation exceeds 16 bits                                                  |
| error_i        | In        | Indicates that an error occurred during processing of the operation                                        |
| op1_o(11:0)    | Out       | Operand OP1 for the ALU                                                                                    |
| op2_o(11:0)    | Out       | Operand OP2 for the ALU                                                                                    |
| optype_o(3:0)  | Out       | Defines the type of arithmetic / logic operation for the ALU (Table 1: DSD1_Calculator_Overview)           |
| start_o        | Out       | Instructs the ALU to start a new calculation                                                               |
| dig0_o(7:0)    | Out       | State of 7 segments and decimal point of Digit 0 (to IO control unit)                                      |
| dig1_o(7:0)    | Out       | State of 7 segments and decimal point of Digit 1 (to IO control unit)                                      |
| dig2_o(7:0)    | Out       | State of 7 segments and decimal point of Digit 2 (to IO control unit)                                      |
| dig3_o(7:0)    | Out       | State of 7 segments and decimal point of Digit 3 (to IO control unit)                                      |
| led_o(15:0)    | Out       | State of 16 LEDs (to IO control unit)                                                                      |
  
### ALU Contorl Unit Entity
  
The arithmetic logic unit “alu” processes the selected arithmetic/logic operation. Table 6: Overview shows the  
ports of the ALU, implementation details can be found in the distance learning letter “Arithmetic  
Logic Unit”.  
  
| Port Name      | Direction | Description                                                                                                |
| -------------- |:---------:| ---------------------------------------------------------------------------------------------------------- |
| clk_i          | In        | System clock (100MHz)                                                                                      |
| reset_i        | In        | Asynchronous high acitive reset                                                                            |
| op1_i(11:0)    | In        | Operand OP1 from the Calculator Control Unit                                                               |
| op2_i(11:0)    | In        | Operand OP2 form the Calculator Control Unit                                                               |
| optype_i(3:0)  | In        | Type of arithmetic / logic operation (Table 1: DSD1_Calculator_Overview) from the Calculator Control Unit  |
| start_i        | In        | The Calculator Control Unit instructs the ALU to start a new calculation                                   |
| finished_o     | Out       | ALU indicates that calculation of an arithmetic / logic operation has finished                             |
| result_o(15:0) | Out       | 16-bit result of an arithmetic / logic operation for the Calculator Control Unit                           |
| sign_o         | Out       | Sign bit of the result of an operation exceeeds 16 bits                                                    |
| overflow_o     | Out       | Indicates that the result of an operation exceeds 16 bits                                                  |
| error_o        | Out       | Indicates that an error occurred during processing of the operation                                        |
  
The pin-out for the FPGA is shown in Table 7: Overview  
  
| Port Name                 | Pin | Feature      |
| ------------------------- |:---:| ------------ |
| clk_i                     | W5  | System Clock |
| reset_i                   | T18 | Button BTNU  |
| ss_sel_o(0)...ss_sel_o(3) |     |              |
| ss_o(0)...ss_o(7)         |     |              |
| sw_i(0)...sw_i(15)        |     |              |
| pb_i(0)...pb_i(3)         |     |              |
| led_o(0)...led_o(15)      |     |              |
  
Pin Description Printed on the Basys3 board and the schematics of the FPGA board (CIS website "FPGA Board Documentation")  

## ALU Calculations

**5 A** : Sub, Square Root, Logical AND, Rotate Left

| SW12 to SW15 | DISP1 | Operation   | Result of Operation                                                                                                                               |
|:------------:|:-----:|:-----------:| ------------------------------------------------------------------------------------------------------------------------------------------------- |
| 0001         | `Sub` | Sub         | OP1 - OP2                                                                                                                                         |
| 0110         | `Sro` | Square Root | Integer fraction of root(OP1) (value of OP2 will be ignored)                                                                                      |
| 1001         | `And` | Logical AND | Performs bit-wise AND of OP1 with OP2                                                                                                             |
| 1100         | `roL` | Rotate Left | OP1 will be shifted left by one bit position and the most significant bit of OP1 becomes the least significant bit (value of OP2 will be ignored) |

### User Interface: A

State 1: RESET => Left Digit of DISP1 shows "1"
* unsigned 12bit OP1
* change OP1 with SW0-SW11
  * changes are visible immediately on DISP1 in HEX
  
State 2: BTNL => Left Digit of DISP1 shows "2"
* unsigned 12bit OP2
* change OP2 with SW0-SW11
  * changes are visible immediately on DISP1 in HEX
  
State 3: BTNL => Left Digit of DISP1 shows "o"
* change arithmetic with SW12-SW15
* changes are visible immediately on DISP1
* all 16 LEDs are off
  
State 4: BTNL => DISP1 shows signed result (or error/overflow)
* LED15 is on if result is displayed
  
State 5: BTNL => Jump into State 1: RESET

