# ----------------------------------------------------------
# Custom variables, load design
# ----------------------------------------------------------
set libName "PS_Demo"
set cellName "PS_Demo"
set ictEmModels "../pdk/xh018/cadence/v7_1/QRC_pvs/v7_1_1/XH018_1151/QRC-Max/xx018_EM.ict.100000h"
set postLayoutVcd "../xcelium/fifo.vcd.gz"
restoreDesign -cellview [list $libName $cellName layout_06_signoff]

# ----------------------------------------------------------
# Switch analysis views and apply load
# ----------------------------------------------------------
set_analysis_view -setup {av_wc} -hold {av_wc}

set_interactive_constraint_modes [all_constraint_modes -active]
set_load -pin_load 250 [get_ports {data_out*} -filter {port_direction == out}]
set_load -pin_load 250 [get_ports {use_dw*} -filter {port_direction == out}]
set_load -pin_load 250 [get_ports {full_n} -filter {port_direction == out}]
set_load -pin_load 250 [get_ports {empty_n} -filter {port_direction == out}]
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




