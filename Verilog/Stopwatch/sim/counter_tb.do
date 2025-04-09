
vlog ../src/counter.v
vlog ../src/counter_tb.v

vsim counter_tb

add wave -group my_first_group counter_tb/*
add wave -group DUT counter_tb/dut/*

config wave -signalnamewidth 1
radix unsigned

restart -f
run 10000ns