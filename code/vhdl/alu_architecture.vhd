-------------------------------------------------------------------------------
-- Design: ALU / Architecture / Project                                      --
--                                                                           --
-- Author : Sebastian Dichler                                                --
-- Date : 17. November 2017                                                  --
-- File : alu_architecture.vhd                                               --
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

architecture alu_architecture of alu_entity is
	
	signal s_result   : std_logic_vector(15 downto 0);	-- 16-bit result of operation
	signal s_finished : std_logic;											-- finished calculation
	signal s_sign     : std_logic;											-- Sign bit of result (0 = positive, 1 = negative)
	signal s_overflow : std_logic;											-- Indicates that result of an operation exceeds 16 bits
	signal s_error    : std_logic;											-- Indicates that an error occured during the process
	
begin
	
	
	
end alu_architecture;
