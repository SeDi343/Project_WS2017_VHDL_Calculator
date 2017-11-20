-------------------------------------------------------------------------------
-- Design: IO-CTRL / Architecture / Project                                  --
--                                                                           --
-- Author : Sebastian Dichler                                                --
-- Date : 17. November 2017                                                  --
-- File : io_architecture_ctrl.vhd                                           --
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

architecture io_architecture_ctrl of io_entity_ctrl is
	constant C_ENCOUNTVAL : std_logic_vector(16 downto 0) := "11000011010100000";
	
	signal s_enctr   : std_logic_vector(16 downto 0);	-- Counter
	signal s_1khzen  : std_logic;											-- 1kHz enable signal
	signal swsync    : std_logic_vector(15 downto 0);	-- Debounced Switches signal
	signal pbsync    : std_logic_vector( 3 downto 0);	-- Debounced push buttions signal
	signal s_ss_sel  : std_logic_vector( 7 downto 0);	-- Selection of 7-segment digit signal
	signal s_ss      : std_logic_vector( 7 downto 0); -- Value for 7-segment digit signal
	
begin
	
	-----------------------------------------------------------------------------
	-- Generate the 1 kHz enable Signal
	-----------------------------------------------------------------------------
	p_s1khzen : process(clk_i, reset_i)
	begin
		if reset_i = '1' then
			-- Reset System
			
		elsif clk_i'event and clk_i = '1' then
			-- Enable signal is inactive per default
			-- As long as the terminal count is not reached: increment the counter.
			-- When the terminal count is reached, set enable signal and reset the
			-- counter.
		end if;
	end process p_s1khzen;
	
	-----------------------------------------------------------------------------
	-- Debounce buttons and switches
	-----------------------------------------------------------------------------
	p_debounce : process(clk_i, reset_i)
	begin
		if reset_i = '1' then
			-- Reset System
		elsif clk_i'event and clk_i = '1' then
			-- The switches and buttons are debounced and forwarded to internal signals.
			-- Both tasks are synchronous to the previousl generated 1kHz enable signal.
		end if;
	end process p_debounce;
	
	swsync_o <= swsync;	-- Write debounced switches signal to output
	pbsync_o <= pbsync;	-- Write debounced push buttons signal to output
	
	-----------------------------------------------------------------------------
	-- Display controller for the 7-segment display
	-----------------------------------------------------------------------------
	p_display_ctrl : process(clk_i, reset_i)
	begin
		if reset_i = '1' then
			-- Reset System
		elsif clk_i'event and clk_i = '1' then
			-- Set one of the four 7-segment select signals s_ss_sel to logic 0 and
			-- multiplex dig0_i - dig3_i to s_ss in a circular fashion using the 1kHz
			-- enable signal.
		end if;
	end process p_display_ctrl;
	
	ss_o <= s_ss;					-- Write value to 7-segment digit signal to output
	ss_sel_o <= s_ss_sel;	-- Write selection of a 7-segment digit signal to output
	
	-----------------------------------------------------------------------------
	-- Handle the 16 LEDs
	-----------------------------------------------------------------------------
	led_o <= led_i	-- connect the internal to the external signals
	
end io_architecture_ctrl;
