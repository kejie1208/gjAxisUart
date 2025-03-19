// Copyright is at the end of module
// Authors: Kejie Ma

module gjAxisUartRx(
     input              rst     
    ,input              clk     
    ,input              clk_enX16

    ,input      [3:0]   mode                //[0] 0:2 stopbit ; 1:1 stopbit
                                            //[1] 0:no check  ; 1: check
                                            //[2] 0:no check  ; 1: check
    ,output reg         rx_tvalid
    ,output     [ 7:0]  rx_tdata
    ,output             rx_tuser            //1:crc error

    ,output             startError         //1:start error

    ,input              rx
);                  

localparam RXMAX =    8  + 1      + 1 + 2 ;
                   //Byte  start   ck   stop

reg     [3 : 0 ]      pcnt  ; //phase cnt for 1 bit
reg     [3 : 0 ]      bcnt  ;
reg                   startBit ;
reg     [2:0]         bitSum ;
//________________________________________
wire  start ;
reg [1:0]   rx_store;
always@(posedge clk)            
if( rst )                rx_store<= 'h3;
else if( clk_enX16 )     rx_store<=  {rx_store, rx}  ;

assign start = bcnt == 0 & rx_store==2 ;

//________________________________________

always@(posedge clk)            
if( rst )                                       pcnt<= 'h0  ;  // cnt from TXMAX-1 to 0
else if(  start  )                              pcnt<= 15   ;
else if( clk_enX16 & |bcnt )                    pcnt<= pcnt -1   ;

always@(posedge clk)            
if( rst )                                       bcnt<= 'h0  ;  // cnt from TXMAX-1 to 0
else if(!clk_enX16 )                            bcnt<= bcnt ;
else if(  start & ( mode[0]& mode[1] | mode[0]& mode[2] ) )
                                                bcnt<= RXMAX -0   ;
else if(  start & mode[1] )                     bcnt<= RXMAX -1   ;
else if(  start & mode[2] )                     bcnt<= RXMAX -1   ;
else if(  start  )                              bcnt<= RXMAX -2   ;
else if(  pcnt==0 & startBit & bitSum[1] )      bcnt<= 'h0          ;
else if(  bcnt==1 & pcnt==1  )                  bcnt<= 0            ;
else if(  pcnt==0 & (|bcnt) )                   bcnt<= bcnt -1      ;

//________________________________________ sample 7 8 9 more for bit

always@(posedge clk)            
if( rst )                                       startBit<= 'h1  ;  // cnt from TXMAX-1 to 0
else if(  start  )                              startBit<= 1  ;
else if(  pcnt==0  )                            startBit<= 0  ;

always@(posedge clk)            
if( rst )                                       bitSum<= 'h0  ;  // cnt from TXMAX-1 to 0
else if(  clk_enX16 &   pcnt==0    )            bitSum<= 0; 
else if(  clk_enX16 & (|bcnt) & pcnt==7    )    bitSum<= bitSum + rx_store[0]; 
else if(  clk_enX16 & (|bcnt) & pcnt==8    )    bitSum<= bitSum + rx_store[0]; 
else if(  clk_enX16 & (|bcnt) & pcnt==9    )    bitSum<= bitSum + rx_store[0];

wire       getBitPoint = pcnt == 6 & clk_enX16;
//________________________________________

reg [RXMAX:1] rxData ;

always@(posedge clk)            
if( rst )                                       rxData<= {RXMAX{1'b1}} ;  // cnt from TXMAX-1 to 0
else if(  start  )                              rxData<= {RXMAX{1'b1}} ; 

else if(  getBitPoint & ( mode[0]& mode[1] | mode[0]& mode[2] ) )
                                                rxData<= {          bitSum[1] ,rxData[RXMAX  :2] }  ;
else if(  getBitPoint & mode[1] )               rxData<= { 1'b1   , bitSum[1] ,rxData[RXMAX-1:2] }  ;
else if(  getBitPoint & mode[2] )               rxData<= { 1'b1   , bitSum[1] ,rxData[RXMAX-1:2] }  ;
else if(  getBitPoint  )                        rxData<= { 2'b11  , bitSum[1] ,rxData[RXMAX-2:2] }  ;

always@(posedge clk)            
if( rst )       rx_tvalid<= 1'b1 ;  
else            rx_tvalid<= bcnt == 1 &  getBitPoint ;

assign rx_tdata = rxData[ 2 +: 8 ] ;

wire rxc    = ^rx_tdata;
wire ck     = rxData[10] ;
wire result = rxc ^ ck ;

assign             rx_tuser   = mode[2] ?  ^rx_tdata ^ (~rxData[10])  :
                                mode[1] ?  ^rx_tdata ^ ( rxData[10])  :
                                1'b0       ;
                                
assign         startError  =  pcnt==0 & startBit & bitSum[1]  & clk_enX16 ;


endmodule                  
//@regfine    

/*             
Copyright (c) 2025 regfine.cn

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/