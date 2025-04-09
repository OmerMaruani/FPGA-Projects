vcom ../src/light_organ.vhd
vcom ../src/light_organ_tb.vhd



vsim light_organ_tb

add wave -group my_first_group light_organ_tb/*
add wave -group dut light_organ_tb/DUT/*
run 1000 ns

