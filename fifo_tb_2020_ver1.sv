`timescale 1 ns/ 1 ps
module fifo_tb();

parameter DATA_WIDTH = 8;

parameter DEPTH=32;

parameter ADDR_WIDTH = $clog2(DEPTH-1);

reg clk;
wire rst;


fifo_if #(.WIDTH(DATA_WIDTH), .DEPTH(DEPTH)) fifo_interfaz (
  .clk           (clk     )
);




fifo_top_test test(fifo_interfaz,fifo_interfaz);

  
initial begin
  $dumpfile("fifo.vcd");
  $dumpvars();
//    fifo_tb.fifo.punteros=new;
  clk = 0;
end

always #10 clk  = ~clk;


//always @(negedge clk)
//fifo_tb.fifo.hola.sample();

FIFO_top_duv #(.WIDTH(DATA_WIDTH), .DEPTH(DEPTH)) duv(
.bus(fifo_interfaz)
);

endmodule
