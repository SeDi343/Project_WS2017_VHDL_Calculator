vsim -t ns -novopt -lib work work.tb_io_entity_ctrl
view *
onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /tb_io_entity_ctrl/clk_i
add wave -noupdate -format Logic /tb_io_entity_ctrl/reset_i
add wave -noupdate -format Logic /tb_io_entity_ctrl/dig0_i
add wave -noupdate -format Logic /tb_io_entity_ctrl/dig1_i
add wave -noupdate -format Logic /tb_io_entity_ctrl/dig2_i
add wave -noupdate -format Logic /tb_io_entity_ctrl/dig3_i
add wave -noupdate -format Logic /tb_io_entity_ctrl/ss_o
add wave -noupdate -format Logic /tb_io_entity_ctrl/ss_sel_o
add wave -noupdate -format Logic /tb_io_entity_ctrl/led_i
add wave -noupdate -format Logic /tb_io_entity_ctrl/led_o
add wave -noupdate -format Logic /tb_io_entity_ctrl/sw_i
add wave -noupdate -format Logic /tb_io_entity_ctrl/swsync_o
add wave -noupdate -format Logic /tb_io_entity_ctrl/pb_i
add wave -noupdate -format Logic /tb_io_entity_ctrl/pbsync_o
add wave -noupdate -format Logic /tb_io_entity_ctrl/i_io_entity_ctrl/s_1khzen
add wave -noupdate -format Logic /tb_io_entity_ctrl/i_io_entity_ctrl/s_enctr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {0 ps}
WaveRestoreZoo {0 ps} {1 ns}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -signalnamewidth 0
configure wave -justifyvalue left
run 10 ms
