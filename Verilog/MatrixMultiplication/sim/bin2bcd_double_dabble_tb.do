
vlog ../src/bin2bcd_double_dabble.v
vlog ../src/bin2bcd_double_dabble_tb.v

vsim bin2bcd_double_dabble_tb

add wave -group my_first_group bin2bcd_double_dabble_tb/*
add wave -group dut bin2bcd_double_dabble_tb/dut/*

config wave -signalnamewidth 1
radix binary

restart -f
run 1000ns