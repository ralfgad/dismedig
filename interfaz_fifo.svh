//----------------------------------------------------------------------
//                   Mentor Graphics Inc
//----------------------------------------------------------------------
// Project         : my_project_fifo
// Unit            : interfaz_fifo_1
// File            : interfaz_fifo_1.svh
//----------------------------------------------------------------------
// Created by      : rgadea.group
// Creation Date   : 2019/06/10
//----------------------------------------------------------------------
// Title: 
//
// Summary:
//
// Description:
//
//----------------------------------------------------------------------
`timescale 1 ns/ 1 ps
interface interfaz_fifo  #(DEPTH = 32, WIDTH = 8) (input bit CLOCK, RESET_N);

  // Port List
  localparam ADDRESS=$clog2(DEPTH-1);  
  //wire CLOCK;
  //wire RESET_N;
  logic [(WIDTH - 1):0] DATA_IN;
  logic READ;
  logic WRITE;
  logic CLEAR_N;
  logic F_FULL_N;
  logic F_EMPTY_N;
  logic [(WIDTH - 1):0] DATA_OUT;
  logic [ADDRESS -1:0] USE_DW;


  // Monitor Modport
  
  modport monitor_mp (
    input CLOCK,
    input  RESET_N,
    input  DATA_IN,
    input  READ,
    input  WRITE,
    input  CLEAR_N,
    input  F_FULL_N,
    input  F_EMPTY_N,
    input  DATA_OUT,
    input  USE_DW

  );
  
  clocking tx @(posedge CLOCK);
  input #4ns DATA_OUT;
  input #4ns USE_DW;
  output #4ns DATA_IN;
  output #4ns CLEAR_N;
  input #4ns     F_FULL_N;
  input #4ns      F_EMPTY_N;
  output #4ns       READ; 
  output #4ns       WRITE;  
endclocking:tx;

modport test (clocking tx, output RESET_N);     


endinterface : interfaz_fifo