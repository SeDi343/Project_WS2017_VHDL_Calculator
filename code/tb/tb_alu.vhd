-------------------------------------------------------------------------------
-- Design: Testbench ALU / Project                                           --
--                                                                           --
-- Author : Sebastian Dichler                                                --
-- Date : 17. November 2017                                                  --
-- File : tb_alu.vhd                                                         --
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_alu_entity is
end tb_alu_entity;

architecture tb_alu_architecture of tb_alu_entity is
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
	
	signal clk_i      : std_logic := '0';
	signal reset_i    : std_logic := '1';
	signal op1_i      : std_logic_vector(11 downto 0);
	signal op2_i      : std_logic_vector(11 downto 0);
	signal optype_i   : std_logic_vector( 3 downto 0);
	signal start_i    : std_logic;
	signal finished_o : std_logic;
	signal result_o   : std_logic_vector(15 downto 0);
	signal sign_o     : std_logic;
	signal overflow_o : std_logic;
	signal error_o    : std_logic;
	
begin
	
	clk_i <= not(clk_i) after 5 ns; --100MHz (10ns)
	reset_i <= '0' after 20 ns;
	
	i_alu_entity : alu_entity
	port map
		(clk_i      => clk_i,
		 reset_i    => reset_i,
		 op1_i      => op1_i,
		 op2_i      => op2_i,
		 optype_i   => optype_i,
		 start_i    => start_i,
		 finished_o => finished_o,
		 result_o   => result_o,
		 sign_o     => sign_o,
		 overflow_o => overflow_o,
		 error_o    => error_o);
		 
		 p_test : process
		 	begin
		 		start_i <= '0';
		 		op1_i <= "000000001000";
		 		op2_i <= "000000000100";
		 		optype_i <= "0001";
		 		wait for 100 ns;
		 		
		 		start_i <= '1';
		 		wait for 5 ns;
		 		start_i <= '0';
		 		op1_i <= "000000001000";
		 		op2_i <= "000000000100";
		 		optype_i <= "0001";
		 		wait for 100 ns;
		 		
		 		start_i <= '1';
		 		wait for 5 ns;
		 		start_i <= '0';
		 		op1_i <= "000000000100";
		 		op2_i <= "000000001000";
		 		optype_i <= "0001";
		 		wait for 100 ns;
		 		
		 		start_i <= '1';
		 		wait for 5 ns;
		 		start_i <= '0';
		 		op1_i <= "000000011011";
		 		optype_i <= "0110";
		 		wait for 100 ns;
		 		
		 		start_i <= '1';
		 		wait for 5 ns;
		 		start_i <= '0';
		 		op1_i <= "000000000000";
		 		optype_i <= "0110";
		 		wait for 100 ns;
		 		
		 		start_i <= '1';
		 		wait for 5 ns;
		 		start_i <= '0';
		 		op1_i <= "000000011011";
		 		op2_i <= "100000110011";
		 		optype_i <= "1001";
		 		wait for 100 ns;
		 		
		 		start_i <= '1';
		 		wait for 5 ns;
		 		start_i <= '0';
		 		op1_i <= "100010000010";
		 		optype_i <= "1100";
		 		wait for 100 ns;
		 		
		 		start_i <= '1';
		 		wait for 5 ns;
		 		start_i <= '0';
		 		optype_i <= "0011";
		 		wait for 100 ns;
		 		
		 		wait until clk_i = '1';
		 	end process p_test;
end tb_alu_architecture;
