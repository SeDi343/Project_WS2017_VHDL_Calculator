vsim -t ns -novopt -lib work work.tb_alu_entity
view *
onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /tb_alu_entity/clk_i
add wave -noupdate -format Logic /tb_alu_entity/reset_i
add wave -noupdate -format Logic /tb_alu_entity/op1_i
add wave -noupdate -format Logic /tb_alu_entity/op2_i
add wave -noupdate -format Logic /tb_alu_entity/optype_i
add wave -noupdate -format Logic /tb_alu_entity/start_i
add wave -noupdate -format Logic /tb_alu_entity/i_alu_entity/s_progress
add wave -noupdate -format Logic /tb_alu_entity/finished_o
add wave -noupdate -format Logic /tb_alu_entity/result_o
add wave -noupdate -format Logic /tb_alu_entity/sign_o
add wave -noupdate -format Logic /tb_alu_entity/overflow_o
add wave -noupdate -format Logic /tb_alu_entity/error_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {0 ps}
WaveRestoreZoo {0 ps} {1 ns}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -signalnamewidth 0
configure wave -justifyvalue left
run 10 ms
