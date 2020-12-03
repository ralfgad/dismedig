


class fifo_RCSG;
  rand bit[7:0] data;
  rand bit ena_w;
  rand bit ena_r;
  rand integer wr_cmds;
  rand integer rd_cmds; 
  constraint data_acotado {data>8'd43 && data<8'd57;}
  constraint llenando {{ena_w,ena_r} dist { 2'b00:=10, 2'b11:=10 , 2'b01:=20 , 2'b10:=40};}
  constraint vaciando {{ena_w,ena_r} dist { 2'b00:=10, 2'b11:=10 , 2'b10:=20 , 2'b01:=40};}
  constraint no_simultaneidad {{ena_w,ena_r} !=2'b11;}
  constraint no_solo_escribo {{ena_w,ena_r} !=2'b10;}
  constraint no_solo_leo {{ena_w,ena_r} !=2'b01;}  
  
/*
  function void pre_randomize();
    $display("Before randomize dato=%h", data);
  endfunction
  function void post_randomize();
    $display("After randomize dato=%h",data);
  endfunction
*/
endclass



class fifo_sb;
  // mailbox fifo = new();
   bit [7:0]  fifo_queue [$:32]; //si ponemos  tamanyo 32 los procedimientos del 2013 fallan
   integer size;
   virtual fifo_if.monitor mports2;

   function new(virtual fifo_if.monitor mports3);
   begin
     size = 0;
     mports2=mports3;
   end  
   endfunction

   task addItem_2013(bit [7:0] data);//este funciona con tamanyo 33 en la cola
   begin
     if (size == 32) begin
       $write("%dns : ERROR : Over flow detected, current occupancy %d\n",
         $time, size);
          fifo_queue.push_back(data);
         size ++;
     end else begin
       fifo_queue.push_back(data);
       size ++;
     end
   end
   endtask
   
   task addItem(bit [7:0] data);
   begin
    fork
      begin
          wait (fifo_queue.size()<=32);
          fifo_queue.push_back(data);
          size=fifo_queue.size();
          //fifo_queue<= {fifo_queue,data};
          //size ++;

      end
              @ (mports2.px)  #0        $write("%dns : ERROR : Over flow detected, current occupancy %d\n", $time, fifo_queue.size());
    
    join_any
    disable fork;
   end
   endtask
   

   task  compareItem (bit [7:0] data);
   begin
       bit  [7:0] cdata  = 0;
     fork
      begin
        wait (fifo_queue.size()>0)
        cdata=fifo_queue.pop_front;
        size=fifo_queue.size();
        //cdata =fifo_queue[0];        
        //fifo_queue<= fifo_queue[1:$];
        //size --;        
        a_check0: assert (data == cdata) else
          $error("%dns : ERROR : Data mismatch, Expected %x Got %x\n",$time, cdata, data );
      end
     #0      $write("%dns : ERROR : Under flow detected,current occupancy %d\n", $time, fifo_queue.size()); //esta rrama del no debería saltar nunca
    join_any
    disable fork;     
   end
   endtask
   
   task compareItem_2013 (bit [7:0] data);//este funciona con tamanyo 33 en la cola
   begin
     bit [7:0] cdata  = 0;
     if (size == 0) begin
       $write("%dns : ERROR : Under flow detected\n", $time);
       cdata=fifo_queue.pop_front;
       a_check0: assert (data == cdata) else
         $error("%dns : ERROR : Data mismatch, Expected %x Got %x\n", 
         $time, cdata, data );
       
     end else begin
       cdata=fifo_queue.pop_front;
       a_check1: assert (data == cdata) else
         $error("%dns : ERROR : Data mismatch, Expected %x Got %x\n", 
           $time, cdata, data );
       
       size --;
     end
   end
   endtask 
  task vaciar ();
   begin
    fifo_queue={};
   end
 endtask
endclass
class fifo_driver;

  fifo_sb sb;
  fifo_RCSG rdatos;
  virtual fifo_if.test ports;
  virtual fifo_if.monitor mports;

  bit rdDone;
  bit wrDone;

  integer wr_cmds;
  integer rd_cmds;
  covergroup COV_entradas;
      coverpoint mports.px.data_in
            {
        bins bin1      = {[44:56]};
        bins others[]  = default;
      }
      ae:coverpoint {mports.px.lleno,mports.px.wr_en,mports.px.rd_en}
      {
            bins f1w1r0={3'b110};
            bins f1w1r1={3'b111}; 
            bins f0w1r1={3'b011};
      
      }
  endgroup;
   covergroup COV_salidas;

      coverpoint  mports.px.data_out
            {
        bins bin1      = {[44:56]};
        bins others[]  = default;
      }
      as:coverpoint {mports.px.vacio,mports.px.wr_en,mports.px.rd_en}
      {
            bins e1w0r1={3'b101};
            bins e1w1r1={3'b111}; 
            bins e0w1r1={3'b011}; 
          }
  endgroup; 
// covergroup prueba_interno @(negedge mports.px);
//      interno_r:coverpoint fifo_tb.duv.fifo_duv.COUNTRD;
//      interno_w:coverpoint  fifo_tb.duv.fifo_duv.COUNTWR;
//      interno_dif:coverpoint  fifo_tb.duv.fifo_duv.COUNTDEF {
//      bins lleno = {2**0} ;
//      bins casi_lleno={2**1};
//      bins vacio = {'h100000000} ;
//      bins casi_vacio={2**31};  
//    }
//      cross interno_r,interno_w;  
//  endgroup;
//  covergroup prueba_puntero @(negedge mports.px);
//      rw:coverpoint {mports.px.wr_en,mports.px.rd_en}
//	{  	bins simultaneo_rw = {2'b11} ;
//                bins otros=default;}
//      interno_dif:coverpoint  fifo_tb.test.driver.sb.size 
//	{	bins lleno = {32} ;
//      		bins casi_lleno={31};
//      		bins vacio = {0} ;
//      		bins casi_vacio={1};  
//      		bins otros[]={[2:30]};}
//      simultaneidad: cross rw,interno_dif
//  	{  	bins         cross1 = binsof(rw.simultaneo_rw)&&binsof(interno_dif.lleno);  
//		    bins         cross2 = binsof(rw.simultaneo_rw)&&binsof(interno_dif.vacio);
//		         
//    	}
//  endgroup; 
 
   covergroup COV_combinado @(mports.px);
      CP1: coverpoint mports.px.use_dw
      {
        bins situaciones_normales[]      = {[1:31]};
        bins situaciones_extremas  = {0};
      }  
      CP2: coverpoint {mports.px.wr_en,mports.px.rd_en}
      {
        bins leo_escribo      = {2'b11};
        bins solo_leo      = {2'b01};
        bins solo_escribo      = {2'b10};
        bins no_hago_nada  = default;
      }      
       CP3: coverpoint {mports.px.lleno , mports.px.vacio}
      {
        bins vacio      = {2'b10};
        bins lleno      = {2'b01};
        illegal_bins lleno_vacio =  {2'b00}    ;    
        bins others  = default;
      } 
      CROSS1: cross CP2,CP3
      {
        bins   corner_vacio = binsof(CP3.vacio) && binsof(CP2.leo_escribo);     
        bins   corner_lleno = binsof(CP3.lleno) && binsof(CP2.leo_escribo);     // 12 bins
        ignore_bins leer_vacio = binsof(CP3.vacio) && binsof(CP2.solo_leo); 
        ignore_bins leer_lleno = binsof(CP3.lleno) && binsof(CP2.solo_escribo);        
      }
      CROSS2: cross CP1,CP2
      {
        bins   corners = binsof(CP1.situaciones_extremas) && binsof(CP2.leo_escribo);     
        bins   otros_leo = binsof(CP1.situaciones_normales) && binsof(CP2.solo_leo);     
        bins   otros_escribo = binsof(CP1.situaciones_normales) && binsof(CP2.solo_escribo);     
      }      
  endgroup;  
  
  
    function new (virtual fifo_if.test ports, virtual fifo_if.monitor mports);
  begin
    this.ports = ports;
    this.mports = mports;
    sb = new(mports);
    rdatos=new;
      
    COV_entradas=new;
    COV_salidas=new;
    //prueba_interno=new; //no es adecuado por muestrear punteros internos de la implementación. Si cambia el RTL pierde toda su validez
    //prueba_puntero=new; //no es adecuado por muestrear elementos internos del scoreborad. Si cambia el modelo de referencia pierde toda su validez  
    COV_combinado=new;
    wr_cmds = 4;
    rd_cmds  = 4;
    rdDone = 0;
    wrDone = 0;
     ports.tx.wr_en  <= 0;
     ports.tx.rd_en  <= 0;
     ports.tx.data_in <= 0;
  end
  endfunction
  
  task monitorPush();
  begin
    bit [7:0] data = 0;
    while (1) begin
      @ (mports.px);
      if ( mports.px.wr_en== 1  && mports.px.lleno!= 0 ||   mports.px.wr_en== 1  && mports.px.lleno== 0 && mports.px.rd_en==1) begin
        data = mports.px.data_in;
        COV_entradas.sample(); //anyadido para cobertura
        sb.addItem(data);
        $write("%dns : Write posting to scoreboard data = %x\n",$time, data);
      end
    end
  end
  endtask

 
  task monitorPop();
  begin
    bit [7:0] data = 0;
	  @ (mports.px); 
    while (1) begin
      //@ (mports.px); //eliminado porque es lectura síncrona
      if (  mports.px.rd_en== 1 && mports.px.vacio!=0 ||  mports.px.rd_en== 1 && mports.px.vacio==0 && mports.px.wr_en==1) begin
        COV_salidas.sample(); 
        @ (mports.px) ;
        data = mports.px.data_out;//añadido porque es lectura síncrona
//anyadido para cobertura
        $write("%dns : Read posting to scoreboard data = %x\n",$time, data);
        sb.compareItem(data);
		  
      end
		else
			  @ (mports.px); 
    end
  end
  endtask
  task go1();
  begin
    // Assert reset first
    reset();
    // Start the monitors
    repeat (5) @ (ports.tx);
    $write("%dns : Starting Pop and Push monitors\n",$time);
    fork
      monitorPush();
      monitorPop();
    join_none
    $write("%dns : Starting Pop and Push generators\n",$time);
    fork
      genPush();
      @ (ports.tx)genPop(); 
    join_none

    while (!rdDone && !wrDone) begin
      @ (ports.tx);
    end
     repeat (10) @ (ports.tx);
    $write("%dns : Terminamos test1\n",$time);
  end
  endtask
  
  task go2();
  begin
    // Assert reset first
    reset();
    // Start the monitors
    repeat (5) @ (ports.tx);
     $write("%dns : Starting Pop and Push generators\n",$time);
     begin 
	   genPush();	   
	   genPush();
	   genPush();
	   genPop();
     end

    while (!rdDone) begin
      @ (ports.tx);
    end
    repeat (10) @ (ports.tx);
    $write("%dns : Terminando test2\n",$time);
  end
  endtask

task llenado();
  begin
    // Assert reset first
    reset();
    // Start the monitors
    repeat (5) @ (ports.tx);
     $write("%dns : Starting Pop and Push generators\n",$time);
     fork 
	   repeat(8) genPush();	   
     join_none

    while (ports.tx.lleno) begin
      @ (ports.tx);
    end
    repeat (10) @ (ports.tx);
    $write("%dns : Terminando test de llenado\n",$time);
  end
  endtask
task llenado_mantenido_vaciado();
  begin
    // Assert reset first
    reset();
    // Start the monitors
    repeat (5) @ (ports.tx);
     $write("%dns : Starting Pop and Push generators\n",$time);
     fork 
	   repeat(8) genPush();	   
     join_none

    while (ports.tx.lleno) begin
      @ (ports.tx);
    end
    repeat(11)   @ (ports.tx);
   
	 repeat(8) genPop();	   

    repeat(10)   @ (ports.tx);
     fork 
	   repeat(8) genPush();	   
     join_none
    while (sb.size<32) begin
      @ (ports.tx);
    end
    fork    
	 repeat(8) genPop();	   
    join_none
    while (sb.size>0) begin
      @ (ports.tx);
    end    
    repeat (10) @ (ports.tx);
    $write("%dns : Terminando test de llenado_mantenido_vaciado\n",$time);
  end
  endtask

task llenado_vaciado_random ();
begin
  wr_cmds=1;
  rd_cmds=1;  
    while ( COV_entradas.get_coverage()<90 || COV_salidas.get_coverage()<90 || COV_combinado.get_coverage()<100 || $get_coverage <100 )    
  begin
       while ( sb.size<32) //empiezo a llenar
      fork begin
          fork:pepito
           randcase
            5: genPop_rand();
            10: genPush_rand();
            endcase
           randcase
            6: genPop_rand();
            10: genPush_rand();
            endcase
           join_any: pepito
  
            $display("la fifo tiene  %d palabras", sb.size);
            $display("Instance coverage is %e", COV_entradas.get_coverage());
                     disable fork;
       end join
  
    fork //corner case
  
      genPop_atom();
      genPush_atom();
  
    join_any
       $display("la fifo tiene  %d palabras", sb.size);
      $display("Instance coverage is %e", COV_entradas.get_coverage());
     
     // driver.go2();
     // driver.llenado();
     while (sb.size>0) //empiezo a vaciar
      fork begin
      fork
         randcase
          10: genPop_rand();
          5: genPush_rand();
          endcase
         randcase
          10: genPop_rand();
          6: genPush_rand();
          endcase
      join_any
          $display("la fifo tiene  %d palabras", driver.sb.size);
      $display("Instance coverage is %e", driver.COV_entradas.get_coverage());
      disable fork;
    end join
      fork //corner case
      genPop_atom();
      genPush_atom();
       join_any
   end
 end
 endtask 
 
 task llenado_vaciado_random_2020 ();

  bit flag;
  bit corner;
  int size;
  int estimulos;
  wr_cmds=1;
  rd_cmds=1; 
  flag=1'b0;
  corner=1'b1;
  estimulos=0; 
  reset();
  while ( COV_entradas.get_coverage()<90 || COV_salidas.get_coverage()<90 || COV_combinado.get_coverage()<100 || $get_coverage <100  || estimulos<100000)    

  begin
  
      if (  flag==0)
            begin
             rdatos.vaciando.constraint_mode(0);
             rdatos.llenando.constraint_mode(1);
             rdatos.no_simultaneidad.constraint_mode(0);
             rdatos.no_solo_leo.constraint_mode(corner); 
             rdatos.no_solo_escribo.constraint_mode(0);  
              if ( !rdatos.randomize()    )
                $write("randomization failed in s!");
              $write("holas %d \n",  size);
              if (size==1 && rdatos.ena_r==1'b1 &&rdatos.ena_w==1'b0)
                corner=1'b1;
              else
                corner=1'b0; 
              if (size==0)
                corner=1'b1; 
              if (size==31 &&rdatos.ena_r==1'b0 &&rdatos.ena_w==1'b1 ) begin
                flag=1'b1;
                corner=1'b1;
              end
             end
          else
            begin
             rdatos.vaciando.constraint_mode(1);
             rdatos.llenando.constraint_mode(0);
             rdatos.no_simultaneidad.constraint_mode(0);
             rdatos.no_solo_escribo.constraint_mode(corner); 
             rdatos.no_solo_leo.constraint_mode(0);  
              //corner=1'b0;
              if ( !rdatos.randomize() )
                $write("randomization failed in b!")  ;
              $write("holab %d \n",  size);  
              if (size==31 && rdatos.ena_r==1'b0 && rdatos.ena_w==1'b1)
                corner=1'b1;
              else
                corner=1'b0;  
              if (size==32)
                corner=1'b1;
              if (size==1 && rdatos.ena_r==1'b1 && rdatos.ena_w==1'b0 ) begin
                flag=1'b0;
                corner=1'b1;
              end
            end
       if (rdatos.ena_w==1'b1 && rdatos.ena_r==1'b0)       
              size++;      
       if (rdatos.ena_w==1'b0 && rdatos.ena_r==1'b1)
              size--;
       ports.tx.data_in<=rdatos.data;  
       ports.tx.rd_en<=rdatos.ena_r; 
       ports.tx.wr_en<=rdatos.ena_w; 
       $display("Total coverage %e",$get_coverage());
       @(ports.tx);
       estimulos ++;
    end
 endtask
  
 
  task reset();
  begin
    repeat (5) @ (ports.tx);
    $write("%dns : Asserting reset\n",$time);
    ports.rst= 1'b0;
    // Init all variables
    sb.size=0; //inicializamos el puntero del mailbox que indica el llenado
    rdDone = 0;
    wrDone = 0;
    sb.vaciar();
    repeat (5) @ (ports.tx);
    ports.rst= 1'b1;
    $write("%dns : Done asserting reset\n",$time);
  end
  endtask

  task genPush();
  begin
    bit [7:0] data = 0;
    integer i = 0;
    for ( i  = 0; i < wr_cmds; i++)  begin
       data = $random();
             @ (ports.tx);
        while (ports.tx.lleno== 1'b0 & mports.px.rd_en==1'b0)
       begin

        ports.tx.wr_en <= 1'b0;
        ports.tx.data_in<= 8'b0;
              @ (ports.tx);
       end

       ports.tx.wr_en  <= 1'b1;
       ports.tx.data_in<= data;
    end
    @ (ports.tx);
    ports.tx.wr_en  <= 1'b0;
    ports.tx.data_in<= 8'b0;
    repeat (10) @ (ports.tx);
    wrDone = 1;
  end
  endtask
  task genPush_atom();
  begin
    bit [7:0] data = 0;
    integer i = 0;
    for ( i  = 0; i < wr_cmds; i++)  begin
       data = $random();
             @ (ports.tx);

       ports.tx.wr_en  <= 1'b1;
       ports.tx.data_in<= data;
    end
    @ (ports.tx);
    ports.tx.wr_en  <= 1'b0;
    ports.tx.data_in<= 8'b0;
    repeat (10) @ (ports.tx);
    wrDone = 1;
  end
  endtask 
  
    task genPush_sin();
  begin
    bit [7:0] data = 0;
    integer i = 0;
    
       data = $random();
      @ (ports.tx);
       ports.tx.wr_en  <= 1'b1;
	   $stop;
       ports.tx.data_in<= data;

    repeat (4) @ (ports.tx);
    repeat (4) @ (ports.tx);

    ports.tx.wr_en  <= 1'b0;
    ports.tx.data_in<= 8'b0;
    repeat (10) @ (ports.tx);
    wrDone = 1;
	$display("lo hice");
  end
  
  endtask
    task genPop();
  begin
    integer i = 0;
    for ( i  = 0; i < rd_cmds; i++)  begin
       @ (ports.tx);
       while (ports.tx.vacio== 1'b0 & mports.px.wr_en==1'b0) begin

         ports.tx.rd_en  <= 1'b0;
         @ (ports.tx); 
       end

       ports.tx.rd_en  <= 1'b1;
    end
    @ (ports.tx);

    ports.tx.rd_en   <= 1'b0;
    repeat (10) @ (ports.tx);
    rdDone = 1;
  end
  endtask
  task genPop_atom();
  begin
    integer i = 0;
    for ( i  = 0; i < rd_cmds; i++)  begin
       @ (ports.tx);
       ports.tx.rd_en  <= 1'b1;
    end
    @ (ports.tx);

    ports.tx.rd_en   <= 1'b0;
    repeat (10) @ (ports.tx);
    rdDone = 1;
  end
  endtask
  
  task genPop_rand();
  begin:pop
    integer i = 0;
    for ( i  = 0; i < rd_cmds; i++)  begin
       @ (ports.tx);
       while (ports.tx.vacio== 1'b0 & mports.px.wr_en==1'b0) begin

         ports.tx.rd_en  <= 1'b0;
         @ (ports.tx);
         disable pop; 
       end

       ports.tx.rd_en  <= 1'b1;
    end
    @ (ports.tx);

    ports.tx.rd_en   <= 1'b0;
    repeat (10) @ (ports.tx);
    rdDone = 1;
  end
  endtask
    task genPush_rand();
  begin:pus
  //  bit [7:0] data = 0;
    integer i = 0;
    for ( i  = 0; i < wr_cmds; i++)  begin
   //    data = $random();
       rdatos.randomize() ; //with {wr_cmds=4 && rd_cmds=4;};  
      @ (ports.tx);
       while (ports.tx.lleno== 1'b0 & mports.px.rd_en==1'b0) begin

        ports.tx.wr_en  <= 1'b0;
        ports.tx.data_in<= 8'b0;
        @ (ports.tx); 
        disable pus;
       end

       ports.tx.wr_en  <= 1'b1;
       ports.tx.data_in<= rdatos.data;
    end
    @ (ports.tx);

    ports.tx.wr_en  <= 1'b0;
    ports.tx.data_in<= 8'b0;
    repeat (10) @ (ports.tx);
    wrDone = 1;
  end
  endtask
  
  
  
endclass

