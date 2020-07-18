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





# Power and Rail simulation
# -------------------------
cd ${work_dir}/../../innovus
rm -rf static* dynamic* qrc* signal_em cellIDMap work voltus* *PSim* *vector_profile* TWFBinDir *power*

innovus -wait 180 -init ../src/dismedig/tcl/PS_Demo_PSim0.tcl
mv innovus.cmd innovus_PSim.cmd
mv innovus.log innovus_PSim.log
mv innovus.logv innovus_PSim.logv

rm -rf qrc* design.spef* */*/*/.matrix.solver* TWFBinDir
