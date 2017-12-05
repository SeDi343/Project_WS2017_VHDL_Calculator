-------------------------------------------------------------------------------
-- Design: Testbench CALC-CTRL / Project                                     --
--                                                                           --
-- Author : Sebastian Dichler                                                --
-- Date : 17. November 2017                                                  --
-- File : tb_calc_ctrl.vhd                                                   --
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_calc_entity_ctrl is
end tb_calc_entity_ctrl;

architecture tb_calc_architecture_ctrl of tb_calc_entity_ctrl is
	component calc_entity_ctrl
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
	end component;
	
	signal clk_i      : std_logic := '0';
	signal reset_i    : std_logic := '1';
	signal swsync_i   : std_logic_vector(15 downto 0);
	signal pbsync_i   : std_logic_vector( 3 downto 0);
	signal finished_i : std_logic;
	signal result_i   : std_logic_vector(15 downto 0);
	signal sign_i     : std_logic;
	signal overflow_i : std_logic;
	signal error_i    : std_logic;
	signal op1_o      : std_logic_vector(11 downto 0);
	signal op2_o      : std_logic_vector(11 downto 0);
	signal optype_o   : std_logic_vector( 3 downto 0);
	signal start_o    : std_logic;
	signal dig0_o     : std_logic_vector( 7 downto 0);
	signal dig1_o     : std_logic_vector( 7 downto 0);
	signal dig2_o     : std_logic_vector( 7 downto 0);
	signal dig3_o     : std_logic_vector( 7 downto 0);
	signal led_o      : std_logic_vector(15 downto 0);
	
begin
	
	clk_i <= not(clk_i) after 5 ns; -- 100MHz (10ns)
	reset_i <= '0' after 100 ns;
	
	i_calc_entity_ctrl : calc_entity_ctrl
	port map
		(clk_i      => clk_i,
		 reset_i    => reset_i,
		 swsync_i   => swsync_i,
		 pbsync_i   => pbsync_i,
		 finished_i => finished_i,
		 result_i   => result_i,
		 sign_i     => sign_i,
		 overflow_i => overflow_i,
		 error_i    => error_i,
		 op1_o      => op1_o,
		 op2_o      => op2_o,
		 optype_o   => optype_o,
		 start_o    => start_o,
		 dig0_o     => dig0_o,
		 dig1_o     => dig1_o,
		 dig2_o     => dig2_o,
		 dig3_o     => dig3_o,
		 led_o      => led_o);
		 
		 p_test : process
		 	begin
		 		swsync_i <= "0000111111111111"; -- OP1
		 		wait for 250 ns;
		 		
		 		pbsync_i <= "1000"; -- Go Next step
		 		wait for 50 ns;
		 		pbsync_i <= "0000"; -- Just a press
		 		
		 		swsync_i <= "0000000000000000"; -- OP2
		 		wait for 250 ns;
		 		
		 		pbsync_i <= "1000"; -- Go Next step
		 		wait for 50 ns;
		 		pbsync_i <= "0000"; -- Just a press

		 		swsync_i <= "1100000000000000"; -- OPTYPE
		 		wait for 250 ns;
		 		
		 		pbsync_i <= "1000"; -- Go Next step
		 		wait for 50 ns;
		 		pbsync_i <= "0000"; -- Just a press
		 		wait for 250 ns;
		 		
		 		finished_i <= '1';
		 		sign_i <= '0';
		 		result_i <= "0000000000000000";
		 		overflow_i <= '0';
		 		error_i <= '0';
		 		
		 		wait for 250 ns;
		 		
		 		pbsync_i <= "1000"; -- Go Next step
		 		wait for 50 ns;
		 		pbsync_i <= "0000"; -- Just a press
		 		wait for 250 ns;
		 		
		 		wait for 1000 ns;
		 		
		 		swsync_i <= "0000111111111111"; -- OP1
		 		wait for 250 ns;
		 		
		 		pbsync_i <= "1000"; -- Go Next step
		 		wait for 100 ns;
		 		pbsync_i <= "0000"; -- Just a press
		 		
		 		swsync_i <= "0000000000000000"; -- OP2
		 		wait for 250 ns;
		 		
		 		pbsync_i <= "1000"; -- Go Next step
		 		wait for 100 ns;
		 		pbsync_i <= "0000"; -- Just a press

		 		swsync_i <= "1100000000000000"; -- OPTYPE
		 		wait for 250 ns;
		 		
		 		pbsync_i <= "1000"; -- Go Next step
		 		wait for 100 ns;
		 		pbsync_i <= "0000"; -- Just a press
		 		wait for 250 ns;
		 		
		 		finished_i <= '0';
		 		error_i <= '1';
		 		
		 		wait for 250 ns;
		 		
		 		pbsync_i <= "1000"; -- Go Next step
		 		wait for 50 ns;
		 		pbsync_i <= "0000"; -- Just a press
		 		wait for 250 ns;
		 		
		 		wait for 1000 ns;
		 		
		 		
		 		wait until clk_i = '1';
		 	end process p_test;
end tb_calc_architecture_ctrl;
