-------------------------------------------------------------------------------
-- Design: TOP LEVEL / Entity / Project                                      --
--                                                                           --
-- Author : Sebastian Dichler                                                --
-- Date : 17. November 2017                                                  --
-- File : top_level_entity.vhd                                               --
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity calc_top_entity is
	port (clk_i   :  in std_logic;											-- System Clock (100 MHz)
	      reset_i :  in std_logic;											-- Asynchronous reset (BTNU)
	      sw_i    :  in std_logic_vector(15 downto 0);	-- 16 Switches
	      pb_i    :  in std_logic_vector( 3 downto 0);	-- 4 Push Buttons (BTNL,BTNC,BTNR,BTND)
	      ss_o    : out std_logic_vector( 7 downto 0);	-- contain the value for all four 7-segment digits
	      ss_sel  : out std_logic_vector( 3 downto 0);	-- Select one out of four 7-segment digits
	      led_o   : out std_logic_vector(15 downto 0));	-- Connected to 16 LEDs
end calc_top_entity;
