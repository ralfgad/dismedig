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

# -------------
set work_dir = $PWD

# Place and Route
# ---------------
cd ${work_dir}/../../innovus
rm -rf * .*
echo "INCLUDE ../virtuoso/cds.lib" > cds.lib

innovus -wait 180  

mv innovus.cmd innovus_PuR.cmd
mv innovus.log innovus_PuR.log
mv innovus.logv innovus_PuR.logv


