


# ----------------------------------------------------------
# Expand path groups
# ----------------------------------------------------------
createBasicPathGroups -expanded

# ----------------------------------------------------------
# Check timing constraints and design
# Check timing in preplace mode
# ----------------------------------------------------------
check_timing -verbose
checkDesign -all

# ----------------------------------------------------------
# Import of scan chains
# ----------------------------------------------------------
defIn $scanDef
setScanReorderMode -scanEffort high

# ----------------------------------------------------------
# Mode settings
# ----------------------------------------------------------
setPlaceMode -place_global_clock_gate_aware false \
             -place_global_place_io_pins false \
             -place_global_reorder_scan true \
             -place_detail_preroute_as_obs {}

setNanoRouteMode -drouteUseMultiCutViaEffort high \
                 -drouteUseMinSpacingForBlockage false \
                 -routeInsertAntennaDiode true \
                 -routeAntennaCellName "ANTENNACELLNP2JIHD"

setOptMode -clkGateAware false \
           -fixDRC true \
           -fixFanoutLoad true \
           -timeDesignCompressReports false \
           -usefulSkew true

# ----------------------------------------------------------
# Placement
# ----------------------------------------------------------
place_opt_design

checkPlace -ignoreOutOfCore ${cellName}.checkPlace

# ----------------------------------------------------------
# Save placed layout
# ----------------------------------------------------------
saveDesign -cellview [list $libName $cellName layout_03_place]