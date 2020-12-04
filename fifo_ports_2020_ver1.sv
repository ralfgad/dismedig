`timescale 1 ns/ 1 ps
`ifndef FIFO_PORTS_SV
`define FIFO_PORTS_SV

interface fifo_if #(DEPTH = 32, WIDTH = 8)  (
  input  bit        clk)  ;    
  localparam ADDRESS=$clog2(DEPTH-1);  
  logic       rst      ;
  logic       lleno    ;
  logic       vacio    ;
  logic       rd_en    ; 
  logic       wr_en    ;
  logic   [ADDRESS-1:0]   use_dw ;
  logic   [WIDTH-1:0]     data_in;
  logic   [WIDTH-1:0]     data_out;

clocking px @(posedge clk);
	input #1ns data_out;
	input #1ns data_in;
	input #1ns    lleno;
  input #1ns      vacio;
  input #1ns      use_dw;
  input #1ns       rd_en; 
  input #1ns       wr_en;  
endclocking:px
clocking tx @(posedge clk);
  input #2ns data_out;
  output #2ns data_in;
  input #2ns     lleno;
  input #2ns      vacio;
  input #2ns      use_dw;
  output #2ns       rd_en; 
  output #2ns       wr_en;  
endclocking:tx



modport monitor (clocking px,

  input        rst      

);
modport test (clocking tx,

  output         rst      

);
modport duv (
  input          	clk      ,
  input        	 	rst      ,
  output         	lleno     ,
  output         	vacio    ,
  output 	     	  use_dw  ,
  input         	rd_en    , 
  input 		 	    wr_en    ,
  input  			    data_in  ,
  output    		  data_out
);



endinterface


`endif
