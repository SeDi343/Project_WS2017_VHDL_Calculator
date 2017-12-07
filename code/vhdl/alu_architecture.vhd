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
use IEEE.numeric_std_unsigned.all;

architecture alu_architecture of alu_entity is
	
	signal s_result   : std_logic_vector(15 downto 0);	-- 16-bit result of operation
	signal s_finished : std_logic;											-- finished calculation
	signal s_sign     : std_logic;											-- Sign bit of result (0 = positive, 1 = negative)
	signal s_overflow : std_logic;											-- Indicates that result of an operation exceeds 16 bits
	signal s_error    : std_logic;											-- Indicates that an error occured during the process
	signal s_progress : std_logic;											-- Next to the start_i, flag to calculate everyime till he finished his calculation
	signal s_cntval   : std_logic_vector( 6 downto 0);	-- Counter for the sqrt / operations taken
	signal s_subtr    : std_logic_vector( 6 downto 0);	-- Subtrahent for the sqrt / 1,3,5,7,9,...
	signal s_subdiff  : std_logic_vector(12 downto 0);	-- The difference for the sqrt op1 - subtr
	signal s_regout   : std_logic_vector(12 downto 0);	-- The value that changes for sqrt first time op1
	
begin
	
	-----------------------------------------------------------------------------
	-- Calculator ALU
	-----------------------------------------------------------------------------
	p_calculation : process(clk_i, reset_i)
	begin
		if reset_i = '1' then
			-- Reset System
			s_progress <= '0';
			
		elsif clk_i'event and clk_i = '1' then
			-- Set the flags to 0 every rising edge
			s_finished <= '0';
			s_overflow <= '0';
			s_error <= '0';
			s_sign <= '0';
			
			-- Code for the ALU calculating Sub, Square Root, Logical AND and rotate Left
			
			-- Check if start value is 1 to start calculation and set up default values for calculation
			if start_i = '1' then
				s_regout(11 downto 0) <= op1_i;
				s_regout(12) <= '0';
				s_progress <= '1';
				s_cntval <= "0000000";
			end if;
			
			-- If start_i was 1 and calculation progress flag is set to 1
			if s_progress = '1' then
				
				-- Which calculation are we using? Sub, Square Root, Logical AND or rotate Left
				case optype_i is
					
					-- OPTYPE = Substraction (Sub)
					when "0001" =>
						-- Positive Substraction
						if op1_i > op2_i then
							-- result = op1 - op2 and fill other bits of result with 0
							s_result(11 downto 0) <= unsigned(op1_i(11 downto 0)) - unsigned(op2_i(11 downto 0));
							s_result(15 downto 12) <= "0000";
							
							s_sign <= '0';
							s_finished <= '1';
							s_progress <= '0';
							s_overflow <= '0';
							s_error <= '0';
							
						-- Negative Substraction
						elsif op1_i < op2_i then
							-- result = not(op1 - op2) + 1 and fill other bits of result with 0
							-- sign is 1
							s_result(11 downto 0) <= unsigned(op1_i(11 downto 0)) - unsigned(op2_i(11 downto 0));
							s_result(11 downto 0) <= not(s_result(11 downto 0));
							s_result(11 downto 0) <= unsigned(s_result(11 downto 0)) + '1';
							s_result(15 downto 12) <= "0000";
							
							s_sign <= '1';
							s_finished <= '1';
							s_progress <= '0';
							s_overflow <= '0';
							s_error <= '0';
						end if;
						
					-- OPTYPE = Square Root (Sro)
					when "0110" =>
						-- Create the subtrahent from the counter by shifting to the left and adding 1 at the lsb
						-- This creates numbers like 1,3,5,7,9
						s_subtr(6 downto 1) <= s_cntval(5 downto 0);
						s_subtr(0) <= '1';
						
						-- Difference is register out - subtrahent
						s_subdiff <= unsigned(s_regout(12 downto 0)) - unsigned(s_subtr(6 downto 0));
						
						-- If Operand 1 is 0 the result is 0 aswell not 1
						if op1_i = "000000000000" then
							s_result(15 downto 0) <= "0000000000000000";
							
							s_sign <= '0';
							s_finished <= '1';
							s_progress <= '0';
							s_overflow <= '0';
							s_error <= '0';
						end if;
						
						-- If the subdifference is negative msb = 1
						if s_subdiff(12) = '1' then
							s_result( 6 downto 0) <= unsigned(s_cntval(6 downto 0)) + '1';
							s_result(15 downto 7) <= "000000000";
							
							s_sign <= '0';
							s_finished <= '1';
							s_progress <= '0';
							s_overflow <= '0';
							s_error <= '0';
						
						-- If the subdifference is positive msb = 0
						elsif s_subdiff(12) = '0' then
							-- Increment the counter and push the subdiff to the regout
							s_regout <= s_subdiff;
							s_cntval <= unsigned(s_cntval(6 downto 0)) + '1';
						end if;
						
					-- OPTYPE = Logical AND (And)
					when "1001" =>
						-- Simple AND calculation
						s_result(11 downto 0) <= op1_i(11 downto 0) AND op2_i(11 downto 0);
						
						s_sign <= '0';
						s_finished <= '1';
						s_progress <= '0';
						s_overflow <= '0';
						s_error <= '0';
						
					-- OPTYPE = Rotate Left (roL)
					when "1100" =>
						-- Simple Rotate Left calculation
						s_result(11 downto 1) <= op1_i(10 downto 0);
						s_result(0) <= op1_i(11);
						
						s_sign <= '0';
						s_finished <= '1';
						s_progress <= '0';
						s_overflow <= '0';
						s_error <= '0';
						
					-- OPTYPE = Not Available (error)
					when others =>
						s_error <= '1';
						s_progress <= '0';
				end case;
			end if;
		end if;
	end process p_calculation;
	
	result_o <= s_result;
	finished_o <= s_finished;
	sign_o <= s_sign;
	overflow_o <= s_overflow;
	error_o <= s_error;
	
end alu_architecture;
