###restart -f
vcom ../src/pulse_generator_tb.vhd
vsim pulse_generator_tb
add wave -group my_first_group pulse_generator_tb/*


run 250 ns