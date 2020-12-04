#!/bin/csh

# Used tools
# ----------
# IC 6.1.7
# Innovus 18.1
# Voltus 18.1
# Genus 18.1
# Xcelium 18.03
# Ext 18.2
# Conformal 18.1

# General setup
# -------------

vlog -sv -work work -cover sbcet3 fifo_un_fichero.v
# vlog -reportprogress 300 -work work PS_Demo.v
vlog -sv -work work fifo_ports_2020_ver1.sv
vlog -work work -vopt -sv +define+VERIFICACION fifo_top_duv_2020_package_ver1.sv
vlog -reportprogress 300 -work work fifo_driver_new_def_2020_package_ver3.sv
vlog -reportprogress 300 -work work fifo_top_test_2020_package_ver3.sv
vlog -reportprogress 300 -work work fifo_tb_2020_ver1.sv
vsim -coverage -msgmode both -assertcover work.fifo_tb

