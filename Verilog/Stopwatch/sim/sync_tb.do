
vlog ../src/sync.v
vlog ../src/sync_tb.v

vsim sync_tb

add wave -group my_first_group sync_tb/*
add wave -group DUT sync_tb/dut/*

config wave -signalnamewidth 1
radix binary

restart -f
run 1000ns