database -open -vcd wave_tb_PS_Demo -into wave_tb_PS_Demo_postlayout.vcd
run
probe -create -database wave_tb_PS_Demo -all -depth to_cell PS_Demo
run
run
run
exit
