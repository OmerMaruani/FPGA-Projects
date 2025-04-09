
vlog ../src/data_generator.v
vlog ../src/data_generator_tb.v

vsim data_generator_tb

add wave -group my_first_group data_generator_tb/*
add wave -group dut data_generator_tb/dut/*

config wave -signalnamewidth 1

radix binary

# Change the radix for specific signals
radix signal sim:/data_generator_tb/dut/dout signed
radix signal sim:/data_generator_tb/dut/index decimal



restart -f
run 1000ns