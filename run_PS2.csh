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
set work_dir = $PWD

# Simulation of Verilog netlist

cd ${work_dir}/../../genus
rm -rf * .*

genus -wait 60 -legacy_ui  -gui -overwrite  -file ../src/dismedig/tcl/PS_Demo_synth.tcl

