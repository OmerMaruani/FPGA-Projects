###restart -f
vcom ../src/counter.vhd
vcom ../src/counter_tb.vhd
vsim counter_tb
add wave -group my_first_group counter_tb/*
add wave -group group2 counter_tb/DUT/*


##add wave dut counter_tb/DUT/*


run 13000 ns	