vsim -t ns -novopt -lib work work.tb_top_level_entity
view *
onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /tb_top_level_entity/clk_i
add wave -noupdate -format Logic /tb_top_level_entity/reset_i
add wave -noupdate -format Logic /tb_top_level_entity/sw_i
add wave -noupdate -format Logic /tb_top_level_entity/pb_i
add wave -noupdate -format Logic /tb_top_level_entity/ss_o
add wave -noupdate -format Logic /tb_top_level_entity/ss_sel_o
add wave -noupdate -format Logic /tb_top_level_entity/i_top_level_entity/i_calc_entity_ctrl/s_state
add wave -noupdate -format Logic /tb_top_level_entity/i_top_level_entity/i_io_entity_ctrl/s_1khzen
add wave -noupdate -format Logic /tb_top_level_entity/i_top_level_entity/i_alu_entity/result_o
add wave -noupdate -format Logic /tb_top_level_entity/i_top_level_entity/i_calc_entity_ctrl/result_i
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {0 ps}
WaveRestoreZoo {0 ps} {1 ns}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -signalnamewidth 0
configure wave -justifyvalue left
run 50 ms
