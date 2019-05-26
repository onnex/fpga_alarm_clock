#!/bin/tcsh

echo "Cleaning work"
rm -rf ../work/

echo "Mapping new work library"
cd ../
vlib work
cd sim/
vmap work ../work

echo "Starting compile"
vcom -93 -check_synthesis -pedanticerrors ../hdl/vhdl/seven_seg_lut.vhd
vcom -93 -check_synthesis -pedanticerrors ../hdl/vhdl/seven_seg_ctrl.vhd
vcom -93 -check_synthesis -pedanticerrors ../hdl/vhdl/seven_seg_input_gen.vhd
vcom -93 -check_synthesis -pedanticerrors ../hdl/vhdl/seven_seg_top.vhd

#vcom -93 -pedanticerrors ../tb/seven_seg_lut_tb.vhd
#vcom -93 -pedanticerrors ../tb/seven_seg_ctrl_tb.vhd
#vcom -93 -pedanticerrors ../tb/seven_seg_input_gen_tb.vhd
vcom -93 -pedanticerrors ../tb/seven_seg_top_tb.vhd

echo "Producing Makefile"
vmake >Makefile

echo "Done"
