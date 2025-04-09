
vcom ../src/direction.vhd
vsim direction
add wave -group my_first_group direction/*


force Q 0000 0, 1000 20 ns, 0001 50 ns
force RST 1 0, 0 100 ns
force CLK 1 0, 0 {2.5 ns} -r 5ns

run 250 ns

