`timescale 1ns/1ns             
module gjAxisUartTop_tb();                  

reg                rst     =1; 
reg                clk     =1; 

initial #95        rst     =0; 

localparam HALFPERIOD = 10/2;
always                         
  begin                        
    #HALFPERIOD clk = 0;                
    #HALFPERIOD clk = 1;                
  end                          

                 


reg                bram_en	    =0  ;              
reg        [2:0]   bram_addr   	=0  ;                  
reg        [3:0]   bram_we     	=0  ;                  
reg        [31:0]  bram_wdata  	=0  ;                  
wire       [31:0]  bram_rdata  	  ;  

reg                tx_tvalid    = 0   ;          
wire               tx_tready          ;          
reg        [ 7:0]  tx_tdata     = 0   ;         
wire               tx_tlast           ;   

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

task pktTest;
  begin
    
            txPkt(100,10);
            txPkt(10,6);
  end
endtask

localparam BRNUM = 2;
localparam PKGTP = 3;

reg [3:0]  mode =0;
reg [8*32-1:0]          testPart ;
reg [23:0]              testBaudRate[BRNUM];
reg [16+16+16+24-1:0]   testPktType  [PKGTP];

initial begin
  testBaudRate[0]=115200 ;
  testBaudRate[1]=9600 ;

  testPktType[0]={16'd3, 16'd16 , 16'd16, 24'd64} ;
  testPktType[1]={16'd1, 16'd20 , 16'd20, 24'd34} ;
  testPktType[2]={16'd0, 16'd0, 16'd0, 24'd0} ;

end

integer baudRateIndex = 0;
integer pktTypeIndex = 0;

wire [15:0]  txByte_nop          = testPktType[pktTypeIndex][24+16+16+:16 ]    ;  
wire [15:0]  txFrame_nop         = testPktType[pktTypeIndex][24+16   +:16 ]    ;  
wire [15:0]  maxRcvGap           = testPktType[pktTypeIndex][24      +:16 ]    ;  
wire [23:0]  maxBytesPerFrame    = testPktType[pktTypeIndex][00      +:24 ]    ;  

initial                        
  begin                        
    @(negedge rst);                
    repeat(2000) @(posedge clk);  

    //setPkt( txByte_nop  , txFrame_nop   , maxRcvGap  , maxBytesPerFrame  );
    repeat(BRNUM) 
      begin

        $display("baudrate =%d, %d \n ", baudRateIndex , testBaudRate[baudRateIndex]  ) ;
        setBaudrate(testBaudRate[baudRateIndex]);
        repeat(PKGTP)
          begin
            setPkt(txByte_nop, txFrame_nop ,maxRcvGap , maxBytesPerFrame  );
            repeat(16)//mode
              begin
                setMod(mode);
                //$display("baudrate =%d, %d \n ", baudRateIndex , testBaudRate[baudRateIndex]  ) ;
                pktTest();
                mode <= mode +1 ;
                repeat(1000)@(posedge clk);
              end
            pktTypeIndex =pktTypeIndex +1;
            if(pktTypeIndex == PKGTP) pktTypeIndex = 0 ;
          end  
        baudRateIndex = baudRateIndex +1 ;
        if(baudRateIndex == BRNUM) baudRateIndex = 0 ;
      end


    repeat(200000) @(posedge clk);   
    $finish(2);               
  end         

//_____________________________________________________________  ck pkg
integer rcvPkgLen;
always@(posedge clk)
if( rx_tvalid & rx_tlast )
  begin
    rcvPkgLen = rcvPkgLen +1 ;
    $$display("rcvPkg len[%d] , rcvByts[%d], errorBytes[%d], startErrorBytes[%d]", rcvPkgLen, 
                                gjAxisUartTop.gjAxisUartRegs.rxBytes,
                                gjAxisUartTop.gjAxisUartRegs.rxErrorBytes,
                                gjAxisUartTop.gjAxisUartRegs.rxStartErrorCnt  );
  end
else if( rx_tvalid )
  begin
    rcvPkgLen  =rcvPkgLen +1 ;
  end

//_____________________________________________________________ tasks
reg [15:0]   Cnt=1000;
task txPkt;
        input   [ 7:0]  startData;
        input   [15:0]  Len;
    begin
        Cnt<= Len ;
        tx_tdata  <= startData ;
        tx_tvalid<=1;
        $display("tx_tdata =%d ;bd = %d pktTypeIndex= %d mode=%x",tx_tdata ,testBaudRate[baudRateIndex],pktTypeIndex, mode ) ;
        @(negedge tx_tvalid);
        //@(posedge Cnt == 0 );
    end
endtask //txPkt 


always@(posedge clk)
if( tx_tvalid & tx_tready & (|Cnt) )Cnt<=Cnt -1 ;

always@(posedge clk)
if( tx_tvalid & tx_tready   )tx_tdata<=tx_tdata + 1 ;

assign tx_tlast = Cnt==1; 

always@(posedge clk)
if( tx_tvalid & tx_tready & tx_tlast )tx_tvalid<=0 ;

//_____________________________________________________________
task setMod;
    input   [3:0] mode ;   //0: no ckeck ; 1: Odd check  2 :even check
    begin
      
      bram_en	      <=1  ;              
      bram_addr   	<=0  ;                  
      bram_we     	<=4'b0010  ;                  
      bram_wdata  	<=mode <<8 ;          
      @(posedge clk);
      bram_en	      <=0  ;    
    end
endtask

task setBaudrate;
    input   [23:0] baurdRate ;   //0: no ckeck ; 1: Odd check  2 :even check
    begin
      
      $display("setb = %d  wdata = 0x%x \n ",baurdRate ,  (HALFPERIOD*20000000/16/baurdRate)  ) ;

      bram_en	      <=1  ;              
      bram_addr   	<=0  ;                  
      bram_we     	<=4'b1100  ;                  
      bram_wdata  	<=(HALFPERIOD*20000000/16/baurdRate) <<16 ;         
      
      
      @(posedge clk);
      bram_en	      <=0  ;    
    end
endtask

task setPkt;
    input [15:0]  txByte_nop        ;       //nop No. of bits time for one byte
    input [15:0]  txFrame_nop       ;       //nop No. of bits time for one frame

    input [15:0]  maxRcvGap               ;       //nop No. of bits time for one byte
    input [23:0]  maxBytesPerFrame        ;       //nop No. of bits time for one frame
    begin
      
      bram_en	      <=1  ;              
      bram_addr   	<=1  ;                  
      bram_we     	<=4'b1111  ;                  
      bram_wdata  	<={ txFrame_nop , txByte_nop } ;          
      @(posedge clk);
      bram_en	      <=0  ;            
      @(posedge clk);

      bram_en	      <=1  ;              
      bram_addr   	<=2  ;                  
      bram_we     	<=4'b0011  ;                  
      bram_wdata  	<={ 16'h0, maxRcvGap } ;          
      @(posedge clk);
      bram_en	      <=0  ;    
      
      @(posedge clk);
      bram_en	      <=0  ;            
      @(posedge clk);

      bram_en	      <=1  ;              
      bram_addr   	<=3  ;                  
      bram_we     	<=4'b1111  ;                  
      bram_wdata  	<={ 8'h0, maxBytesPerFrame } ;          
      @(posedge clk);
      bram_en	      <=0  ;    

    end
endtask



//______________________________________________________________
initial 
  begin                     
    $dumpfile("gjAxisUartTop_tb.vcd");  
    $dumpvars(0,  gjAxisUartTop_tb);       
  end                          

endmodule                  
//@regfine                 