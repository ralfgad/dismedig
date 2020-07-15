


# ----------------------------------------------------------
# Read IO file, define floorplan, add IO filler
# ----------------------------------------------------------
floorPlan -siteOnly core_jihd \
          -b   0.00   0.00 1430.00 1430.00 \
             160.00 160.00 1270.00 1270.00 \
             220.50 220.21 1209.46 1210.29 \
          -noSnapToGrid

loadIoFile $ioFile

addIoFiller -cell FILLER100F FILLER84F FILLER50F FILLER40F FILLER20F FILLER10F FILLER05F FILLER02F FILLER01F -prefix IOFILLER

# ----------------------------------------------------------
# Placement of IPs, comentado porque no hay ram ahora
# ----------------------------------------------------------
# create_relative_floorplan -place core/RAM \
#                          -ref_type core_boundary \
#                          -orient R0 \
#                          -horizontal_edge_separate {1 0.0 1} \
#                          -vertical_edge_separate {0 0.0 0}

# restartaddHaloToBlock 0 40 9 0 core/RAM

# ----------------------------------------------------------
# Global P/G net connections
# ----------------------------------------------------------
clearGlobalNets

# Core
globalNetConnect vdd_A -type pgpin -pin vddi -inst * -module {} -verbose
globalNetConnect GND   -type pgpin -pin gndi -inst * -module {} -verbose

# RAM
globalNetConnect vdd_R -type pgpin -pin VDD18M -singleInstance core/RAM -verbose
globalNetConnect GND   -type pgpin -pin VSSM   -singleInstance core/RAM -verbose

# IO fillers / CORNERESDF / VDDPADF / ISF / BT24F / BBCUD24F
globalNetConnect VDD   -type pgpin -pin VDD   -inst * -module {} -verbose -override
globalNetConnect VDDOR -type pgpin -pin VDDO  -inst * -module {} -verbose -override
globalNetConnect VDDOR -type pgpin -pin VDDR  -inst * -module {} -verbose -override
globalNetConnect GND   -type pgpin -pin GNDO  -inst * -module {} -verbose -override
globalNetConnect GND   -type pgpin -pin GNDR  -inst * -module {} -verbose -override

# VDDORPADF
globalNetConnect VDDOR -type pgpin -pin VDDOR -inst * -module {} -verbose -override

# VDDCPADF
globalNetConnect vdd_A -type pgpin -pin VDDC  -inst * -module {} -verbose -override

# VDDIPADF
globalNetConnect vdd_R -type pgpin -pin VDDI  -singleInstance P42 -verbose -override

# GNDORPADF
globalNetConnect GND   -type pgpin -pin GNDOR -inst * -module {} -verbose -override

# ----------------------------------------------------------
# Save floorplan layout
# ----------------------------------------------------------
saveDesign -cellview [list $libName $cellName layout_01_fplan]

