-------------------------------------------------------------------------------
-- Design: CALC-CTRL / Architecture / Project                                --
--                                                                           --
-- Author : Sebastian Dichler                                                --
-- Date : 17. November 2017                                                  --
-- File : calc_architecture_ctrl.vhd                                         --
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

architecture calc_architecture_ctrl of calc_ctrl_entity is
	type t_state is (MUX_DIG0, MUX_DIG1, MUX_DIG2, MUX_DIG3);
	
	signal s_op1     : std_logic_vector(11 downto 0);
	signal s_op2     : std_logic_vector(11 downto 0);
	signal s_optype  : std_logic_vector( 3 downto 0);
	signal s_state   : t_state;
	
begin

end calc_architecture_ctrl;
