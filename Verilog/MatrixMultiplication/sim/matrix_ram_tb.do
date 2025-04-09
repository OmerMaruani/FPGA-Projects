
vlog ../src/matrix_ram.v
vlog ../src/matrix_ram_tb.v

vsim matrix_ram_tb

add wave -group my_first_group matrix_ram_tb/*
add wave -group dut matrix_ram_tb/dut/*


config wave -signalnamewidth 1

radix binary

# Change the radix for specific signals
radix signal sim:/matrix_ram_tb/dut/data signed
radix signal sim:/matrix_ram_tb/dut/address unsigned
radix signal sim:/matrix_ram_tb/dut/out decimal
radix signal sim:/matrix_ram_tb/dut/byteena unsigned





# Add exposed memory array (mem_array_out)
add wave sim:/matrix_ram_tb/dut/mem_array
radix signal sim:/matrix_ram_tb/dut/mem_array hex




restart -f
run 2000ns