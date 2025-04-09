###restart -f
vcom ../src/controller.vhd
vcom ../src/controller_tb.vhd
vsim controller_tb
add wave -group my_first_group controller_tb/*

add wave -group dut controller_tb/DUT/*


run 500 ns	