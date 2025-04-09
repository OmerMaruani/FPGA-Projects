
vlog ../src/pulse_generator.v
vlog ../src/pulse_generator_tb.v

vsim pulse_generator_tb

add wave -group my_first_group pulse_generator_tb/*
add wave -group DUT pulse_generator_tb/dut/*

config wave -signalnamewidth 1
radix binary

restart -f
run 1000ns