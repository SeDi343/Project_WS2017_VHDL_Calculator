-------------------------------------------------------------------------------
-- Design: CALC-CTRL / Architecture / Project                                --
--                                                                           --
-- Author : Sebastian Dichler                                                --
-- Date : 27. November 2017                                                  --
-- File : calc_architecture_ctrl.vhd                                         --
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

architecture calc_architecture_ctrl of calc_ctrl_entity is
	-- Site 4 of IOControl PDF digit A,B,C,D,E,F,G,DP
	constant C_OP1START    : std_logic_vector(7 downto 0) := "00011110";	-- "1" code for 7-segment
	constant C_OP2START    : std_logic_vector(7 downto 0) := "00100100";	-- "2" code for 7-segment
	constant C_OPTYPESTART : std_logic_vector(7 downto 0) := "11000100";	-- "o" code for 7-segment

	type t_state is (OP1, OP2, OPTYPE, RESULT, RESTART);	-- States for the FSM Calculator
	
	signal s_op1    : std_logic_vector(11 downto 0);	-- Operand OP1 for the ALU
	signal s_op2    : std_logic_vector(11 downto 0);	-- Operand OP2 for the ALU
	signal s_optype : std_logic_vector( 3 downto 0);	-- Defines the type of arithmetic/logic operation for the ALU
	signal s_start  : std_logic;											-- Instructs the ALU to start a new calculation
	signal s_dig0   : std_logic_vector( 7 downto 0);	-- State of 7 segments and decimal point of Digit 0
	signal s_dig1   : std_logic_vector( 7 downto 0);	-- State of 7 segments and decimal point of Digit 1
	signal s_dig2   : std_logic_vector( 7 downto 0);	-- State of 7 segments and decimal point of Digit 2
	signal s_dig3   : std_logic_vector( 7 downto 0);	-- State of 7 segments and decimal point of Digit 3
	signal s_led    : std_logic_vector(15 downto 0);	-- State of 16 LEDs
	signal s_state  : t_state;
	
	-----------------------------------------------------------------------------
	-- Function to convert the binary 4 bits for a 7-segment to digit code
	-----------------------------------------------------------------------------
	function BinaryToDigit (binary_digit : std_logic_vector(3 downto 0))
		return std_logic_vector is
		
		variable result_digit : std_logic_vector;
		
	begin
		
		case binary_digit is
			when "0000" => result_digit := "00000011";	-- Digit "0"
			when "0001" => result_digit := "00011111";	-- Digit "1"
			when "0010" => result_digit := "00100101";	-- Digit "2"
			when "0011" => result_digit := "00001101";	-- Digit "3"
			when "0100" => result_digit := "10011001";	-- Digit "4"
			when "0101" => result_digit := "01001011";	-- Digit "5"
			when "0110" => result_digit := "01000001";	-- Digit "6"
			when "0111" => result_digit := "00011111";	-- Digit "7"
			when "1000" => result_digit := "00000001";	-- Digit "8"
			when "1001" => result_digit := "00001001";	-- Digit "9"
			when "1010" => result_digit := "00010001";	-- Digit "A"
			when "1011" => result_digit := "11000001";	-- Digit "b"
			when "1100" => result_digit := "11100101";	-- Digit "c"
			when "1101" => result_digit := "10000101";	-- Digit "d"
			when "1110" => result_digit := "01100001";	-- Digit "E"
			when "1111" => result_digit := "01110001";	-- Digit "F"
			when others => result_digit := "00100001";	-- Digit "e"
		end case;
		return result_digit;
	end;
	
begin
	
	-----------------------------------------------------------------------------
	-- State Machine for Calculator
	-----------------------------------------------------------------------------
	p_states : process(clk_i, reset_i)
	begin
		if reset = '1' then
			-- Reset System
			
			s_state <= OP1;
			s_start <= '0';
			s_led <= "0000000000000000";
			
		elsif clk_i'event and clk_i = '1' then
			-- Single States of the State Machine for the Calculator
			
			case s_state is
				-- State 1: RESET => Left Digit of DISP1 shows "1" and OP1 Input
				--                   Change OP1 with SW0-SW12 / changes visible on DISP1 in HEX
				when OP1 =>
					s_led <= "0000000000000000";
					s_dig0 <= C_OP1START;
					s_dig1 <= BinaryToDigit(swsync_i(11 downto 8));
					s_dig2 <= BinaryToDigit(swsync_i( 7 downto 4));
					s_dig3 <= BinaryToDigit(swsync_i( 3 downto 0));
					s_op1 <= swsync_i(11 downto 0);
					s_state <= OP2;
				
				-- State 2: BTNL => Left Digit of DISP1 shows "2" and OP2 Input
				--                  Change OP2 with SW0-SW12 / changes visible on DISP1 in HEX
				when OP2 =>
					s_state <= OPTYPE;
				
				-- State 3: BTNL => Left Digit of DISP1 shows "o" and OPTYPE Input
				--                  Change OPTYPE with SW12-SW15 / changes visible on DISP1 in HEX
				--                  16 LEDs are off
				when OPTYPE =>
					s_state <= RESULT;
				
				-- State 4: BTNL => DISP1 shows signed result (or error/overflow)
				--                  LED15 is on if result is displayed
				when RESULT =>
					s_state <= RESTART;
				
				-- State 5:  BTNL => Jump to State 1
				when RESTART =>
					s_state <= OP1;
			end case;
		end if;
	end process p_states;
	
	start_o <= s_start;
	led_o <= s_led;
	dig0_o <= s_dig0;
	dig1_o <= s_dig1;
	dig2_o <= s_dig2;
	dig3_o <= s_dig3;
	op1_o <= s_op1;
	op2_o <= s_op2;
	optype_o <= s_optype;
	
end calc_architecture_ctrl;
