add wave -group top_level matrices_mult_tb/*
add wave -group dut matrices_mult_tb/dut/*

#data
add wave -group data_generator  matrices_mult_tb/dut/d/*

#sync
add wave -group sync_start  matrices_mult_tb/dut/s1/*
add wave -group sync_display  matrices_mult_tb/dut/s2/*


#main controller
add wave -group main_controller  matrices_mult_tb/dut/main3/*

add wave -group matrix matrices_mult_tb/dut/main3/inst_matrix_ram/* 
add wave -group mult1  matrices_mult_tb/dut/main3/mult1/*
add wave -group mult2  matrices_mult_tb/dut/main3/mult2/*
add wave -group mult3  matrices_mult_tb/dut/main3/mult3/*
add wave -group mult4  matrices_mult_tb/dut/main3/mult4/*


#convert
add wave -group num_convert  matrices_mult_tb/dut/num_c/*
add wave -group bcd_bin  matrices_mult_tb/dut/bin2bcd/*

add wave -group bcd1  matrices_mult_tb/dut/bcd1/*
add wave -group bcd2  matrices_mult_tb/dut/bcd2/*
add wave -group bcd3  matrices_mult_tb/dut/bcd3/*
add wave  -group bcd4  matrices_mult_tb/dut/bcd4/*



#does the automatic toggle leaf names command
config wave -signalnamewidth 1
