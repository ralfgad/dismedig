setAddStripeMode -remove_floating_stripe_over_block true \
    -allow_nonpreferred_dir { blockring corering padring stripe } \
    -allow_jog { padcore_ring block_ring } -stacked_via_bottom_layer MET1 \
    -stacked_via_top_layer METTP -ignore_block_check true \
    -ignore_nondefault_domains true
        
## gnd and vdd_A Ring around the Block

addRing -nets { GND vdd_A } -width 25 -spacing 1 -offset 6 -around default_power_domain \
    -follow io -layer {top MET5 bottom MET5 left MET4 right MET4}  \
    -jog_distance 0.6 -threshold 0.6 -snap_wire_center_to_grid Half_Grid 
    
## gnd and vdd stripe around the Memory    

addStripe -nets {GND vdd_A} -layer METTP -width 1.6 -number_of_sets 1 \
    -start 617 -stop 627 -snap_wire_center_to_grid Grid \
    -block_ring_top_layer_limit METTP -spacing 1 \
    -max_same_layer_jog_length 0.88 -padcore_ring_bottom_layer_limit MET1 \
    -padcore_ring_top_layer_limit METTP -merge_stripes_value 0.315 \
    -block_ring_bottom_layer_limit MET1 

addStripe -nets {vdd_A} -layer MET5 -width 3 -number_of_sets 1 \
    -start 1061 -stop 1098 -snap_wire_center_to_grid Grid \
    -block_ring_top_layer_limit METTP -spacing 0.6 \
    -max_same_layer_jog_length 0.88 -direction horizontal \
    -padcore_ring_bottom_layer_limit MET2 -padcore_ring_top_layer_limit METTP \
    -merge_stripes_value 0.6 -block_ring_bottom_layer_limit MET2 \
    -area {200 1000 622.68 1200} 

addStripe -nets {GND} -layer MET3 -width 13 -number_of_sets 1 \
    -start 1085 -stop 1098 -snap_wire_center_to_grid Grid \
    -block_ring_top_layer_limit METTP -spacing 0.6 \
    -max_same_layer_jog_length 0.88 -direction horizontal \
    -padcore_ring_bottom_layer_limit MET2 -padcore_ring_top_layer_limit METTP \
    -merge_stripes_value 0.6 -block_ring_bottom_layer_limit MET2 \
    -area {175 1000 619.32 1200} 

addStripe -nets {vdd_R} -layer MET1 -width 16 -number_of_sets 1 \
    -start 162 -stop 200 -snap_wire_center_to_grid Grid \
    -block_ring_top_layer_limit METTP -spacing 0.6 \
    -max_same_layer_jog_length 0.88 -direction vertical \
    -padcore_ring_bottom_layer_limit MET2 -padcore_ring_top_layer_limit METTP \
    -merge_stripes_value 0.6 -block_ring_bottom_layer_limit MET2 \
    -area {160.0 1019.1 250 1092.9} 

addStripe -nets {vdd_R} -layer MET3 -width 13 -number_of_sets 1 \
    -start 1070.5 -stop 1084 -snap_wire_center_to_grid Grid \
    -block_ring_top_layer_limit METTP -spacing 0.6 \
    -max_same_layer_jog_length 0.88 -direction horizontal \
    -padcore_ring_bottom_layer_limit MET2 -padcore_ring_top_layer_limit METTP \
    -merge_stripes_value 0.6 -block_ring_bottom_layer_limit MET2 \
    -area {162.52 1000 615.45 1200} 
     
## Add additonal vertical power and ground stripes

addStripe -nets {GND vdd_A} -layer METTP -width 1.8 -set_to_set_distance 58.24 \
    -start 670 -stop 1210 -spacing 3.36 \
    -snap_wire_center_to_grid Half_Grid -merge_stripes_value 0.3 \
    -direction vertical -block_ring_top_layer_limit MET3 \
    -max_same_layer_jog_length 0.88 -padcore_ring_bottom_layer_limit MET1 \
    -block_ring_bottom_layer_limit MET1 -padcore_ring_top_layer_limit MET3 

addStripe -nets {GND} -layer METTP -width 1.8 -set_to_set_distance 58.24 \
    -start 225 -stop 600 -spacing 2.8 -area { 200 170 750 1097} \
    -snap_wire_center_to_grid Half_Grid -merge_stripes_value 0.315 \
    -direction vertical -block_ring_top_layer_limit MET3 \
    -max_same_layer_jog_length 0.88 -padcore_ring_bottom_layer_limit MET1 \
    -block_ring_bottom_layer_limit MET1 -padcore_ring_top_layer_limit MET3 

addStripe -nets {vdd_A} -layer METTP -width 1.8 -set_to_set_distance 58.24 \
    -start 228.36 -stop 600 -spacing 2.8 -area { 200 195 750 1064.1} \
    -snap_wire_center_to_grid Half_Grid -merge_stripes_value 0.315 \
    -direction vertical -block_ring_top_layer_limit MET3 \
    -max_same_layer_jog_length 0.88 -padcore_ring_bottom_layer_limit MET1 \
    -block_ring_bottom_layer_limit MET1 -padcore_ring_top_layer_limit MET3 

