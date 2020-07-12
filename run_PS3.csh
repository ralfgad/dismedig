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

genus -wait 60 -legacy_ui -no_gui -overwrite -file ../src/dismedig/tcl/PS_Demo_synth.tcl

# Simulation of Synthesis netlist
# -------------------------------
cd ${work_dir}/xcelium
rm -rf work*/* work*/.* PS_Demo.sdf.X *postsyn*

xmvlog -work work_lib -cdslib ./cds.lib -logfile xmvlog_postsyn.log \
    -errormax 15 -update -linedebug -status -define DISPLAY_PD_PU_EN \
    ../pdk/xh018/diglibs/D_CELLS_JIHD/v4_1/verilog/v4_1_0/VLG_PRIMITIVES.v \
    ../pdk/xh018/diglibs/D_CELLS_JIHD/v4_1/verilog/v4_1_0/D_CELLS_JIHD.v \
    ../pdk/xh018/diglibs/IO_CELLS_F3V/v2_1/verilog/v2_1_0/IO_CELLS_F3V.v \
    ../RAM/XSPRAMLP_128X16P/Frontend/XSPRAMLP_128X16P.v

xmvlog -work work_sub -cdslib ./cds.lib -append_log \
    -logfile xmvlog_postsyn.log -errormax 15 -update -linedebug \
    -status ../genus/results/PS_Demo.v

xmvlog -work work -cdslib ./cds.lib -append_log \
    -logfile xmvlog_postsyn.log -errormax 15 -update -linedebug \
    -define postsyn -status ../src/tb_PS_Demo.v

xmelab -work work -cdslib ./cds.lib -timescale '1ns/10ps' \
    -logfile xmelab_postsyn.log -errormax 30 -access +wc \
    -nowarn CUVWSP -nowarn SDFNCAP -status work.tb_PS_Demo

xmsim -cdslib ./cds.lib \
    -logfile xmsim_postsyn.log -errormax 15 -status work.tb_PS_Demo:module \
    -input ../tcl/xcelium_gen_vcd_postsyn.tcl

# Place and Route
# ---------------
cd ${work_dir}/innovus
rm -rf * .*
echo "INCLUDE ../virtuoso/cds.lib" > cds.lib

innovus -wait 180 -files ../tcl/PS_Demo_PuR.tcl
mv innovus.cmd innovus_PuR.cmd
mv innovus.log innovus_PuR.log
mv innovus.logv innovus_PuR.logv

# Simulation of P&R netlist
# -------------------------
cd ${work_dir}/xcelium
rm -rf work*/* work*/.* PS_Demo.sdf.X *postlayout*

xmvlog -work work_lib -cdslib ./cds.lib -logfile xmvlog_postlayout.log \
    -errormax 15 -update -linedebug -status -define DISPLAY_PD_PU_EN \
    ../pdk/xh018/diglibs/D_CELLS_JIHD/v4_1/verilog/v4_1_0/VLG_PRIMITIVES.v \
    ../pdk/xh018/diglibs/D_CELLS_JIHD/v4_1/verilog/v4_1_0/D_CELLS_JIHD.v \
    ../pdk/xh018/diglibs/IO_CELLS_F3V/v2_1/verilog/v2_1_0/IO_CELLS_F3V.v \
    ../RAM/XSPRAMLP_128X16P/Frontend/XSPRAMLP_128X16P.v

xmvlog -work work_sub -cdslib ./cds.lib -append_log \
    -logfile xmvlog_postlayout.log -errormax 15 -update -linedebug \
    -status ../innovus/PS_Demo.v

xmvlog -work work -cdslib ./cds.lib -append_log \
    -logfile xmvlog_postlayout.log -errormax 15 -update -linedebug \
    -define postlayout -status ../src/tb_PS_Demo.v

xmelab -work work -cdslib ./cds.lib -timescale '1ns/10ps' \
    -logfile xmelab_postlayout.log -errormax 30 -access +wc \
    -nowarn CUVWSP -nowarn SDFNCAP -status work.tb_PS_Demo

xmsim -cdslib ./cds.lib \
    -logfile xmsim_postlayout.log -errormax 15 -status work.tb_PS_Demo:module \
    -input ../tcl/xcelium_gen_vcd_postlayout.tcl

gzip *.vcd

# Power and Rail simulation
# -------------------------
cd ${work_dir}/innovus
rm -rf static* dynamic* qrc* signal_em cellIDMap work voltus* *PSim* *vector_profile* TWFBinDir *power*

innovus -wait 180 -init ../tcl/PS_Demo_PSim.tcl
mv innovus.cmd innovus_PSim.cmd
mv innovus.log innovus_PSim.log
mv innovus.logv innovus_PSim.logv

rm -rf qrc* design.spef* */*/*/.matrix.solver* TWFBinDir
