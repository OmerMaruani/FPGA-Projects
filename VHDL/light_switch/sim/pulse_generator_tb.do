###restart -f
vcom ../src/pulse_generator.vhd
vcom ../src/pulse_generator_tb.vhd
vsim pulse_generator_tb

add wave -group tb pulse_generator_tb/*
add wave -group dut pulse_generator_tb/DUT/*


run 250 ns	