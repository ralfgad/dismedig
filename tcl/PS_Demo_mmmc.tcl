#-------------------------------------------------------------------------------
#   define library_set
#-------------------------------------------------------------------------------

# slow timing
create_library_set -name ls_wc -timing { \
    ../../liberty/IO_CELLS_F3V_LPMOS_slow_1_62V_3_00V_125C.lib.gz \
    ../../liberty/D_CELLS_JIHD_LPMOS_slow_1_62V_125C.lib.gz \
    ../../liberty/XSPRAMLP_128X16P_CPF_slow_1_62V_125C.lib.gz } \
    -si { \
    ../../celticDB/IO_CELLS_F3V/IO_CELLS_F3V_LPMOS_slow_1_62V_3_00V_125C.cdB \
    ../../celticDB/D_CELLS_JIHD/D_CELLS_JIHD_LPMOS_slow_1_62V_125C.cdB }

# fast timing
create_library_set -name ls_bc -timing { \
    ../../liberty/IO_CELLS_F3V_LPMOS_fast_1_98V_3_60V_m40C.lib.gz \
    ../../liberty/D_CELLS_JIHD_LPMOS_fast_1_98V_m40C.lib.gz \
    ../../liberty/XSPRAMLP_128X16P_CPF_fast_1_98V_m40C.lib.gz } \
    -si { \
    ../../celticDB/IO_CELLS_F3V/IO_CELLS_F3V_LPMOS_fast_1_98V_3_60V_m40C.cdB \
    ../../celticDB/D_CELLS_JIHD/D_CELLS_JIHD_LPMOS_fast_1_98V_m40C.cdB }

# power at slow timing
create_library_set -name ps_ecsm -timing { \
    ../../liberty/IO_CELLS_F3V_LPMOS_ecsm_power_slow_1_62V_3_00V_125C.lib.gz \
    ../../liberty/D_CELLS_JIHD_LPMOS_ecsm_power_slow_1_62V_125C.lib.gz \
    ../../liberty/XSPRAMLP_128X16P_CPF_slow_1_62V_125C.lib.gz }

#-------------------------------------------------------------------------------
#   create rc_corner
#-------------------------------------------------------------------------------

create_rc_corner -name rc_cWorst -T 125 \
    -qx_tech_file ../../pdk/xh018/cadence/v7_1/QRC_pvs/v7_1_1/XH018_1151/QRC-Max/qrcTechFile \
    -cap_table ../../pdk/xh018/cadence/v7_0/capTbl/v7_0_2/xh018_xx51_MET5_METMID_max.capTbl

create_rc_corner -name rc_cBest -T -40 \
    -qx_tech_file ../../pdk/xh018/cadence/v7_1/QRC_pvs/v7_1_1/XH018_1151/QRC-Min/qrcTechFile \
    -cap_table ../../pdk/xh018/cadence/v7_0/capTbl/v7_0_2/xh018_xx51_MET5_METMID_min.capTbl

#-------------------------------------------------------------------------------
#   create constraint_mode
#-------------------------------------------------------------------------------

create_constraint_mode -name cm -sdc_files ../../genus/results/PS_Demo.sdc

#-------------------------------------------------------------------------------
#   create delay_corner
#-------------------------------------------------------------------------------

create_delay_corner -name dc_wc -library_set ls_wc -rc_corner rc_cWorst
create_delay_corner -name dc_bc -library_set ls_bc -rc_corner rc_cBest 

create_delay_corner -name dc_ecsm -library_set ps_ecsm -rc_corner rc_cWorst

#-------------------------------------------------------------------------------
#   create analysis_view
#-------------------------------------------------------------------------------

create_analysis_view -name av_wc -delay_corner dc_wc -constraint_mode cm
create_analysis_view -name av_bc -delay_corner dc_bc -constraint_mode cm

create_analysis_view -name av_ecsm -delay_corner dc_ecsm -constraint_mode cm

set_analysis_view -setup {av_wc}  -hold {av_bc}
