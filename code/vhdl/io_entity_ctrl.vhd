-------------------------------------------------------------------------------
-- Design: IO-CTRL / Entity / Project                                        --
--                                                                           --
-- Author : Sebastian Dichler                                                --
-- Date : 17. November 2017                                                  --
-- File : io_entity_ctrl.vhd                                                 --
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity io_ctrl_entity is
	port(clk_i    :  in std_logic;												-- System Clock (100 MHz)
	     reset_i  :  in std_logic;												-- Asynchronous reset (BTNU)
	     dig0_i   :  in std_logic_vector( 7 downto 0);		-- State of 7 segments and decimal point of Digit 0 (from FPGA-internal logic)
	     dig1_i   :  in std_logic_vector( 7 downto 0);		-- State of 7 segments and decimal point of Digit 1 (from FPGA-internal logic)
	     dig2_i   :  in std_logic_vector( 7 downto 0);		-- State of 7 segments and decimal point of Digit 2 (from FPGA-internal logic)
	     dig3_i   :  in std_logic_vector( 7 downto 0);		-- State of 7 segments and decimal point of Digit 3 (from FPGA-internal logic)
	     led_i    :  in std_logic_vector(15 downto 0);		-- State of 16 LEDs (from FPGA-internal logic)
	     sw_i     :  in std_logic_vector( 3 downto 0);		-- State of 16 switches (from FPGA board)
	     pb_i     :  in std_logic_vector( 3 downto 0);		-- State of 4 push buttons (from FPGA board)
	     ss_o     : out std_logic_vector( 7 downto 0);		-- To 7-segments (from FPGA board)
	     ss_sel_o : out std_logic_vector( 7 downto 0);		-- Selection of a 7-segment digit on the FPGA board
	     led_o    : out std_logic_vector(15 downto 0);		-- Connected to 16 LEDs of the FPGA board
	     swsync_o : out std_logic_vector(15 downto 0);		-- State of 16 debounced switches (to FPGA-internal logic)
	     pbsync_o : out std_logic_vector( 3 downto 0));		-- State of 4 debounced push buttons (to FPGA-internal logic)
end io_ctrl_entity;
