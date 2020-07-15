

# ----------------------------------------------------------
# Special route
# ----------------------------------------------------------
source ../tcl/${cellName}_SRoute.tcl
#quitado de momento para la memoria
sroute -connect { blockPin padPin } -layerChangeRange { MET1 METTP } \
    -blockPinTarget { nearestTarget } -padPinPortConnect { allPort allGeom } \
    -padPinTarget { nearestTarget } -deleteExistingRoutes -allowJogging 1 \
    -crossoverViaLayerRange { MET1 METTP } -allowLayerChange 1 \
    -nets { GND vdd_R } -blockPin all \
    -targetViaLayerRange { MET1 METTP } -verbose

sroute -connect { padPin } -layerChangeRange { MET1 METTP } \
    -padPinPortConnect { allPort allGeom } -padPinTarget { blockring ring } \
    -deleteExistingRoutes -allowJogging 1 -crossoverViaLayerRange { MET1 METTP } \
    -nets { vdd_A } -allowLayerChange 1 -targetViaLayerRange { MET1 METTP } \
    -verbose

sroute -connect { corePin floatingStripe } -layerChangeRange { MET1 METTP } \
    -deleteExistingRoutes -allowJogging 1 -crossoverViaLayerRange { MET1 METTP } \
    -allowLayerChange 1 -nets { GND vdd_A } -targetViaLayerRange { MET1 METTP } \
    -verbose

# ----------------------------------------------------------
# Save layout with special/power routes
# ----------------------------------------------------------
saveDesign -cellview [list $libName $cellName layout_02_sroute]


