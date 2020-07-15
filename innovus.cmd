#######################################################
#                                                     
#  Innovus Command Logging File                     
#  Created on Wed Jul 15 10:46:55 2020                
#                                                     
#######################################################

#@(#)CDS: Innovus v18.10-p002_1 (64bit) 05/29/2018 19:19 (Linux 2.6.18-194.el5)
#@(#)CDS: NanoRoute 18.10-p002_1 NR180522-1057/18_10-UB (database version 2.30, 418.7.1) {superthreading v1.46}
#@(#)CDS: AAE 18.10-p004 (64bit) 05/29/2018 (Linux 2.6.18-194.el5)
#@(#)CDS: CTE 18.10-p003_1 () May 15 2018 10:23:07 ( )
#@(#)CDS: SYNTECH 18.10-a012_1 () Apr 19 2018 01:27:21 ( )
#@(#)CDS: CPE v18.10-p005
#@(#)CDS: IQRC/TQRC 18.1.1-s118 (64bit) Fri Mar 23 17:23:45 PDT 2018 (Linux 2.6.18-194.el5)

set_global _enable_mmmc_by_default_flow      $CTE::mmmc_default
suppressMessage ENCEXT-2799
win
set init_gnd_net GND
set init_design_netlisttype OA
set init_design_settop 0
set init_abstract_view abstract
set init_verilog ../../genus/results/PS_Demo.v
set init_mmmc_file tcl/PS_Demo_mmmc.tcl
set init_layout_view layout
set init_io_file PS_Demo.io
set init_oa_design_lib PS_Demo
set init_oa_ref_lib {D_CELLS_JIHD IO_CELLS_F�V}
set init_oa_design_cell PS_Demo
set init_pwr_net {VDD VDDOR vdd_A vdd_R]}
init_design
set init_gnd_net GND
set init_design_netlisttype OA
set init_design_settop 0
set init_abstract_view abstract
set init_verilog ../../genus/results/PS_Demo.v
set init_mmmc_file tcl/PS_Demo_mmmc.tcl
set init_layout_view layout
set init_io_file PS_Demo.io
set init_oa_design_lib PS_Demo
set init_oa_ref_lib {D_CELLS_JIHD IO_CELLS_F3V}
set init_oa_design_cell PS_Demo
set init_pwr_net {VDD VDDOR vdd_A vdd_R}
init_design
set init_gnd_net GND
set init_design_netlisttype OA
set init_design_settop 0
set init_abstract_view abstract
set init_verilog ../../genus/results/PS_Demo.v
set init_mmmc_file tcl/PS_Demo_mmmc.tcl
set init_layout_view layout
set init_io_file PS_Demo.io
set init_oa_design_lib PS_Demo
set init_oa_ref_lib {list D_CELLS_JIHD IO_CELLS_F3V}
set init_oa_design_cell PS_Demo
set init_pwr_net {VDD VDDOR vdd_A vdd_R}
init_design
set init_mmmc_file ../../tcl/PS_Demo_mmmc.tcl
init_design
init_design
save_global prueba_innovus_fase0
init_design
set ::TimeLib::tsgMarkCellLatchConstructFlag 1
set defHierChar /
set distributed_client_message_echo 1
set distributed_mmmc_disable_reports_auto_redirection 0
set enc_enable_print_mode_command_reset_options 1
set init_abstract_view abstract
set init_design_netlisttype OA
set init_design_settop 0
set init_gnd_net GND
set init_io_file PS_Demo.io
set init_layout_view layout
set init_mmmc_file tcl/PS_Demo_mmmc.tcl
set init_oa_design_cell PS_Demo
set init_oa_design_lib PS_Demo
set init_oa_ref_lib {list D_CELLS_JIHD IO_CELLS_F3V}
set init_oa_search_lib {}
set init_original_verilog_files ../../genus/results/PS_Demo.v
set init_pwr_net {VDD VDDOR vdd_A vdd_R}
set init_verilog ../../genus/results/PS_Demo.v
set latch_time_borrow_mode max_borrow
set pegDefaultResScaleFactor 1
set pegDetailResScaleFactor 1
set report_inactive_arcs_format {from to when arc_type sense reason}
set soft_stack_size_limit 31
suppressMessage -silent GLOBAL-100
unsuppressMessage -silent GLOBAL-100
suppressMessage -silent GLOBAL-100
unsuppressMessage -silent GLOBAL-100
set timing_enable_default_delay_arc 1
set upf_hier_pg_port_support 0
init_design
set init_design_netlisttype Verilog
init_design
