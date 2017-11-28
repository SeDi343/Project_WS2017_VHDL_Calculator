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
	
	type t_state is (MUX_DIG0, MUX_DIG1, MUX_DIG2, MUX_DIG3);
	
	signal s_enctr   : std_logic_vector(16 downto 0);	-- Counter
	signal s_1khzen  : std_logic;											-- 1kHz enable signal
	signal swsync    : std_logic_vector(15 downto 0);	-- Debounced Switches signal
	signal pbsync    : std_logic_vector( 3 downto 0);	-- Debounced push buttions signal
	signal s_ss_sel  : std_logic_vector( 3 downto 0);	-- Selection of 7-segment digit signal
	signal s_ss      : std_logic_vector( 7 downto 0); -- Value for 7-segment digit signal
	signal s_state   : t_state;
	
begin
	
	-----------------------------------------------------------------------------
	-- Generate the 1 kHz enable Signal
	-----------------------------------------------------------------------------
	p_s1khzen : process(clk_i, reset_i)
	begin
		if reset_i = '1' then
			-- Reset System
			
			s_1khzen <= '0';
			s_enctr <= "00000000000000000";	
			s_state <= MUX_DIG0;
			
		elsif clk_i'event and clk_i = '1' then
			-- Enable signal is inactive per default
			-- As long as the terminal count is not reached: increment the counter.
			-- When the terminal count is reached, set enable signal and reset the
			-- counter.
			
			-- 1khz signal allways low
			s_1khzen <= '0';
			
			-- if counter equals the requested value else increment the counter
			if s_enctr = C_ENCOUNTVAL then
				s_1khzen <= '1';
				s_enctr <= "00000000000000000";
			else
				-- s_enctr <= unsigned(s_enctr) + '1';
				s_enctr <= s_enctr + '1';
			end if;
			
		end if;
	end process p_s1khzen;
	
	-----------------------------------------------------------------------------
	-- Debounce buttons and switches
	-----------------------------------------------------------------------------
	p_debounce : process(clk_i, reset_i)
	begin
		if reset_i = '1' then
			-- Reset System
			
			s_1khzen <= '0';
			s_enctr <= "00000000000000000";
			s_state <= MUX_DIG0;
			
		elsif clk_i'event and clk_i = '1' then
			-- The switches and buttons are debounced and forwarded to internal signals.
			-- Both tasks are synchronous to the previousl generated 1kHz enable signal.
			
			-- If the 1khz signal is high put input of buttons and switches to signal
			-- SHOULD USE 2 FLIP FLOPS FOR THIS
			if s_1khzen = '1' then
				pbsync <= pb_i;
				swsync <= sw_i;
			end if;
			
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
			
			s_1khzen <= '0';
			s_enctr <= "00000000000000000";
			s_state <= MUX_DIG0;
			
		elsif clk_i'event and clk_i = '1' then
			-- Set one of the four 7-segment select signals s_ss_sel to logic 0 and
			-- multiplex dig0_i - dig3_i to s_ss in a circular fashion using the 1kHz
			-- enable signal.
			
			if s_1khzen = '1' then

				case s_state is
					-- Low Active (0 is the chosen Segment)
					-- State 1: 1st 7-segment Digit
					when MUX_DIG0 =>
						s_ss_sel <= "0111";
						s_ss <= dig0_i;
						s_state <= MUX_DIG1;
					
					-- State 2: 2nd 7-segment Digit
					when MUX_DIG1 =>
						s_ss_sel <= "1011";
						s_ss <= dig1_i;
						s_state <= MUX_DIG2;
					
					-- State 3: 3rd 7-segment Digit
					when MUX_DIG2 =>
						s_ss_sel <= "1101";
						s_ss <= dig2_i;
						s_state <= MUX_DIG3;
					
					-- State 4: 4th 7-segment Digit
					when MUX_DIG3 =>
						s_ss_sel <= "1110";
						s_ss <= dig3_i;
						s_state <= MUX_DIG0;
					
					-- State 5: In case of anything do the same as State 1
					when others =>
						s_ss_sel <= "0111";
						s_ss <= dig0_i;
						s_state <= MUX_DIG1;
				end case;
			end if;	
		end if;
	end process p_display_ctrl;
	
	ss_o <= s_ss;					-- Write value to 7-segment digit signal to output
	ss_sel_o <= s_ss_sel;	-- Write selection of a 7-segment digit signal to output
	
	-----------------------------------------------------------------------------
	-- Handle the 16 LEDs
	-----------------------------------------------------------------------------
	led_o <= led_i;	-- connect the internal to the external signals
	
end io_architecture_ctrl;
