// Power simulation demo design

module PS_Demo (rst_n, clk, write,read,data_in,data_out,use_dw,full_n,empty_n,scan_in,scan_out,scan_enable,test_mode,
                 GND, VDD, VDDOR, vdd_A, vdd_R );

    input           rst_n, clk, write,read;


    input    [7:0]  data_in;
    output   [7:0]  data_out;
    output   [4:0]  use_dw;
    output full_n,empty_n;

//para el DFT
    input       scan_in,scan_enable,test_mode;
    output      scan_out; 
//
    
    inout           GND, VDD, VDDOR, vdd_A, vdd_R;

    wire            i_rst_n, i_control, i_clk, i_write, i_read;
        

    wire i_scan_in,o_scan_out,i_scan_enable,i_test_mode;

    wire    [7:0]  i_data_in;
    wire    [7:0]  o_data_out;
    wire    [4:0]  o_use_dw;    
    wire            o_full_n,o_empty_n;   
    wire            p_NULL, d_NULL, p_ONE, d_ONE;



    fifo_un_fichero  #(.LENGTH(32),.SIZE(8))  core

    (
    .DATA_IN(i_data_in),
    .READ(i_read),
    .WRITE(i_write),
    .CLOCK(i_clk),
    .CLEAR_N(d_ONE),
    .RESET_N(i_rst_n),

    .USE_DW(o_use_dw),
    .F_FULL_N(o_full_n),
    .F_EMPTY_N(o_empty_n),

    .DATA_OUT(o_data_out),
    .scan_enable(i_scan_enable),
    .scan_in(i_scan_in),
    .scan_out(o_scan_out),
    .test_mode(i_test_mode)
    );


        // add schmitt trigger on asynchronous nets (clock and reset)

    LOGIC0JIHD   L0  ( .Q(p_NULL) );
    LOGIC1JIHD   L1  ( .Q(p_ONE) );
    BUJIHDX12    L0B ( .A(p_NULL), .Q(d_NULL) );
    BUJIHDX12    L1B ( .A(p_ONE), .Q(d_ONE) );


    VDDCPADF     P03 ( .GNDO(GND), .GNDR(GND), .VDD(VDD), .VDDC(vdd_A), 
                       .VDDO(VDDOR), .VDDR(VDDOR) );
    GNDORPADF    P04 ( .GNDOR(GND), .VDD(VDD), .VDDO(VDDOR), .VDDR(VDDOR) );
    ISF          P05 ( .GNDO(GND), .GNDR(GND), .PAD(scan_in), .PI(d_NULL), 
                       .PO(), .VDD(VDD), .VDDO(VDDOR), .VDDR(VDDOR), .Y(i_scan_in) );

    VDDORPADF    P09 ( .GNDO(GND), .GNDR(GND), .VDD(VDD), .VDDOR(VDDOR) );
    GNDORPADF    P10 ( .GNDOR(GND), .VDD(VDD), .VDDO(VDDOR), .VDDR(VDDOR) );




    VDDPADF      P08 ( .GNDO(GND), .GNDR(GND), .VDD(VDD), .VDDO(VDDOR), .VDDR(VDDOR) );

    ISF          P14 ( .GNDO(GND), .GNDR(GND), .PAD(scan_enable), .PI(d_NULL), 
                       .PO(), .VDD(VDD), .VDDO(VDDOR), .VDDR(VDDOR), .Y(i_scan_enable) );
    ISF          P15 ( .GNDO(GND), .GNDR(GND), .PAD(test_mode), .PI(d_NULL), 
                       .PO(), .VDD(VDD), .VDDO(VDDOR), .VDDR(VDDOR), .Y(i_test_mode) );    

    VDDCPADF     P16 ( .GNDO(GND), .GNDR(GND), .VDD(VDD), .VDDC(vdd_A), 
                       .VDDO(VDDOR), .VDDR(VDDOR) );
    GNDORPADF    P17 ( .GNDOR(GND), .VDD(VDD), .VDDO(VDDOR), .VDDR(VDDOR) );

    VDDPADF      P21 ( .GNDO(GND), .GNDR(GND), .VDD(VDD), .VDDO(VDDOR), .VDDR(VDDOR) );
    GNDORPADF    P22 ( .GNDOR(GND), .VDD(VDD), .VDDO(VDDOR), .VDDR(VDDOR) );
    VDDORPADF    P23 ( .GNDO(GND), .GNDR(GND), .VDD(VDD), .VDDOR(VDDOR) );

    ISF          P25 ( .GNDO(GND), .GNDR(GND), .PAD(write), .PI(d_NULL), 
                       .PO(), .VDD(VDD), .VDDO(VDDOR), .VDDR(VDDOR), .Y(i_write) );
    ISF          P26 ( .GNDO(GND), .GNDR(GND), .PAD(read), .PI(d_NULL), 
                       .PO(), .VDD(VDD), .VDDO(VDDOR), .VDDR(VDDOR), .Y(i_read) );

    ISF          P27 ( .GNDO(GND), .GNDR(GND), .PAD(rst_n), .PI(d_NULL), 
                       .PO(), .VDD(VDD), .VDDO(VDDOR), .VDDR(VDDOR), .Y(i_rst_n) );
    ISF          P28 ( .GNDO(GND), .GNDR(GND), .PAD(clk), .PI(d_NULL), 
                       .PO(), .VDD(VDD), .VDDO(VDDOR), .VDDR(VDDOR), .Y(i_clk) );


    VDDCPADF     P29 ( .GNDO(GND), .GNDR(GND), .VDD(VDD), .VDDC(vdd_A), 
                       .VDDO(VDDOR), .VDDR(VDDOR) );
    GNDORPADF    P30 ( .GNDOR(GND), .VDD(VDD), .VDDO(VDDOR), .VDDR(VDDOR) );


    VDDPADF      P34 ( .GNDO(GND), .GNDR(GND), .VDD(VDD), .VDDO(VDDOR), .VDDR(VDDOR) );
    GNDORPADF    P35 ( .GNDOR(GND), .VDD(VDD), .VDDO(VDDOR), .VDDR(VDDOR) );
    VDDORPADF    P36 ( .GNDO(GND), .GNDR(GND), .VDD(VDD), .VDDOR(VDDOR) );

    GNDORPADF    P41 ( .GNDOR(GND), .VDD(VDD), .VDDO(VDDOR), .VDDR(VDDOR) );
    VDDIPADF     P42 ( .GNDO(GND), .GNDR(GND), .VDD(VDD), .VDDI(vdd_R), 
                       .VDDO(VDDOR), .VDDR(VDDOR) );
    VDDCPADF     P43 ( .GNDO(GND), .GNDR(GND), .VDD(VDD), .VDDC(vdd_A), 
                       .VDDO(VDDOR), .VDDR(VDDOR) );
    GNDORPADF    P44 ( .GNDOR(GND), .VDD(VDD), .VDDO(VDDOR), .VDDR(VDDOR) );

    GNDORPADF    P47 ( .GNDOR(GND), .VDD(VDD), .VDDO(VDDOR), .VDDR(VDDOR) );
    VDDORPADF    P48 ( .GNDO(GND), .GNDR(GND), .VDD(VDD), .VDDOR(VDDOR) );
    VDDPADF      P49 ( .GNDO(GND), .GNDR(GND), .VDD(VDD), .VDDO(VDDOR), .VDDR(VDDOR) );

    BT24F        P19 ( .A(o_scan_out), .EN(d_NULL), .GNDO(GND), .GNDR(GND), 
                       .PAD(scan_out), .VDD(VDD), .VDDO(VDDOR), .VDDR(VDDOR) );    

    BT24F        P20 ( .A(o_data_out[7]), .EN(d_NULL), .GNDO(GND), .GNDR(GND), 
                       .PAD(data_out[7]), .VDD(VDD), .VDDO(VDDOR), .VDDR(VDDOR) );
    BT24F        P24 ( .A(o_data_out[6]), .EN(d_NULL), .GNDO(GND), .GNDR(GND), 
                       .PAD(data_out[6]), .VDD(VDD), .VDDO(VDDOR), .VDDR(VDDOR) );
    BT24F        P31 ( .A(o_data_out[5]), .EN(d_NULL), .GNDO(GND), .GNDR(GND), 
                       .PAD(data_out[5]), .VDD(VDD), .VDDO(VDDOR), .VDDR(VDDOR) );
    BT24F        P32 ( .A(o_data_out[4]), .EN(d_NULL), .GNDO(GND), .GNDR(GND), 
                       .PAD(data_out[4]), .VDD(VDD), .VDDO(VDDOR), .VDDR(VDDOR) );
    BT24F        P33 ( .A(o_data_out[3]), .EN(d_NULL), .GNDO(GND), .GNDR(GND), 
                       .PAD(data_out[3]), .VDD(VDD), .VDDO(VDDOR), .VDDR(VDDOR) );   
    BT24F        P37 ( .A(o_data_out[2]), .EN(d_NULL), .GNDO(GND), .GNDR(GND), 
                       .PAD(data_out[2]), .VDD(VDD), .VDDO(VDDOR), .VDDR(VDDOR) );
    BT24F        P38 ( .A(o_data_out[1]), .EN(d_NULL), .GNDO(GND), .GNDR(GND), 
                       .PAD(data_out[1]), .VDD(VDD), .VDDO(VDDOR), .VDDR(VDDOR) );
    BT24F        P39 ( .A(o_data_out[0]), .EN(d_NULL), .GNDO(GND), .GNDR(GND), 
                       .PAD(data_out[0]), .VDD(VDD), .VDDO(VDDOR), .VDDR(VDDOR) );  


    BT24F        P40 ( .A(o_use_dw[0]), .EN(d_NULL), .GNDO(GND), .GNDR(GND), 
                       .PAD(use_dw[0]), .VDD(VDD), .VDDO(VDDOR), .VDDR(VDDOR) );  
    BT24F        P45 ( .A(o_use_dw[1]), .EN(d_NULL), .GNDO(GND), .GNDR(GND), 
                       .PAD(use_dw[1]), .VDD(VDD), .VDDO(VDDOR), .VDDR(VDDOR) );  
    BT24F        P46 ( .A(o_use_dw[2]), .EN(d_NULL), .GNDO(GND), .GNDR(GND), 
                       .PAD(use_dw[2]), .VDD(VDD), .VDDO(VDDOR), .VDDR(VDDOR) );  
    BT24F        P50 ( .A(o_use_dw[3]), .EN(d_NULL), .GNDO(GND), .GNDR(GND), 
                       .PAD(use_dw[3]), .VDD(VDD), .VDDO(VDDOR), .VDDR(VDDOR) );  
    BT24F        P51 ( .A(o_use_dw[4]), .EN(d_NULL), .GNDO(GND), .GNDR(GND), 
                       .PAD(use_dw[4]), .VDD(VDD), .VDDO(VDDOR), .VDDR(VDDOR) );   
    BT24F        P52 ( .A(o_empty_n), .EN(d_NULL), .GNDO(GND), .GNDR(GND), 
                       .PAD(empty_n), .VDD(VDD), .VDDO(VDDOR), .VDDR(VDDOR) );    
    BT24F        P53 ( .A(o_full_n), .EN(d_NULL), .GNDO(GND), .GNDR(GND), 
                       .PAD(full_n), .VDD(VDD), .VDDO(VDDOR), .VDDR(VDDOR) );                                                                                                                                                                    

    ISF          P01 ( .GNDO(GND), .GNDR(GND), .PAD(data_in[0]), .PI(d_NULL), 
                       .PO(), .VDD(VDD), .VDDO(VDDOR), .VDDR(VDDOR), .Y(i_data_in[0]) );

    ISF          P02 ( .GNDO(GND), .GNDR(GND), .PAD(data_in[1]), .PI(d_NULL), 
                       .PO(), .VDD(VDD), .VDDO(VDDOR), .VDDR(VDDOR), .Y(i_data_in[1]) );

    ISF          P06 ( .GNDO(GND), .GNDR(GND), .PAD(data_in[2]), .PI(d_NULL), 
                       .PO(), .VDD(VDD), .VDDO(VDDOR), .VDDR(VDDOR), .Y(i_data_in[2]) );

    ISF          P07 ( .GNDO(GND), .GNDR(GND), .PAD(data_in[3]), .PI(d_NULL), 
                       .PO(), .VDD(VDD), .VDDO(VDDOR), .VDDR(VDDOR), .Y(i_data_in[3]) );

    ISF          P11 ( .GNDO(GND), .GNDR(GND), .PAD(data_in[4]), .PI(d_NULL), 
                       .PO(), .VDD(VDD), .VDDO(VDDOR), .VDDR(VDDOR), .Y(i_data_in[4]) );

    ISF          P12 ( .GNDO(GND), .GNDR(GND), .PAD(data_in[5]), .PI(d_NULL), 
                       .PO(), .VDD(VDD), .VDDO(VDDOR), .VDDR(VDDOR), .Y(i_data_in[5]) );

    ISF          P13 ( .GNDO(GND), .GNDR(GND), .PAD(data_in[6]), .PI(d_NULL), 
                       .PO(), .VDD(VDD), .VDDO(VDDOR), .VDDR(VDDOR), .Y(i_data_in[6]) );
                       
    ISF          P18 ( .GNDO(GND), .GNDR(GND), .PAD(data_in[7]), .PI(d_NULL), 
                       .PO(), .VDD(VDD), .VDDO(VDDOR), .VDDR(VDDOR), .Y(i_data_in[7]) );                                                                                                                                          

    CORNERESDF   C00 ( .GNDO(GND), .GNDR(GND), .VDD(VDD), .VDDO(VDDOR), .VDDR(VDDOR) );
    CORNERESDF   C01 ( .GNDO(GND), .GNDR(GND), .VDD(VDD), .VDDO(VDDOR), .VDDR(VDDOR) );
    CORNERESDF   C10 ( .GNDO(GND), .GNDR(GND), .VDD(VDD), .VDDO(VDDOR), .VDDR(VDDOR) );
    CORNERESDF   C11 ( .GNDO(GND), .GNDR(GND), .VDD(VDD), .VDDO(VDDOR), .VDDR(VDDOR) );

endmodule
