


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

