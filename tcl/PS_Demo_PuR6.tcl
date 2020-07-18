

# ----------------------------------------------------------
# Signoff extraction and timing
# ----------------------------------------------------------
setExtractRCMode -engine postRoute \
                 -effortLevel signoff \
                 -qrcRunMode sequential \
                 -useQrcOAInterface true \
                 -lefTechFileMap ../src/lef_QRC_Map_x018.map

extractRC

timeDesign -signOff -reportOnly
timeDesign -signOff -hold -reportOnly

# ----------------------------------------------------------
# Verification
# ----------------------------------------------------------
verifyConnectivity -report verifyConn.rpt
verify_drc -report verifyDrc.rpt
verifyProcessAntenna -report verifyProcessAnt.rpt

# ----------------------------------------------------------
# Cleanup, gadea tambien comentado por no tener RAM
# ----------------------------------------------------------
# deleteHaloFromBlock core/RAM

# ----------------------------------------------------------
# Data export
# ----------------------------------------------------------
saveNetlist ${cellName}.v -excludeLeafCell
saveNetlist ${cellName}_phys.v -excludeLeafCell \
    -includePhysicalCell { ANTENNACELLNP2JIHD DECAP25JIHD DECAP15JIHD DECAP10JIHD DECAP7JIHD DECAP5JIHD DECAP3JIHD }

set dbgLefDefOutVersion 5.8
defOut -floorplan -routing ${cellName}.def

rcOut -view av_wc -spef ${cellName}_wc.spef

write_sdf -setuphold merge_always \
          -recrem merge_always -version 3.0 \
          -min_view av_bc -max_view av_wc \
          -target_application verilog ${cellName}.sdf

# ----------------------------------------------------------
# reset to ensure that Tempus license isn't checked out after next restoreDesign
# ----------------------------------------------------------
setDelayCalMode -reset

# ----------------------------------------------------------
# Save signoff layout with RC database
# ----------------------------------------------------------
saveDesign -cellview [list $libName $cellName layout_06_signoff] -rc


# exit
