###restart -f
vcom ../src/pulse_generator_new.vhd
vcom ../src/pulse_generator_new_tb.vhd
vsim pulse_generator_new_tb
add wave -group my_first_group pulse_generator_new_tb/*


run 250 ns	