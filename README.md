# Project: BEL3 | WS2017 - VHDL Calculator

## Entitys
### Top Level Entity

| Port Name     | Direction | Description                                                                      |
| ------------- |:---------:| -------------------------------------------------------------------------------- |
| clk_i         | In        | System clock (100 MHz)                                                           |
| reset_i       | In        | Asynchronous high active reset (connected to push button BTNU)                   |
| sw_i(15:0)    | In        | Connected to 16 switches SW0 - SW15                                              |
| pb_i(3:0)     | In        | Connected to 5 push buttons BTNL, BTNC, BTNR and BTND                            |
| ss_o(7:0)     | Out       | Contain the value for all four 7-segment digits (including the decimal point)    |
| ss_sel_o(3:0) | Out       | Select one out of four 7-segment digits                                          |
| led_o(15:0)   | Out       | Connected to 16 LEDs                                                             |

### IO Control Unit Entity

| Port Name      | Direction | Description                                                                      |
| -------------- |:---------:| -------------------------------------------------------------------------------- |
| clk_i          | In        | System clock (100 MHz)                                                           |
| reset_i        | In        | Asynchronous high active reset                                                   |
| dig0_i(7:0)    | In        | State of 7 segments and decimal point of Digit 0 (from FPGA-internal logic)      |
| dig1_i(7:0)    | In        | State of 7 segments and decimal point of Digit 1 (from FPGA-internal logic)      |
| dig2_i(7:0)    | In        | State of 7 segments and decimal point of Digit 2 (from FPGA-internal logic)      |
| dig3_i(7:0)    | In        | State of 7 segments and decimal point of Digit 3 (from FPGA-internal logic)      |
| led_i(15:0)    | In        | State of 16 LEDs (from FPGA-internal logic)                                      |
| sw_i(15:0)     | In        | State of 16 switches (from FPGA board)                                           |
| pb_i(7:0)      | In        | State of 4 push buttons (from FPGA board)                                        |
| ss_o(7:0)      | Out       | To 7-segment display of the FPGA board                                           |
| ss_sel_o(3:0)  | Out       | Selection of a 7-segment digit on the FPGA board                                 |
| led_o(15:0)    | Out       | Connected to 16 LEDs of the FPGA board                                           |
| swsync_o(15:0) | Out       | State of 16 debounced switches (to FPGA-internal logic)                          |
| pbsync_o(3:0)  | Out       | State of 4 debounced push buttons (to FPGA-internal logic)                       |

### Calculator Control Unit Entity


| Port Name      | Direction | Description                                                                                      |
| -------------- |:---------:| ------------------------------------------------------------------------------------------------ |
| clk_i          | In        | System clock (100 MHz)                                                                           |
| reset_i        | In        | Asynchronous high active reset                                                                   |
| swsync_i(15:0) | In        | State of 16 debounced switches (from IO control unit)                                            |
| pbsync_i(15:0) | In        | State of 4 debounced push buttons (from IO control unit)                                         |
| finished_i     | In        | ALU indicates that calculation of an arithmetic / logic operation is finished                    |
| result_i(15:0) | In        | 16-bit result of an arithmetic / logic operation coming from the ALU                             |
| sign_i         | In        | Sign bit of the result (0 = positive, 1 = negative)                                              |
| overflow_i     | In        | Indicates that the result of an operation exceeds 16 bits                                        |
| error_i        | In        | Indicates that an error occurred during processing of the operation                              |
| op1_o(11:0)    | Out       | Operand OP1 for the ALU                                                                          |
| op2_o(11:0)    | Out       | Operand OP2 for the ALU                                                                          |
| optype_o(3:0)  | Out       | Defines the type of arithmetic / logic operation for the ALU (Table 1: DSD1_Calculator_Overview) |
| start_o        | Out       | Instructs the ALU to start a new calculation                                                     |
| dig0_o(7:0)    | Out       | State of 7 segments and decimal point of Digit 0 (to IO control unit)                            |
| dig1_o(7:0)    | Out       | State of 7 segments and decimal point of Digit 1 (to IO control unit)                            |
| dig2_o(7:0)    | Out       | State of 7 segments and decimal point of Digit 2 (to IO control unit)                            |
| dig3_o(7:0)    | Out       | State of 7 segments and decimal point of Digit 3 (to IO control unit)                            |
| led_o(15:0)    | Out       | State of 16 LEDs (to IO control unit)                                                            |

### ALU Contorl Unit Entity

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
