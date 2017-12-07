-------------------------------------------------------------------------------
-- Design: Testbench TOP LEVEL / Project                                     --
--                                                                           --
-- Author : Sebastian Dichler                                                --
-- Date : 17. November 2017                                                  --
-- File : tb_alu.vhd                                                         --
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_top_level_entity is
end tb_top_level_entity;

architecture tb_top_level_architecture of tb_top_level_entity is
	component top_level_entity
	port (clk_i    :  in std_logic;											-- System Clock (100 MHz)
	      reset_i  :  in std_logic;											-- Asynchronous reset (BTNU)
	      sw_i     :  in std_logic_vector(15 downto 0);	-- 16 Switches
	      pb_i     :  in std_logic_vector( 3 downto 0);	-- 4 Push Buttons (BTNL,BTNC,BTNR,BTND)
	      ss_o     : out std_logic_vector( 7 downto 0);	-- contain the value for all four 7-segment digits
	      ss_sel_o : out std_logic_vector( 3 downto 0);	-- Select one out of four 7-segment digits
	      led_o    : out std_logic_vector(15 downto 0));	-- Connected to 16 LEDs
	end component;
	
	signal clk_i    : std_logic := '0';
	signal reset_i  : std_logic := '1';
	signal sw_i     : std_logic_vector(15 downto 0);
	signal pb_i     : std_logic_vector( 3 downto 0);
	signal ss_o     : std_logic_vector( 7 downto 0);
	signal ss_sel_o : std_logic_vector( 3 downto 0);
	signal led_o    : std_logic_vector(15 downto 0);
	
begin
	
	clk_i <= not(clk_i) after 5 ns; --100MHz (10ns)
	reset_i <= '0' after 20 ns;
	
	i_top_level_entity : top_level_entity
	port map
		(clk_i    => clk_i,
		 reset_i  => reset_i,
		 sw_i     => sw_i,
		 pb_i     => pb_i,
		 ss_o     => ss_o,
		 ss_sel_o => ss_sel_o,
		 led_o    => led_o);
		 
		 p_test : process
		 	begin
		 		-- OP1
		 		pb_i <= "0000";
		 		sw_i <= "0000000000001000";
		 		wait for 2 ms;
		 		
		 		-- Button press
		 		pb_i <= "1000";
		 		wait for 2 ms;
		 		pb_i <= "0000";
		 		
		 		-- OP2
		 		sw_i <= "0000000000000100";
		 		wait for 2 ms;
		 		
		 		-- Button press
		 		pb_i <= "1000";
		 		wait for 2 ms;
		 		pb_i <= "0000";
		 		
		 		--OPTYPE
		 		sw_i <= "0001000000000000";
		 		wait for 2 ms;
		 		
		 		-- Button press
		 		pb_i <= "1000";
		 		wait for 2 ms;
		 		pb_i <= "0000";
		 		
		 		wait for 2 ms;
		 		
		 		-- Button press
		 		pb_i <= "1000";
		 		wait for 2 ms;
		 		pb_i <= "0000";
		 		
		 		wait until clk_i = '1';
			end process p_test;
end tb_top_level_architecture;
