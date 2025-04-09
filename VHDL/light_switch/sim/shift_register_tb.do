vcom ../src/shift_register.vhd
vcom ../src/shift_register_tb.vhd

vsim shift_register_tb




add wave -group tb shift_register_tb/*
add wave -group dut shift_register_tb/DUT/*



run 400 us