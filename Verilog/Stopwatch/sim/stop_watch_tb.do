
vlog ../src/stop_watch.v

vlog ../src/bcd_to7seg.v
vlog ../src/controller.v
vlog ../src/counter.v
vlog ../src/pulse_generator.v
vlog ../src/sync.v



vlog ../src/stop_watch_tb.v

vsim stop_watch_tb

add wave -group my_first_group stop_watch_tb/*
add wave -group DUT stop_watch_tb/dut/*


add wave -group control stop_watch_tb/dut/control/*
add wave -group pulse_gen stop_watch_tb/dut/pulse_gen/*
add wave -group counter1 stop_watch_tb/dut/counter1/*



config wave -signalnamewidth 1
radix unsigned


restart -f
run 1000ns