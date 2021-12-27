//
// Verilog Module tarea1_2020_lib.fifo_un_fichero
//
// Created:
//          by - rgadea.UNKNOWN (HYPERION7)
//          at - 11:46:36 14/05/2020
//
// using Mentor Graphics HDL Designer(TM) 2019.4 (Build 4)
//

`resetall
`timescale 1ns/10ps
module fifo_un_fichero 
  
#(parameter LENGTH=32,
  parameter SIZE=8)  
(
input logic [SIZE-1:0] DATA_IN,
input logic READ,
input logic WRITE,
input CLOCK,
input CLEAR_N,
input RESET_N,
output [$clog2(LENGTH-1)-1:0] USE_DW,
output logic F_FULL_N,
output logic F_EMPTY_N,

output logic [SIZE-1:0] DATA_OUT


);
localparam tamano=$clog2(LENGTH-1);
logic [0:LENGTH-1][SIZE-1:0] aux;
logic [tamano-1:0] count ;
assign USE_DW=count;
enum logic [1:0] {vacio,otros,lleno} estado;


always_ff @(posedge CLOCK or negedge RESET_N)
if (!RESET_N)
      begin
        aux<={LENGTH{'0}};
        count<=0;
        estado<=vacio;
        DATA_OUT<='0;
      end
else
  if (CLEAR_N==1'b0)
  begin
        aux<={LENGTH{'0}};
        count<=0;
        estado<=vacio;
        DATA_OUT<='0;
  end
  else
    case (estado)
      vacio:  begin
                case ({READ,WRITE})
                  2'b01:
           
                    begin
                      estado<=otros;
                      count<=count+1;
                      aux<={DATA_IN,aux[0:LENGTH-2]};
                    end              
                  2'b11:
                    begin
                      aux<={DATA_IN,aux[0:LENGTH-2]};
                     DATA_OUT<=DATA_IN;
                    end  
                endcase

              end
      otros:  begin
                case ({READ,WRITE})
                  2'b01:
                    begin
                      if (count==LENGTH-1)
                          estado<=lleno;
                      count<=count+1;
                      aux<={DATA_IN,aux[0:LENGTH-2]};
                    end
                  2'b10:
                    begin
                      if (count==1)
                          estado<=vacio;
                      count<=count-1;
                      DATA_OUT<=aux[count-1]; 
                    end                
                  2'b11:
                    begin
                      aux<={DATA_IN,aux[0:LENGTH-2]};
                      DATA_OUT<=aux[count-1]; 
                    end 
                endcase

              end                 
      lleno:  begin
                case ({READ,WRITE})
                  2'b10:
                    begin
                      estado<=otros;
                      count<=count-1;
                      DATA_OUT<=aux[count-5'b1]; 
                    end                
                  2'b11:
                    begin
                      aux<={DATA_IN,aux[0:LENGTH-2]};
                      DATA_OUT<=aux[count-5'b1]; 
                    end                   
                endcase
 
              end
      endcase                                              


assign F_FULL_N=(estado==lleno)?1'b0:1'b1;
assign F_EMPTY_N=(estado==vacio)?1'b0:1'b1;


// ### Please start your Verilog code here ### 


      
      
      


property  llenado ;
(@(posedge CLOCK) not (WRITE==1'b1 && F_FULL_N==1'b0 &&READ==1'b0));
endproperty
sobrellenado:assert property (llenado)  else $error("estas escribiendo sobre una fifo llena");

property  vaciado ;
(@(posedge CLOCK) not (READ==1'b1 && F_EMPTY_N==1'b0&& WRITE==1'b0)) ;
endproperty
sobrevaciado:assert property  (vaciado) else $error("estas leyendo de una fifo vacia");



sequence corner_vacio;
 logic [7:0] aux;
  (1, aux=DATA_IN) ##1 (!F_EMPTY_N && DATA_OUT==aux);
endsequence
sequence corner_vacio2;
 logic [7:0] aux;
  (1, aux=DATA_IN) ##1 (!READ) [*0:$] ##1 READ ##1 ( DATA_OUT==aux);
endsequence

ejemplo_evaluar_fifo_vacia_escritura_lectura: assert property (@(posedge CLOCK) 
                                             disable iff(RESET_N!==1'b1) (WRITE&&READ&&F_EMPTY_N==1'b0)|->corner_vacio);

 ejemplo_evaluar_fifo_vacia_escritura: assert property (@(posedge CLOCK) 
                                             disable iff(RESET_N!==1'b1) (WRITE&&!READ&&F_FULL_N==1'b0)|->corner_vacio2); 
  
  
  
sequence corner_lleno;
    logic [7:0] dato;
              (1, dato=DATA_IN) ##1 READ[->32] ##1  (DATA_OUT==dato);
endsequence

  
  
  
  ejemplo_evaluar_fifo_llena_escritura_lectura: assert property (@(posedge CLOCK) 
                                             disable iff(RESET_N!==1'b1) (WRITE&&READ&&F_FULL_N==1'b0)|->corner_lleno);
  
  ejemplo_evaluar_fifo_llena_escritura_lectura2: assert property (@(posedge CLOCK) 
                                             disable iff(RESET_N!==1'b1) (WRITE&&READ&&F_FULL_N==1'b0)|=>DATA_OUT==$past(DATA_IN,33,WRITE)) else $info("DATA_OUT es %h y deberia de ser %h", DATA_OUT,$past(DATA_IN,33,WRITE)) ;
 ejemplo_evaluar_fifo_llena_lectura: assert property (@(posedge CLOCK) 
                                             disable iff(RESET_N!==1'b1) (!WRITE&&READ&&F_FULL_N==1'b0)|=>DATA_OUT==$past(DATA_IN,32,WRITE)) else $info("DATA_OUT es %h y deberia de ser %h", DATA_OUT,$past(DATA_IN,32,WRITE)) ;

genvar i;
   generate 
     for (i=31;i>0;i=i-1)
       begin: width
          sequence comprobacion_fifo;
              logic [7:0] dato;
                    (1, dato=DATA_IN) ##1 READ[->i+1] ##1  (DATA_OUT==dato);
          endsequence
         ejemplo_evaluar_fifo: assert property (@(posedge CLOCK) disable  iff(RESET_N!==1'b1) (WRITE&&!READ&&(USE_DW==i))|->comprobacion_fifo);  
          sequence comprobacion_fifo2;
              logic [7:0] dato;
                    (1, dato=DATA_IN) ##1 READ[->i] ##1  (DATA_OUT==dato);
          endsequence
           ejemplo_evaluar_fifo2: assert property (@(posedge CLOCK) disable iff(RESET_N!==1'b1) (WRITE&&READ&&(USE_DW==i))|->comprobacion_fifo2);
           ejemplo_evaluar_fifo3: assert property (@(posedge CLOCK) disable iff(RESET_N!==1'b1) (WRITE&&READ&&(USE_DW==i))|=>DATA_OUT==$past(DATA_IN,i+1,WRITE));
           ejemplo_evaluar_fifo4: assert property (@(posedge CLOCK) disable iff(RESET_N!==1'b1) (!WRITE&&READ&&(USE_DW==i))|=>DATA_OUT==$past(DATA_IN,i,WRITE));
      end
   endgenerate
        
endmodule