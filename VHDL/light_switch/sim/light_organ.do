###restart -f
vcom ../src/light_organ.vhd
vsim light_organ
add wave -group my_first_group light_organ/*




force RESET 1 0, 0 60ns , 1 70 ns

force RATE 0 0, 1 40ns , 0 70 ns

force CLK 1 0, 0 {2.5 ns} -r 5ns

run 100ns