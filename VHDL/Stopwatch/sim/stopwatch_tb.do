vcom ../src/stopwatch.vhd
vcom ../src/stopwatch_tb.vhd



vsim stopwatch_tb

add wave -group my_first_group stopwatch_tb/*
add wave -group dut stopwatch_tb/DUT/*

add wave -group controller stopwatch_tb/DUT/C1/*
add wave -group pulse stopwatch_tb/DUT/P2/*
add wave -group counter stopwatch_tb/DUT/C2/*

##add wave -group dut -group S1 stopwatch/S1/*
##add wave -group groupS2 stopwatch_tb/DUT/S2/*
##add wave -group groupS3 stopwatch_tb/DUT/S3/*

##add wave -group groupC1 stopwatch_tb/DUT/C1/*
##add wave -group groupP1 stopwatch_tb/DUT/P1/*

run 4000 ns
