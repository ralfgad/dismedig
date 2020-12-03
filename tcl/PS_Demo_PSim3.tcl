
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
# set_pg_nets -net vdd_R -voltage 1.62 -threshold 1.53

set_rail_analysis_domain \
        -name coreDomain \
        -pwrnets {VDD VDDOR vdd_A } \
        -gndnets {GND}

set_power_pads -reset
set_power_pads -net GND   -format xy -file ../src/PS_Demo_GND.pp
set_power_pads -net VDD   -format xy -file ../src/PS_Demo_VDD.pp
set_power_pads -net VDDOR -format xy -file ../src/PS_Demo_VDDOR.pp
set_power_pads -net vdd_A -format xy -file ../src/PS_Demo_vdd_A.pp
# set_power_pads -net vdd_R -format xy -file ../src/PS_Demo_vdd_R.pp

set_power_data -reset
set_power_data -format current [ list \
    ./dynamic_power_vcd_av_ecsm/dynamic_GND.ptiavg \
    ./dynamic_power_vcd_av_ecsm/dynamic_VDD.ptiavg \
    ./dynamic_power_vcd_av_ecsm/dynamic_VDDOR.ptiavg \
    ./dynamic_power_vcd_av_ecsm/dynamic_vdd_A.ptiavg ]
   # ./dynamic_power_vcd_av_ecsm/dynamic_vdd_R.ptiavg ]

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
# read_power_rail_results -rail_directory ./dynamic_rail_vcd_av_ecsm/coreDomain_125C_dynamic_1/vdd_R \
#                        -power_db ./dynamic_power_vcd_av_ecsm/power.db
                        
#report_power_rail_results -plot ir -filename ./dynamic_rail_vcd_av_ecsm/ir_vdd_R.rpt -limit 50
# report_power_rail_results -plot rj -filename ./dynamic_rail_vcd_av_ecsm/rj_vdd_R.rpt -limit 50
# report_power_rail_results -plot jrms -filename ./dynamic_rail_vcd_av_ecsm/rjms_vdd_R.rpt -limit 50
