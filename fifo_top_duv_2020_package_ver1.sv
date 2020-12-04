module FIFO_top_duv (fifo_if.duv bus) ; 

parameter WIDTH  = 8 ;
parameter DEPTH  = 32 ;

fifo_un_fichero #(.SIZE(WIDTH),.LENGTH(DEPTH)) fifo_duv(
.CLOCK    (bus.clk),     // Clock input
.RESET_N  (bus.rst),     // Active LOW ASINCRONOUS reset
.CLEAR_N  (1'b1),    // Active LOW SINCRONOUS reset
.DATA_IN      (bus.data_in), // Data input
.READ         (bus.rd_en),   // Read enable
.WRITE        (bus.wr_en),   // Write Enable
.DATA_OUT     (bus.data_out),// Data Output
.USE_DW       (bus.use_dw), //puntero de llenado
.F_EMPTY_N    (bus.vacio),   // FIFO empty
.F_FULL_N     (bus.lleno)     // FIFO full
);

endmodule

