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



# Simulation of P&R netlist
# -------------------------
cd ${work_dir}/../../xcelium
rm -rf work*/* work*/.* PS_Demo.sdf.X *postlayout*

xmvlog -work work_lib -cdslib ./cds.lib -logfile xmvlog_postlayout.log \
    -errormax 15 -update -linedebug -status -define DISPLAY_PD_PU_EN \
    ../pdk/xh018/diglibs/D_CELLS_JIHD/v4_1/verilog/v4_1_0/VLG_PRIMITIVES.v \
    ../pdk/xh018/diglibs/D_CELLS_JIHD/v4_1/verilog/v4_1_0/D_CELLS_JIHD.v \
    ../pdk/xh018/diglibs/IO_CELLS_F3V/v2_1/verilog/v2_1_0/IO_CELLS_F3V.v 
   # ../RAM/XSPRAMLP_128X16P/Frontend/XSPRAMLP_128X16P.v

xmvlog -work work_sub -cdslib ./cds.lib -append_log \
    -logfile xmvlog_postlayout.log -errormax 15 -update -linedebug \
    -status ../innovus/PS_Demo.v

xmvlog -work work_sub -cdslib ./cds.lib -append_log -sv \
    -logfile xmvlog_postlayout.log -errormax 15 -update -linedebug \
    -status  ../src/dismedig/fifo_ports_2020_ver1.sv  ../src/dismedig/fifo_top_duv_2020_ver2.sv      

xmvlog -work work -cdslib ./cds.lib -append_log -sv \
    -logfile xmvlog_postlayout.log -errormax 15 -update -linedebug \
    -define postlayout -status ../src/dismedig/fifo_top_test_2020_ver2.sv   ../src/dismedig/fifo_tb_2020_ver1.sv

xmelab -work work -cdslib ./cds.lib -timescale '1ns/10ps' \
    -logfile xmelab_postlayout.log -errormax 30 -access +wc \
    -nowarn CUVWSP -COV_CGSAMPLE -COVERAGE U -nowarn SDFNCAP -status work.fifo_tb

xmsim -GUI -ASSERT_COUNT_TRACES -cdslib ./cds.lib \
    -logfile xmsim_postlayout.log -errormax 15 -status work.fifo_tb:module \
    -input ../src/dismedig/tcl/xcelium_gen_vcd_postlayout.tcl

 gzip *.vcd

