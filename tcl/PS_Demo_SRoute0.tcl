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


