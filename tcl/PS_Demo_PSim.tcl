# ----------------------------------------------------------
# Custom variables, load design
# ----------------------------------------------------------
set libName "PS_Demo"
set cellName "PS_Demo"
set ictEmModels "../pdk/xh018/cadence/v7_1/QRC_pvs/v7_1_1/XH018_1151/QRC-Max/xx018_EM.ict.100000h"
set postLayoutVcd "../xcelium/wave_tb_PS_Demo_postlayout.vcd.gz"
restoreDesign -cellview [list $libName $cellName layout_06_signoff]

# ----------------------------------------------------------
# Switch analysis views and apply load
# ----------------------------------------------------------
set_analysis_view -setup {av_wc} -hold {av_wc}

set_interactive_constraint_modes [all_constraint_modes -active]
set_load -pin_load 250 [get_ports {res_da*} -filter {port_direction == inout}]
set_load -pin_load 250 [get_ports {scan_out} -filter {port_direction == out}]

# ----------------------------------------------------------
# Verify rms limits on signal wire with a toogle rate of 0.8
# ----------------------------------------------------------
setDelayCalMode -engine aae
verifyACLimitSetFreq -toggle 0.8
propagate_activity -set_net_freq true
mkdir signal_em

verifyACLimit -em_temperature 125 \
              -ict_em_models $ictEmModels \
              -method rms \
              -report ./signal_em/em_sig_125C.txt \
              -report_db \
              -use_db_freq

# ----------------------------------------------------------
# Verify rms limits on signal wire with a toogle rate from VCD 
# ----------------------------------------------------------
read_activity_file -reset
read_activity_file -format VCD -scope tb_PS_Demo.PS_Demo \
                   -block {} $postLayoutVcd -set_net_freq true
propagate_activity -set_net_freq true

verifyACLimit -em_temperature 125 \
              -ict_em_models $ictEmModels \
              -method rms \
              -report ./signal_em/em_sig_125C_VCD.txt \
              -report_db \
              -use_db_freq

# ----------------------------------------------------------
# Identify VCD windows with maximum activity
# ----------------------------------------------------------
read_activity_file -reset
read_activity_file -format VCD -scope tb_PS_Demo.PS_Demo \
                   -block {} $postLayoutVcd
report_vector_profile -step 45 -activity -outfile ./PS_Demo_vector_profile.txt

# ----------------------------------------------------------
# Static power analysis with VCD based stimuli
# ----------------------------------------------------------
set_power_analysis_mode -reset
set_power_analysis_mode -method static \
    -create_binary_db true \
    -decap_cell_list { DECAP25JIHD DECAP15JIHD DECAP10JIHD DECAP7JIHD DECAP5JIHD DECAP3JIHD } \
    -ignore_control_signals false \
    -write_static_currents true

set_power_output_dir -reset
set_power_output_dir ./static_power_vcd_av_wc

set_default_switching_activity -reset
read_activity_file -reset
read_activity_file -format VCD -scope tb_PS_Demo.PS_Demo -start {54000} \
    -end {57000} -block {} $postLayoutVcd

report_power
report_power -outfile static_power_vcd_av_wc.rpt -pg_net all -view av_wc -sort { total }

# ----------------------------------------------------------
# Static rail analysis
# ----------------------------------------------------------
set_rail_analysis_mode -method static \
    -accuracy hd \
    -decap_cell_list { DECAP25JIHD DECAP15JIHD DECAP10JIHD DECAP7JIHD DECAP5JIHD DECAP3JIHD } \
    -default_package_resistor 1 \
    -default_package_inductor 2e-9 \
    -default_package_capacitor 5e-12 \
    -em_temperature 125 \
    -ict_em_models $ictEmModels \
    -ignore_decaps false \
    -ignore_fillers false \
    -optimize_LEF_ports false \
    -power_grid_library { \
        ../powergrid/TECH_XH018/xh018_xx51_MET5_METMID_Typ_techonly.cl \
        ../powergrid/D_CELLS_JIHD/D_CELLS_JIHD_xx51_MET5_METMID_stdcells.cl \
        ../powergrid/IO_CELLS_F3V/IO_CELLS_F3V_xx51_MET5_METMID.cl \
        ../powergrid/XSPRAMLP_128X16P/macros_XSPRAMLP_128X16P.cl } \
    -process_techgen_em_rules true \
    -save_voltage_waveforms false \
    -temperature 125 \
    -use_em_view_list ../src/PS_Demo_EM_celllist.txt

set_pg_nets -net GND   -voltage 0    -threshold 0.1
set_pg_nets -net VDD   -voltage 1.62 -threshold 1.53
set_pg_nets -net VDDOR -voltage 3.0  -threshold 2.85
set_pg_nets -net vdd_A -voltage 1.62 -threshold 1.53
set_pg_nets -net vdd_R -voltage 1.62 -threshold 1.53

set_rail_analysis_domain \
        -name coreDomain \
        -pwrnets {VDD VDDOR vdd_A vdd_R} \
        -gndnets {GND}

set_power_pads -reset
set_power_pads -net GND   -format xy -file ../src/PS_Demo_GND.pp
set_power_pads -net VDD   -format xy -file ../src/PS_Demo_VDD.pp
set_power_pads -net VDDOR -format xy -file ../src/PS_Demo_VDDOR.pp
set_power_pads -net vdd_A -format xy -file ../src/PS_Demo_vdd_A.pp
set_power_pads -net vdd_R -format xy -file ../src/PS_Demo_vdd_R.pp

set_power_data -reset
set_power_data -format current [ list \
    ./static_power_vcd_av_wc/static_GND.ptiavg \
    ./static_power_vcd_av_wc/static_VDD.ptiavg \
    ./static_power_vcd_av_wc/static_VDDOR.ptiavg \
    ./static_power_vcd_av_wc/static_vdd_A.ptiavg \
    ./static_power_vcd_av_wc/static_vdd_R.ptiavg ]

analyze_rail -results_directory ./static_rail_vcd_av_wc -type domain coreDomain

# GND
# --------
read_power_rail_results -rail_directory ./static_rail_vcd_av_wc/coreDomain_125C_avg_1/GND \
                        -power_db ./static_power_vcd_av_wc/power.db

report_power_rail_results -plot ir -filename ./static_rail_vcd_av_wc/ir_GND.rpt -limit 50
report_power_rail_results -plot rj -filename ./static_rail_vcd_av_wc/rj_GND.rpt -limit 50

# VDD
# --------
read_power_rail_results -rail_directory ./static_rail_vcd_av_wc/coreDomain_125C_avg_1/VDD \
                        -power_db ./static_power_vcd_av_wc/power.db
			
report_power_rail_results -plot ir -filename ./static_rail_vcd_av_wc/ir_VDD.rpt -limit 50
report_power_rail_results -plot rj -filename ./static_rail_vcd_av_wc/rj_VDD.rpt -limit 50

# VDDOR
# --------
read_power_rail_results -rail_directory ./static_rail_vcd_av_wc/coreDomain_125C_avg_1/VDDOR \
                        -power_db ./static_power_vcd_av_wc/power.db

report_power_rail_results -plot ir -filename ./static_rail_vcd_av_wc/ir_VDDOR.rpt -limit 50
report_power_rail_results -plot rj -filename ./static_rail_vcd_av_wc/rj_VDDOR.rpt -limit 50

# vdd_A
# --------
read_power_rail_results -rail_directory ./static_rail_vcd_av_wc/coreDomain_125C_avg_1/vdd_A \
                        -power_db ./static_power_vcd_av_wc/power.db

report_power_rail_results -plot ir -filename ./static_rail_vcd_av_wc/ir_vdd_A.rpt -limit 50
report_power_rail_results -plot rj -filename ./static_rail_vcd_av_wc/rj_vdd_A.rpt -limit 50

# vdd_R
# --------
read_power_rail_results -rail_directory ./static_rail_vcd_av_wc/coreDomain_125C_avg_1/vdd_R \
                        -power_db ./static_power_vcd_av_wc/power.db

report_power_rail_results -plot ir -filename ./static_rail_vcd_av_wc/ir_vdd_R.rpt -limit 50
report_power_rail_results -plot rj -filename ./static_rail_vcd_av_wc/rj_vdd_R.rpt -limit 50

# ----------------------------------------------------------
# Switch analysis views and apply load
# ----------------------------------------------------------
set_analysis_view -setup {av_ecsm} -hold {av_ecsm}

set_interactive_constraint_modes [all_constraint_modes -active]
set_load -pin_load 250 [get_ports {res_da*} -filter {port_direction == inout}]
set_load -pin_load 250 [get_ports {scan_out} -filter {port_direction == out}]

# ----------------------------------------------------------
# Dynamic vectorbased power analysis ECSM
# ----------------------------------------------------------
set_power_analysis_mode -reset
set_power_analysis_mode -method dynamic_vectorbased \
    -create_binary_db true \
    -decap_cell_list { DECAP25JIHD DECAP15JIHD DECAP10JIHD DECAP7JIHD DECAP5JIHD DECAP3JIHD } \
    -disable_static false \
    -ignore_control_signals false \
    -write_static_currents false

set_power_output_dir -reset
set_power_output_dir ./dynamic_power_vcd_av_ecsm

set_default_switching_activity -reset
read_activity_file -reset
read_activity_file -format VCD -scope tb_PS_Demo.PS_Demo -start {54050} \
    -end {54095} -block {} $postLayoutVcd

set_power -reset
set_dynamic_power_simulation -reset
set_dynamic_power_simulation -resolution 50ps

set_power_include_file ../src/pm.inc

report_power -outfile dynamic_power_vcd_av_ecsm.rpt -pg_net all -view av_ecsm -sort { total }

# ----------------------------------------------------------
# Dynamic rail analysis ECSM
# ----------------------------------------------------------
set_rail_analysis_mode -method dynamic \
    -accuracy hd \
    -decap_cell_list { DECAP25JIHD DECAP15JIHD DECAP10JIHD DECAP7JIHD DECAP5JIHD DECAP3JIHD } \
    -default_package_resistor 1 \
    -default_package_inductor 2e-9 \
    -default_package_capacitor 5e-12 \
    -em_peak_analysis true \
    -em_temperature 125 \
    -ict_em_models $ictEmModels \
    -ignore_decaps false \
    -ignore_fillers false \
    -limit_number_of_steps false \
    -optimize_LEF_ports false \
    -power_grid_library { \
        ../powergrid/TECH_XH018/xh018_xx51_MET5_METMID_Typ_techonly.cl \
        ../powergrid/D_CELLS_JIHD/D_CELLS_JIHD_xx51_MET5_METMID_stdcells.cl \
        ../powergrid/IO_CELLS_F3V/IO_CELLS_F3V_xx51_MET5_METMID.cl \
        ../powergrid/XSPRAMLP_128X16P/macros_XSPRAMLP_128X16P.cl } \
    -process_techgen_em_rules true \
    -save_voltage_waveforms true \
    -temperature 125 \
    -use_em_view_list ../src/PS_Demo_EM_celllist.txt

set_pg_nets -net GND   -voltage 0    -threshold 0.1
set_pg_nets -net VDD   -voltage 1.62 -threshold 1.53
set_pg_nets -net VDDOR -voltage 3.0  -threshold 2.85
set_pg_nets -net vdd_A -voltage 1.62 -threshold 1.53
set_pg_nets -net vdd_R -voltage 1.62 -threshold 1.53

set_rail_analysis_domain \
        -name coreDomain \
        -pwrnets {VDD VDDOR vdd_A vdd_R} \
        -gndnets {GND}

set_power_pads -reset
set_power_pads -net GND   -format xy -file ../src/PS_Demo_GND.pp
set_power_pads -net VDD   -format xy -file ../src/PS_Demo_VDD.pp
set_power_pads -net VDDOR -format xy -file ../src/PS_Demo_VDDOR.pp
set_power_pads -net vdd_A -format xy -file ../src/PS_Demo_vdd_A.pp
set_power_pads -net vdd_R -format xy -file ../src/PS_Demo_vdd_R.pp

set_power_data -reset
set_power_data -format current [ list \
    ./dynamic_power_vcd_av_ecsm/dynamic_GND.ptiavg \
    ./dynamic_power_vcd_av_ecsm/dynamic_VDD.ptiavg \
    ./dynamic_power_vcd_av_ecsm/dynamic_VDDOR.ptiavg \
    ./dynamic_power_vcd_av_ecsm/dynamic_vdd_A.ptiavg \
    ./dynamic_power_vcd_av_ecsm/dynamic_vdd_R.ptiavg ]

analyze_rail -results_directory ./dynamic_rail_vcd_av_ecsm -type domain coreDomain

# GND
# --------
read_power_rail_results -rail_directory ./dynamic_rail_vcd_av_ecsm/coreDomain_125C_dynamic_1/GND \
                        -power_db ./dynamic_power_vcd_av_ecsm/power.db

report_power_rail_results -plot ir -filename ./dynamic_rail_vcd_av_ecsm/ir_GND.rpt -limit 50
report_power_rail_results -plot rj -filename ./dynamic_rail_vcd_av_ecsm/rj_GND.rpt -limit 50
report_power_rail_results -plot jrms -filename ./dynamic_rail_vcd_av_ecsm/rjms_GND.rpt -limit 50

# VDD
# --------
read_power_rail_results -rail_directory ./dynamic_rail_vcd_av_ecsm/coreDomain_125C_dynamic_1/VDD \
                        -power_db ./dynamic_power_vcd_av_ecsm/power.db
			
report_power_rail_results -plot ir -filename ./dynamic_rail_vcd_av_ecsm/ir_VDD.rpt -limit 50
report_power_rail_results -plot rj -filename ./dynamic_rail_vcd_av_ecsm/rj_VDD.rpt -limit 50
report_power_rail_results -plot jrms -filename ./dynamic_rail_vcd_av_ecsm/rjms_VDD.rpt -limit 50

# VDDOR
# --------
read_power_rail_results -rail_directory ./dynamic_rail_vcd_av_ecsm/coreDomain_125C_dynamic_1/VDDOR \
                        -power_db ./dynamic_power_vcd_av_ecsm/power.db

report_power_rail_results -plot ir -filename ./dynamic_rail_vcd_av_ecsm/ir_VDDOR.rpt -limit 50
report_power_rail_results -plot rj -filename ./dynamic_rail_vcd_av_ecsm/rj_VDDOR.rpt -limit 50
report_power_rail_results -plot jrms -filename ./dynamic_rail_vcd_av_ecsm/rjms_VDDOR.rpt -limit 50

# vdd_A
# --------
read_power_rail_results -rail_directory ./dynamic_rail_vcd_av_ecsm/coreDomain_125C_dynamic_1/vdd_A \
                        -power_db ./dynamic_power_vcd_av_ecsm/power.db

report_power_rail_results -plot ir -filename ./dynamic_rail_vcd_av_ecsm/ir_vdd_A.rpt -limit 50
report_power_rail_results -plot rj -filename ./dynamic_rail_vcd_av_ecsm/rj_vdd_A.rpt -limit 50
report_power_rail_results -plot jrms -filename ./dynamic_rail_vcd_av_ecsm/rjms_vdd_A.rpt -limit 50

# vdd_R
# --------
read_power_rail_results -rail_directory ./dynamic_rail_vcd_av_ecsm/coreDomain_125C_dynamic_1/vdd_R \
                        -power_db ./dynamic_power_vcd_av_ecsm/power.db
                        
report_power_rail_results -plot ir -filename ./dynamic_rail_vcd_av_ecsm/ir_vdd_R.rpt -limit 50
report_power_rail_results -plot rj -filename ./dynamic_rail_vcd_av_ecsm/rj_vdd_R.rpt -limit 50
report_power_rail_results -plot jrms -filename ./dynamic_rail_vcd_av_ecsm/rjms_vdd_R.rpt -limit 50

exit
