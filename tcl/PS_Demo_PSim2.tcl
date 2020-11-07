# ----------------------------------------------------------
# Switch analysis views and apply load
# ----------------------------------------------------------
set_analysis_view -setup {av_ecsm} -hold {av_ecsm}

set_interactive_constraint_modes [all_constraint_modes -active]
set_load -pin_load 250 [get_ports {data_out*} -filter {port_direction == out}]
set_load -pin_load 250 [get_ports {use_dw*} -filter {port_direction == out}]
set_load -pin_load 250 [get_ports {full_n} -filter {port_direction == out}]
set_load -pin_load 250 [get_ports {empty_n} -filter {port_direction == out}]
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
read_activity_file -format VCD -scope fifo_tb.duv.fifo_duv -start {2050} \
    -end {2110} -block {} $postLayoutVcd

set_power -reset
set_dynamic_power_simulation -reset
set_dynamic_power_simulation -resolution 50ps

set_power_include_file ../src/pm.inc

report_power -outfile dynamic_power_vcd_av_ecsm.rpt -pg_net all -view av_ecsm -sort { total }

source ../src/dismedig/tcl/PS_Demo_PSim3.tcl