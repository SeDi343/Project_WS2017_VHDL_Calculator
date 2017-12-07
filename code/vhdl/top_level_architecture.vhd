-------------------------------------------------------------------------------
-- Design: TOP LEVEL / Architecture / Project                                --
--                                                                           --
-- Author : Sebastian Dichler                                                --
-- Date : 17. November 2017                                                  --
-- File : top_level_architecture.vhd                                         --
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

architecture top_level_architecture of top_level_entity is
	
	-- Component declaration of IO Control Unit
	component io_entity_ctrl
	port(clk_i    :  in std_logic;												-- System Clock (100 MHz)
	     reset_i  :  in std_logic;												-- Asynchronous reset (BTNU)
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
	
	-- Component declaration of Calculator Control Unit
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
	
	-- Component declaration of ALU
	component alu_entity
	port(clk_i      :  in std_logic;											-- System Clock (100 MHz)
	     reset_i    :  in std_logic;											-- Asynchronous reset (BTNU)
	     op1_i      :  in std_logic_vector(11 downto 0);	-- Operand OP1 from the Calculator Control Unit
	     op2_i      :  in std_logic_vector(11 downto 0);	-- Operand OP2 from the Calculator Control Unit
	     optype_i   :  in std_logic_vector( 3 downto 0);	-- Type of arithmetic / logic operation (Table 1: DSD1_Calculator_Prj_Overview) from the Calculator Control Unit
	     start_i    :  in std_logic;											-- The Calculator Control Unit instructs the ALU to start a new calculation
	     finished_o : out std_logic;											-- ALU indicates that calculation of an arithmetic / logic operation has finished
	     result_o   : out std_logic_vector(15 downto 0);	-- 16-bit result of an arithmetic / logic operation for the Calculator Control Unit
	     sign_o     : out std_logic;											-- Sign bit of the result (0 = positive, 1 = negative)
	     overflow_o : out std_logic;											-- Indicates that the result of an operation exceeds 16 bits
	     error_o    : out std_logic);											-- Indicates that an error occurred during processing of the operation
	end component;
	
	--Signals between the Calculator CTRL and the ALU
	signal s_op1      : std_logic_vector(11 downto 0);
	signal s_op2      : std_logic_vector(11 downto 0);
	signal s_optype   : std_logic_vector( 3 downto 0);
	signal s_start    : std_logic;
	signal s_finished : std_logic;
	signal s_result   : std_logic_vector(15 downto 0);
	signal s_sign     : std_logic;
	signal s_overflow : std_logic;
	signal s_error    : std_logic;
	
	-- Signals between the Calculator CTRL and the IO CTRL
	signal s_swsync   : std_logic_vector(15 downto 0);
	signal s_pbsync   : std_logic_vector( 3 downto 0);
	signal s_dig0     : std_logic_vector( 7 downto 0);
	signal s_dig1     : std_logic_vector( 7 downto 0);
	signal s_dig2     : std_logic_vector( 7 downto 0);
	signal s_dig3     : std_logic_vector( 7 downto 0);
	signal s_led      : std_logic_vector(15 downto 0);
	
begin
	
	i_io_entity_ctrl : io_entity_ctrl
	port map
		(clk_i    => clk_i,
		 reset_i  => reset_i,
		 dig0_i   => s_dig0,
		 dig1_i   => s_dig1,
		 dig2_i   => s_dig2,
		 dig3_i   => s_dig3,
		 led_i    => s_led,
		 sw_i     => sw_i,
		 pb_i     => pb_i,
		 ss_o     => ss_o,
		 ss_sel_o => ss_sel_o,
		 led_o    => led_o,
		 swsync_o => s_swsync,
		 pbsync_o => s_pbsync);
	
	i_calc_entity_ctrl : calc_entity_ctrl
	port map
		(clk_i      => clk_i,
		 reset_i    => reset_i,
		 swsync_i   => s_swsync,
		 pbsync_i   => s_pbsync,
		 finished_i => s_finished,
		 result_i   => s_result,
		 sign_i     => s_sign,
		 overflow_i => s_overflow,
		 error_i    => s_error,
		 op1_o      => s_op1,
		 op2_o      => s_op2,
		 optype_o   => s_optype,
		 start_o    => s_start,
		 dig0_o     => s_dig0,
		 dig1_o     => s_dig1,
		 dig2_o     => s_dig2,
		 dig3_o     => s_dig3,
		 led_o      => s_led);
		
	i_alu_entity : alu_entity
	port map
		(clk_i      => clk_i,
		 reset_i    => reset_i,
		 op1_i      => s_op1,
		 op2_i      => s_op2,
		 optype_i   => s_optype,
		 start_i    => s_start,
		 finished_o => s_finished,
		 result_o   => s_result,
		 sign_o     => s_sign,
		 overflow_o => s_overflow,
		 error_o    => s_error);

end top_level_architecture;
