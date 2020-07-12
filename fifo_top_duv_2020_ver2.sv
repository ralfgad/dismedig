module FIFO_top_duv (fifo_if.duv bus) ; 

parameter WIDTH  = 8 ;
parameter DEPTH  = 32 ;

supply0       GND;
supply1       VDD, VDDOR, vdd_A, vdd_R;
PS_Demo fifo_duv(
.GND(GND), 
.VDD(VDD), 
.VDDOR(VDDOR), 
.vdd_A(vdd_A), 
.vdd_R(vdd_R),
.scan_enable(1'b0), 
.scan_in(1'b0), 
.scan_out(), 
.test_mode(1'b0),
.clk (bus.clk),     // Clock input
.rst_n(bus.rst),     // Active LOW ASINCRONOUS reset
.data_in      (bus.data_in), // Data input
.read         (bus.rd_en),   // Read enable
.write       (bus.wr_en),   // Write Enable
.data_out     (bus.data_out),// Data Output
.use_dw       (bus.use_dw), //puntero de llenado
.empty_n    (bus.vacio),   // FIFO empty
.full_n    (bus.lleno)     // FIFO full
);

endmodule

