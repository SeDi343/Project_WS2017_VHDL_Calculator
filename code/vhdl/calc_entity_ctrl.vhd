-------------------------------------------------------------------------------
-- Design: CALC-CTRL / Entity / Project                                      --
--                                                                           --
-- Author : Sebastian Dichler                                                --
-- Date : 17. November 2017                                                  --
-- File : calc_entity_ctrl.vhd                                               --
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity calc_ctrl_entity is
	port(clk_i      :  in std_logic;												-- System Clock (100 MHz)
	     reset_i    :  in std_logic;												-- Asynchronous reset (BTNU)
	     swsync_i   :  in std_logic_vector(15 downto 0);		-- State of 16 debounced switches (from IO control unit)
	     pbsync_i   :  in std_logic_vector( 3 downto 0);		-- State of 4 debounced push buttons (from IO control unit)
	     finished_i :  in std_logic;												-- ALU indicates that calculation of an arithmetic / logic operation is finished
	     result_i   :  in std_logic_vector(15 downto 0);		-- 16-bit result of an arithmetic / logic operation coming from the ALU
	     sign_i     :  in std_logic;												-- Sign bit of the result (0 = positive, 1 = negative)
	     overflow_i :  in std_logic;												-- Indicates that the result of an operation exceeds 16 bits
	     error_i    :  in std_logic;												-- Indicates that an error occurred during processing of the operation
	     op1_o      : out std_logic_vector(11 downto 0);		-- Operand OP1 for the ALU
	     op2_o      : out std_logic_vector(11 downto 0);		-- Operand OP2 for the ALU
	     optype_o   : out std_logic_vector( 3 downto 0);		-- Defines the type of arithmetic / logic operation for the ALU (Table 1: DSD1_Calculator_Prj_Overview)
	     start_o    : out std_logic;												-- Instructs the ALU to start a new calculation
	     dig0_o     : out std_logic_vector( 7 downto 0);		-- State of 7 segments and decimal point of Digit 0 (to IO control unit)
	     dig1_o     : out std_logic_vector( 7 downto 0);		-- State of 7 segments and decimal point of Digit 1 (to IO control unit)
	     dig2_o     : out std_logic_vector( 7 downto 0);		-- State of 7 segments and decimal point of Digit 2 (to IO control unit)
	     dig3_o     : out std_logic_vector( 7 downto 0);		-- State of 7 segments and decimal point of Digit 3 (to IO control unit)
	     led_o      : out std_logic_vector(15 downto 0));		-- State of 16 LEDs (to IO control unit)
end calc_ctrl_entity;
