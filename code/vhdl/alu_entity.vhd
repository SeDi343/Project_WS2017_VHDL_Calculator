-------------------------------------------------------------------------------
-- Design: ALU / Entity / Project                                            --
--                                                                           --
-- Author : Sebastian Dichler                                                --
-- Date : 17. November 2017                                                  --
-- File : alu_entity.vhd                                                     --
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity alu_entity is
	port(clk_i      :  in std_logic;											-- System Clock (100 MHz)
	     reset_i    :  in std_logic;											-- Asynchronous reset (BTNU)
	     op1_i      :  in std_logic_vector(11 downto 0);	-- Operand OP1 from the Calculator Control Unit
	     op2_i      :  in std_logic_vector(11 downto 0);	-- Operand OP2 from the Calculator Control Unit
	     optype_i   :  in std_logic_vector( 3 downto 0);	-- Type of arithmetic / logic operation (Table 1: DSD1_Calculator_Prj_Overview) from the Calculator Control Unit
	     start_i    :  in std_logic;											-- The Calculator Control Unit instructs the ALU to start a new calculation
	     finished_o : out std_logic;											-- ALU indicates that calculation of an arithmetic / logic operation has finished
	     result_o   : out std_logic_vector(15 downto 0);	-- 16-bit result of an arithmetic / logic operation for the Calculator Control Unit
	     sign_o     : out std_logic;											-- Sign bit of the result (0 = positive, 1 = negative)
	     overflow_o : out std_logic;											-- Indicates that the result of an operation exceeds 16 bits
	     error_o    : out std_logic);											-- Indicates that an error occurred during processing of the operation
end alu_entity;
