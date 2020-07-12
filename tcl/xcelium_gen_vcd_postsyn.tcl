database -open -vcd wave_tb_PS_Demo -into wave_tb_PS_Demo_postsyn.vcd
run
probe -create -database wave_tb_PS_Demo -all -depth to_cell PS_Demo
run
exit
