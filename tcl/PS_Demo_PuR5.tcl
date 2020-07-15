

# ----------------------------------------------------------
# Route design and optimization
# ----------------------------------------------------------
setDelayCalMode -SIAware true
setAnalysisMode -analysisType onChipVariation -cppr both

setPathGroupOptions reg2reg -slackAdjustment -3.7

routeDesign
optDesign -postRoute -setup -hold

# ----------------------------------------------------------
# Add filler
# ----------------------------------------------------------
setFillerMode -add_fillers_with_drc false
addFiller -prefix FILLCAP -cell DECAP25JIHD DECAP15JIHD DECAP10JIHD DECAP7JIHD DECAP5JIHD DECAP3JIHD
addFiller -prefix FILL -cell FEED25JIHD FEED15JIHD FEED10JIHD FEED7JIHD FEED5JIHD FEED3JIHD FEED2JIHD FEED1JIHD

pdi report_design

# ----------------------------------------------------------
# Save routed layout
# ----------------------------------------------------------
saveDesign -cellview [list $libName $cellName layout_05_route]


