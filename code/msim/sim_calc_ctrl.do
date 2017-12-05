vsim -t ns -novopt -lib work work.tb_calc_entity_ctrl
view *
onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /tb_calc_entity_ctrl/clk_i
add wave -noupdate -format Logic /tb_calc_entity_ctrl/reset_i
add wave -noupdate -format Logic /tb_calc_entity_ctrl/dig0_o
add wave -noupdate -format Logic /tb_calc_entity_ctrl/dig1_o
add wave -noupdate -format Logic /tb_calc_entity_ctrl/dig2_o
add wave -noupdate -format Logic /tb_calc_entity_ctrl/dig3_o
add wave -noupdate -format Logic /tb_calc_entity_ctrl/led_o
add wave -noupdate -format Logic /tb_calc_entity_ctrl/swsync_i
add wave -noupdate -format Logic /tb_calc_entity_ctrl/pbsync_i
add wave -noupdate -format Logic /tb_calc_entity_ctrl/op1_o
add wave -noupdate -format Logic /tb_calc_entity_ctrl/op2_o
add wave -noupdate -format Logic /tb_calc_entity_ctrl/optype_o
add wave -noupdate -format Logic /tb_calc_entity_ctrl/result_i
add wave -noupdate -format Logic /tb_calc_entity_ctrl/finished_i
add wave -noupdate -format Logic /tb_calc_entity_ctrl/sign_i
add wave -noupdate -format Logic /tb_calc_entity_ctrl/overflow_i
add wave -noupdate -format Logic /tb_calc_entity_ctrl/error_i
add wave -noupdate -format Logic /tb_calc_entity_ctrl/start_o
add wave -noupdate -format Logic /tb_calc_entity_ctrl/i_calc_entity_ctrl/s_state
add wave -noupdate -format Logic /tb_calc_entity_ctrl/i_calc_entity_ctrl/s_pbstate
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {0 ps}
WaveRestoreZoo {0 ps} {1 ns}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -signalnamewidth 0
configure wave -justifyvalue left
run 10 ms
