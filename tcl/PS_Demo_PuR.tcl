# ----------------------------------------------------------
# Custom variables
# ----------------------------------------------------------
set libName "PS_Demo"
set cellName "PS_Demo"
set refLibs [list D_CELLS_JIHD IO_CELLS_F3V XSPRAMLP_128X16P]
set verilogFile "../genus/results/${cellName}.v"
set scanDef "../genus/results/${cellName}.scan.def"
set ioFile "../src/dismedig/${cellName}.io"
set mmmcFile "../tcl/${cellName}_mmmc.tcl"
set powerNets [list VDD VDDOR vdd_A vdd_R]
set groundNets [list GND]

# ----------------------------------------------------------
# Definition of Innovus variables
# ----------------------------------------------------------
setOaxMode -compressLevel 0
setOaxMode -allowBitConnection true
setOaxMode -allowTechUpdate false
setOaxMode -updateMode true
#setGenerateViaMode -auto true
setOaxMode -pinPurpose true
setDesignMode -process 180
setViaGenMode -symmetrical_via_only true

# ----------------------------------------------------------
# Globals
# ----------------------------------------------------------
set_table_style -no_frame_fix_width
set_global timing_report_enable_auto_column_width true
setMultiCpuUsage -localCpu 4

# ----------------------------------------------------------
# Import and initialization of design
# ----------------------------------------------------------
set init_oa_design_lib      $libName
set init_top_cell   	    $cellName
set init_oa_ref_lib 	    $refLibs
set init_verilog    	    $verilogFile
set init_io_file    	    $ioFile
set init_mmmc_file  	    $mmmcFile
set init_pwr_net    	    $powerNets
set init_gnd_net    	    $groundNets
set init_abstract_view      abstract
set init_layout_view        layout
init_design

# ----------------------------------------------------------
# Save initialization
# ----------------------------------------------------------
saveDesign -cellview [list $libName $cellName layout_00_init]


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


# ----------------------------------------------------------
# Special route
# ----------------------------------------------------------
source ../tcl/${cellName}_SRoute.tcl

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


# ----------------------------------------------------------
# Clock tree synthesis
# ----------------------------------------------------------
timeDesign -preCTS
timeDesign -preCTS -hold

delete_ccopt_clock_tree_spec
create_ccopt_clock_tree_spec -file ccopt.spec

source ccopt.spec

set_ccopt_property allow_resize_of_dont_touch_cells false

set_ccopt_mode -cts_inverter_cells {INJIHDX0 INJIHDX1 INJIHDX3 INJIHDX4 INJIHDX6 INJIHDX8 INJIHDX12} \
               -cts_buffer_cells {BUJIHDX0 BUJIHDX1 BUJIHDX3 BUJIHDX4 BUJIHDX6 BUJIHDX8 BUJIHDX12}

ccopt_design -cts

optDesign -postCTS
optDesign -postCTS -hold

# ----------------------------------------------------------
# Save layout with clocktree
# ----------------------------------------------------------
saveDesign -cellview [list $libName $cellName layout_04_cts]


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
# Cleanup, tambien comentado por no tener RAM
# ----------------------------------------------------------
deleteHaloFromBlock core/RAM

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
