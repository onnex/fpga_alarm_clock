onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /seven_seg_ctrl_tb/input_arr
add wave -noupdate -expand /seven_seg_ctrl_tb/output_arr
add wave -noupdate /seven_seg_ctrl_tb/input
add wave -noupdate /seven_seg_ctrl_tb/output
add wave -noupdate /seven_seg_ctrl_tb/clk
add wave -noupdate /seven_seg_ctrl_tb/rst_n
add wave -noupdate /seven_seg_ctrl_tb/active
add wave -noupdate -radix unsigned /seven_seg_ctrl_tb/number
add wave -noupdate /seven_seg_ctrl_tb/num_of_displays_c
add wave -noupdate /seven_seg_ctrl_tb/clk_period_c
add wave -noupdate /seven_seg_ctrl_tb/reset_down_c
add wave -noupdate /seven_seg_ctrl_tb/seven_seg_ctrl_1/display_active_in
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {87921 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 267
configure wave -valuecolwidth 355
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {18548 ps} {111292 ps}
