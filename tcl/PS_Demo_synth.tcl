#-------------------------------------------------------------------------------
# Info and path setup
#-------------------------------------------------------------------------------

if {[file exists /proc/cpuinfo]} {
    sh grep "model name" /proc/cpuinfo
    sh grep "cpu MHz"    /proc/cpuinfo
}

puts "Hostname : [info hostname]"

set DESIGN  "PS_Demo"
set DATE [clock format [clock seconds] -format "%b%d-%T"] 
set OUTPUTS_PATH ./results
set REPORTS_PATH ./reports

#-------------------------------------------------------------------------------
# Attributes
#-------------------------------------------------------------------------------
set_attribute information_level 3
set_attribute remove_assigns true
set_attribute ignore_preserve_in_tiecell_insertion true
set_attribute auto_ungroup none

set_attribute lp_power_unit mW
set_attribute lp_insert_clock_gating true
set_attribute lp_power_analysis_effort medium
set_attribute leakage_power_effort low

#-------------------------------------------------------------------------------
# Library setup
#-------------------------------------------------------------------------------
set_attribute library { ../liberty/D_CELLS_JIHD_LPMOS_slow_1_62V_125C.lib.gz \
                        ../liberty/IO_CELLS_F3V_LPMOS_slow_1_62V_3_00V_125C.lib.gz \
                        ../liberty/XSPRAMLP_128X16P_CPF_slow_1_62V_125C.lib.gz }

set_attribute lef_library { ../pdk/xh018/cadence/v7_0/techLEF/v7_0_3/xh018_xx51_HD_MET5_METMID.lef \
    	    	    	    ../pdk/xh018/diglibs/D_CELLS_JIHD/v4_1/LEF/v4_1_0/xh018_D_CELLS_JIHD.lef \
    	    	    	    ../pdk/xh018/diglibs/D_CELLS_JIHD/v4_1/LEF/v4_1_0/xh018_xx51_MET5_METMID_D_CELLS_JIHD_mprobe.lef \
    	    	    	    ../pdk/xh018/diglibs/IO_CELLS_F3V/v2_1/LEF/v2_1_0/xh018_xx51_MET5_METMID_IO_CELLS_F3V.lef \
    	    	    	    ../RAM/XSPRAMLP_128X16P/Frontend/XSPRAMLP_128X16P.lef } 

set_attribute cap_table_file { ../pdk/xh018/cadence/v7_0/capTbl/v7_0_2/xh018_xx51_MET5_METMID_typ.capTbl }

set_attribute operating_conditions slow_1_62V_125C

set_attribute avoid false {LGC* LSGC* LSOGC*}

#------------------------------------------------------------------------------- 
# Read design
#-------------------------------------------------------------------------------
read_hdl -sv {  \
    ../src/dismedig/fifo_un_fichero.sv  }

read_hdl -v2001 {  \
    ../src/dismedig/PS_Demo.v }
elaborate ${DESIGN} 

check_design -unresolved -multidriven

#-------------------------------------------------------------------------------
# Constraints
#-------------------------------------------------------------------------------
create_clock -name "CLK_ext" -add -period 10.0 -waveform {5.0 10.0} [get_ports clk]

set_input_transition 0.3 [get_ports rst_n]
set_input_transition 0.3 [get_ports clk]
set_input_transition 0.3 [get_ports write]
set_input_transition 0.3 [get_ports read]
set_input_transition 0.3 [get_ports scan_enable]
set_input_transition 0.3 [get_ports scan_in]
set_input_transition 0.3 [get_ports test_mode]
set_input_transition 0.3 [get_ports data_in*]



set_load -pin_load -max 0.25 [get_ports data_out*]
set_load -pin_load -max 0.25 [get_ports use_dw*]
set_load -pin_load -max 0.25 [get_ports scan_out]
set_load -pin_load -max 0.25 [get_ports empty_n]
set_load -pin_load -max 0.25 [get_ports full_n]

#set_false_path -from [get_ports control]
#set_false_path -from [get_ports wen] -through P* -to [get_ports res_da*]

set_output_delay -clock CLK_ext -add_delay 4.0 [get_ports data_out*]
set_output_delay -clock CLK_ext -add_delay 4.0 [get_ports use_dw*]
set_output_delay -clock CLK_ext -add_delay 4.0 [get_ports empty_n]
set_output_delay -clock CLK_ext -add_delay 4.0 [get_ports full_n]

set_dont_touch  /designs/PS_Demo/core/sm_trig1
set_dont_touch  /designs/PS_Demo/core/sm_trig2

set_dont_use [get_lib_cells */SDFF*]
set_dont_use [get_lib_cells */DFF*]

set_dont_use [get_lib_cells */SDFRRSJIHDX*]
set_dont_use [get_lib_cells */DFRRSJIHDX*]

set_dont_use [get_lib_cells */SDFRRSQJIHDX*]
set_dont_use [get_lib_cells */DFRRSQJIHDX*]

set_dont_use [get_lib_cells */LSGCPJIHDX0]
set_dont_use [get_lib_cells */LSGCPJIHDX2]

#-------------------------------------------------------------------------------
# Define cost groups (clock-clock, clock-output, input-clock, input-output)
#-------------------------------------------------------------------------------
if {[llength [all::all_seqs]] > 0} { 
    define_cost_group -name I2C -design $DESIGN
    define_cost_group -name C2O -design $DESIGN
    define_cost_group -name C2C -design $DESIGN
    path_group -from [all::all_seqs] -to [all::all_seqs] -group C2C -name C2C
    path_group -from [all::all_seqs] -to [all::all_outs] -group C2O -name C2O
    path_group -from [all::all_inps] -to [all::all_seqs] -group I2C -name I2C
}

define_cost_group -name I2O -design $DESIGN
path_group -from [all::all_inps]  -to [all::all_outs] -group I2O -name I2O

foreach cg [find / -cost_group *] {
    report timing -cost_group [list $cg] >> $REPORTS_PATH/${DESIGN}_timing_presyn.rpt
}

#-------------------------------------------------------------------------------
# DFT
#-------------------------------------------------------------------------------
set_attribute dft_scan_style muxed_scan
set_attribute dft_prefix DFT_
set_attribute dft_identify_top_level_test_clocks true
set_attribute dft_identify_test_signals true
set_attribute dft_identify_internal_test_clocks false
set_attribute use_scan_seqs_for_non_dft true
set_attribute dft_lockup_element_type preferred_edge_sensitive "/designs/$DESIGN"
set_attribute dft_mix_clock_edges_in_scan_chains true "/designs/$DESIGN"
set_attribute lp_clock_gating_control_point precontrol "/designs/$DESIGN"

define_dft shift_enable -name scan_enable             -active high core/scan_enable
define_dft test_mode    -name test_mode   -scan_shift -active high core/test_mode
define_dft scan_chain   -name scan_f      -sdi core/scan_in -sdo core/scan_out

check_dft_rules > $REPORTS_PATH/${DESIGN}_dft_rules_before_synth
report dft_setup > $REPORTS_PATH/${DESIGN}_dft_setup_tdrc

#-------------------------------------------------------------------------------
# Synthesize to generic
#-------------------------------------------------------------------------------
syn_gen

report datapath > $REPORTS_PATH/${DESIGN}_datapath_generic.rpt
check_dft_rules > $REPORTS_PATH/${DESIGN}_dft_rules
report dft_registers > $REPORTS_PATH/${DESIGN}_dft_register
set_attribute lp_clock_gating_test_signal test_mode "/designs/$DESIGN"

set numDFTviolations [check_dft_rules]
if {$numDFTviolations > "0"} {
    report dft_violations > $REPORTS_PATH/${DESIGN}_dft_violations_before_fixing_intermed
    fix_dft_violations -async_reset -async_set -clock -test_control test_mode
    check_dft_rules > $REPORTS_PATH/${DESIGN}_dft_rules_after_fixing_intermed
}

#-------------------------------------------------------------------------------
# Synthesize to gates
#-------------------------------------------------------------------------------
syn_map

check_dft_rules > $REPORTS_PATH/${DESIGN}_dft_rules_before_connecting

connect_scan_chains -chains scan_f

report dft_chains > $REPORTS_PATH/${DESIGN}_dft_chain
report clock_gating -detail

set_attribute ui_respects_preserve false
set_attribute use_tiehilo_for_const unique

delete_unloaded_undriven -all -force_bit_blast $DESIGN

set all_regs [dc::all_registers]
path_adjust -from $all_regs -to $all_regs -delay -2000 -name PA_C2C 

syn_opt

#-------------------------------------------------------------------------------
# Reporting and export
#-------------------------------------------------------------------------------
report gates -power > $REPORTS_PATH/${DESIGN}_gates_power.rpt
report area > $REPORTS_PATH/${DESIGN}_area.rpt

foreach cg [find / -cost_group *] {
    report timing -cost_group [list $cg] >> $REPORTS_PATH/${DESIGN}_timing_final.rpt
}

check_dft_rules > $REPORTS_PATH/${DESIGN}_dft_rules_after_synth
write_design -basename $OUTPUTS_PATH/${DESIGN}
write_sdc -exclude "set_ideal_network set_dont_use group_path \
                    set_max_dynamic_power set_max_leakage_power \
                    set_units set_operating_conditions" > $OUTPUTS_PATH/${DESIGN}.sdc

write_scandef > $OUTPUTS_PATH/${DESIGN}.scan.def
write_sdf -timescale ns -edges check_edge -delimiter "/" > $OUTPUTS_PATH/${DESIGN}.sdf

# exit
