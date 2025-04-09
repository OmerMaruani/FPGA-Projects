onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group sr /shift_register_tb/dut/CLK
add wave -noupdate -expand -group sr /shift_register_tb/dut/RST
add wave -noupdate -expand -group sr /shift_register_tb/dut/ENA
add wave -noupdate -expand -group sr /shift_register_tb/dut/L_Rn
add wave -noupdate -expand -group sr -radix hexadecimal /shift_register_tb/dut/shift_reg
add wave -noupdate -expand -group sr -radix hexadecimal /shift_register_tb/dut/Q
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {374892601 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 81
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {420 us}
