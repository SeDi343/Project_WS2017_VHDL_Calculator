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
	
begin
	
	-----------------------------------------------------------------------------
	-- Calculator ALU
	-----------------------------------------------------------------------------
	p_calculation : process(clk_i, reset_i)
	begin
		if reset_i = '1' then
			-- Reset System
			
		elsif clk_i'event and clk_i = '1' then
			-- Code for the ALU calculating Sub, Square Root, Logical AND and rotate Left
			
			-- Check if start value is 1 to start calculation
			if start_i = '1' then
				
				-- Which calculation are we using? Sub, Square Root, Logical AND or rotate Left
				case optype_i is
					
					-- OPTYPE = Substraction (Sub)
					when "0001" =>
						-- Positive Substraction
						if op1_i > op2_i then
							s_result(11 downto 0) <= unsigned(op1_i(11 downto 0)) - unsigned(op2_i(11 downto 0));
							s_result(15 downto 12) <= "0000";
							s_sign <= '0';
							s_finished <= '1';
							s_overflow <= '0';
							s_error <= '0';
							
						-- Negative Substraction
						elsif op1_i < op2_i then
							s_result(11 downto 0) <= unsigned(op1_i(11 downto 0)) - unsigned(op2_i(11 downto 0));
							s_result(11 downto 0) <= not(s_result(11 downto 0));
							s_result(15 downto 12) <= "0001";
							s_sign <= '1';
							s_finished <= '1';
							s_overflow <= '0';
							s_error <= '0';
						end if;
						
					-- OPTYPE = Square Root (Sro)
					when "0110" =>
						
					-- OPTYPE = Logical AND (And)
					when "1001" =>
						
					-- OPTYPE = Rotate Left (roL)
					when "1100" =>
						
					-- OPTYPE = Not Available (error)
					when others =>
						s_error = '1';
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
