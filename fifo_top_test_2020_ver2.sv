`timescale 1 ns/ 1 ps
//`include "fifo_ports_2013_ver1.sv"
 //import FIFO_ELEMENTS::*;


program fifo_top_test (fifo_if.test test_ports, fifo_if.monitor monitor_ports);
//  `include "fifo_RCSG_2014_ver1.sv"
//  `include "fifo_sb_queue_2014_ver2.sv"
 `include "../src/dismedig/fifo_driver_new_def_2020_ver2.sv"




   fifo_driver driver;



  initial 
  begin
    driver = new(test_ports, monitor_ports);
    $display("aqui estoy");
    driver.go1();
    $display("Instance coverage after go1  is %e", driver.COV_entradas.get_coverage());
    $stop;
    
    driver.llenado_mantenido_vaciado();
    $display("Instance coverage after llenado_mantenido_vaciado is %e", driver.COV_entradas.get_coverage());
    $stop;
    
    driver.go2();
    $display("Instance coverage after go2 is %e", driver.COV_entradas.get_coverage());
    $stop;   
    
    driver.llenado_vaciado_random_2020();
    $display("Instance coverage after llenado_vaciado_random is %e", driver.COV_entradas.get_coverage());
    $stop;      

    $display("he terminado");
  end

endprogram
