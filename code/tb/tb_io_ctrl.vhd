-------------------------------------------------------------------------------
-- Design: Testbench IO-CTRL / Project                                       --
--                                                                           --
-- Author : Sebastian Dichler                                                --
-- Date : 17. November 2017                                                  --
-- File : tb_io_ctrl.vhd                                                     --
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_io_entity_ctrl is
end tb_io_entity_ctrl;

architecture tb_io_architecture_ctrl of tb_io_entity_ctrl is
	component io_entity_ctrl
	port(clk_i    :  in std_logic;												-- System Clock (100 MHz)
	     reset_i  :  in std_logic;												-- Asynchronous reset (BTNU)
	     khzen_o : out std_logic;
	     dig0_i   :  in std_logic_vector( 7 downto 0);		-- State of 7 segments and decimal point of Digit 0 (from FPGA-internal logic)
	     dig1_i   :  in std_logic_vector( 7 downto 0);		-- State of 7 segments and decimal point of Digit 1 (from FPGA-internal logic)
	     dig2_i   :  in std_logic_vector( 7 downto 0);		-- State of 7 segments and decimal point of Digit 2 (from FPGA-internal logic)
	     dig3_i   :  in std_logic_vector( 7 downto 0);		-- State of 7 segments and decimal point of Digit 3 (from FPGA-internal logic)
	     led_i    :  in std_logic_vector(15 downto 0);		-- State of 16 LEDs (from FPGA-internal logic)
	     sw_i     :  in std_logic_vector(15 downto 0);		-- State of 16 switches (from FPGA board)
	     pb_i     :  in std_logic_vector( 3 downto 0);		-- State of 4 push buttons (from FPGA board)
	     ss_o     : out std_logic_vector( 7 downto 0);		-- To 7-segments (from FPGA board)
	     ss_sel_o : out std_logic_vector( 3 downto 0);		-- Selection of a 7-segment digit on the FPGA board
	     led_o    : out std_logic_vector(15 downto 0);		-- Connected to 16 LEDs of the FPGA board
	     swsync_o : out std_logic_vector(15 downto 0);		-- State of 16 debounced switches (to FPGA-internal logic)
	     pbsync_o : out std_logic_vector( 3 downto 0));		-- State of 4 debounced push buttons (to FPGA-internal logic)
	end component;
	
	signal clk_i    : std_logic := '0';
	signal reset_i  : std_logic := '1';
	signal dig0_i   : std_logic_vector( 7 downto 0);
	signal dig1_i   : std_logic_vector( 7 downto 0);
	signal dig2_i   : std_logic_vector( 7 downto 0);
	signal dig3_i   : std_logic_vector (7 downto 0);
	signal led_i    : std_logic_vector(15 downto 0);
	signal sw_i     : std_logic_vector(15 downto 0);
	signal pb_i     : std_logic_vector( 3 downto 0);
	signal ss_o     : std_logic_vector( 7 downto 0);
	signal ss_sel_o : std_logic_vector( 3 downto 0);
	signal led_o    : std_logic_vector(15 downto 0);
	signal swsync_o : std_logic_vector(15 downto 0);
	signal pbsync_o : std_logic_vector( 3 downto 0);
	signal khzen_o : std_logic;
	
begin
	
	clk_i <= not(clk_i) after 5 ns; -- 100MHz (10ns)
	reset_i <= '0' after 100 ns;
	
	i_io_entity_ctrl : io_entity_ctrl
	port map
		(clk_i    => clk_i,
		 reset_i  => reset_i,
		 dig0_i   => dig0_i,
		 dig1_i   => dig1_i,
		 dig2_i   => dig2_i,
		 dig3_i   => dig3_i,
		 led_i    => led_i,
		 sw_i     => sw_i,
		 pb_i     => pb_i,
		 ss_o     => ss_o,
		 ss_sel_o => ss_sel_o,
		 led_o    => led_o,
		 swsync_o => swsync_o,
		 pbsync_o => pbsync_o,
		 khzen_o => khzen_o);
		 
		 p_test : process
		 	begin
		 		dig0_i <= "00000011";
		 		dig1_i <= "00011111";
		 		dig2_i <= "00100101";
		 		dig3_i <= "00001101";
		 		led_i <= "1111111111111111";
		 		sw_i <= "1000000000000000";
		 		pb_i <= "1000";
		 		wait for 15 ns;
		 		
		 		dig0_i <= "00011111";
		 		dig1_i <= "00011111";
		 		dig2_i <= "00011111";
		 		dig3_i <= "00011111";
		 		led_i <= "1000000000000000";
		 		sw_i <= "1100000000000000";
		 		pb_i <= "0100";
		 		wait for 15 ns;
		 		
		 		wait until clk_i = '1';
		 	end process p_test;
end tb_io_architecture_ctrl;
