
vlog ../src/shift_reg.v
vlog ../src/shift_reg_tb.v

vsim shift_reg_tb

add wave -group my_first_group shift_reg_tb/*
add wave -group DUT shift_reg_tb/dut/*

config wave -signalnamewidth 1
radix binary

restart -f
run 200ns