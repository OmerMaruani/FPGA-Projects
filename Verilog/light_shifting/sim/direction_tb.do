
vlog ../src/direction.v
vlog ../src/direction_tb.v

vsim direction_tb

add wave -group my_first_group direction_tb/*
add wave -group DUT direction_tb/dut/*

config wave -signalnamewidth 1
radix binary

restart -f
run 200ns