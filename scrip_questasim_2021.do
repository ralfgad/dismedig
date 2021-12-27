 vlog -work work -vopt -sv +define+VERIFICACION  -cover sbcet3 fifo_un_fichero_questasim.sv
 vlog -reportprogress 300 -work work fifo_ports_2020_ver1.sv
 vlog -work work -vopt -sv +define+VERIFICACION -cover sbcet3 fifo_top_duv_2020_ver2_questasim.sv
 vlog -reportprogress 300 -work work fifo_driver_new_def_2020_package_ver3.sv
 vlog -reportprogress 300 -work work fifo_top_test_2020_package_ver3.sv
 vlog -reportprogress 300 -work work fifo_tb_2020_ver1.sv
 vsim -coverage -vopt -msgmode both  -assertcover work.fifo_tb -voptargs=+acc

