
vlog ../src/top_level.v
vlog ../src/top_level_tb.v

vsim top_level_tb

add wave -group my_first_group top_level_tb/*
add wave -group DUT top_level_tb/dut/*

add wave -group pulse_generator top_level_tb/dut/pulse/*
add wave -group shift_reg top_level_tb/dut/shift/*
add wave -group direction top_level_tb/dut/dir/*


config wave -signalnamewidth 1
radix binary

restart -f
run 1000ns