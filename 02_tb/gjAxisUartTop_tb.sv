`timescale 1ns/1ns             
module gjAxisUartTop_tb();                  

reg                rst     =1; 
reg                clk     =1; 

initial #95        rst     =0; 

always                         
  begin                        
    #5 clk = 0;                
    #5 clk = 1;                
  end                          


initial                        
  begin                        
    @(negedge rst);                
    repeat(2000) @(posedge clk);   
    $finish(2);               
  end                          


reg                bram_en	    =0  ;              
reg        [3:0]   bram_addr   	=0  ;                  
reg        [3:0]   bram_we     	=0  ;                  
reg        [31:0]  bram_wdata  	=0  ;                  
wire       [31:0]  bram_rdata  	  ;  

reg                tx_tvalid    = 0   ;          
wire               tx_tready          ;          
reg        [ 7:0]  tx_tdata     = 0   ;         
reg                tx_tlast     = 0   ;   

wire               rx_tvalid      ;          
wire       [ 7:0]  rx_tdata       ;         
wire               rx_tlast       ;  

wire               tx             ;   
wire               rx    = tx     ;   


gjAxisUartTop gjAxisUartTop(
     .rst        (    rst        ) 
    ,.clk        (    clk        ) 
    ,.bram_en    (    bram_en    ) 
    ,.bram_addr  (    bram_addr  ) 
    ,.bram_we    (    bram_we    ) 
    ,.bram_wdata (    bram_wdata ) 
    ,.bram_rdata (    bram_rdata ) 
    ,.tx_tvalid  (    tx_tvalid  ) 
    ,.tx_tready  (    tx_tready  ) 
    ,.tx_tdata   (    tx_tdata   ) 
    ,.tx_tlast   (    tx_tlast   ) 
    ,.rx_tvalid  (    rx_tvalid  ) 
    ,.rx_tdata   (    rx_tdata   ) 
    ,.rx_tlast   (    rx_tlast   ) 
    ,.tx         (    tx         ) 
    ,.rx         (    rx         )
);




initial                        
  begin                        
    $dumpfile("gjAxisUartTop_tb.vcd");  
    $dumpvars(0,  gjAxisUartTop_tb);       
  end                          

endmodule                  
//@regfine                 