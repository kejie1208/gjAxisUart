// Copyright is at the end of module
// Authors: Kejie Ma

module gjAxisUartTx(
     input              rst     
    ,input              clk     
    ,input              clk_en

    ,input      [3:0]   mode                //[0] 0:2 stopbit ; 1:1 stopbit
                                            //[1] 0:no check  ; 1: check
                                            //[2] 0:no check  ; 1: check
                                            //[3] 0:no tx nop ; 1: enable tx nop
    ,input      [15:0]  tx_nop              //nop No. of bits time for one frame

    ,input              tx_tvalid
    ,output             tx_tready
    ,input      [ 7:0]  tx_tdata
    ,input              tx_tlast

    ,output             tx
);                  

localparam TXMAX =    8  + 1      + 1 + 2 ;
                   //Byte  start   ck   stop

reg     [TXMAX : 1 ]  txData;
reg     [3 : 0 ]      bcnt  ;


always@(posedge clk)            
if( rst )                                       txData<= {TXMAX{1'b1}};
else if(!clk_en | !nopEn)                       txData<= txData ;
else if(  bcnt==0  & tx_tvalid & mode[1] )      txData<= {1'b0, tx_tdata ,   ^tx_tdata  ,2'b11 }   ;
else if(  bcnt==0  & tx_tvalid & mode[2] )      txData<= {1'b0, tx_tdata , ~(^tx_tdata) ,2'b11 }   ;
else if(  bcnt==0  & tx_tvalid   )              txData<= {1'b0, tx_tdata , 1'b1 ,2'b11 }   ;
else                                            txData<= { txData, 1'b1 }  ;

always@(posedge clk)            
if( rst )                                       bcnt<= 'h0  ;  // cnt from TXMAX-1 to 0
else if(!clk_en | !nopEn)                       bcnt<= bcnt ;
else if(  bcnt==0  & tx_tvalid & ( mode[0]& mode[1] | mode[0]& mode[2] ) )
                                                bcnt<= TXMAX -1   ;
else if(  bcnt==0  & tx_tvalid & mode[1] )      bcnt<= TXMAX -2   ;
else if(  bcnt==0  & tx_tvalid & mode[2] )      bcnt<= TXMAX -2   ;
else if(  bcnt==0  & tx_tvalid  )               bcnt<= TXMAX -3   ;
else                                            bcnt<=  bcnt -1   ;

assign tx_tready = bcnt==1 & clk_en ;


assign tx = txData[TXMAX];

//___________________________________________________for nop
reg [15:0]  nopCnt; 

always@(posedge clk)            
if( rst )                                       nopCnt<= 0;
else if( clk_en & mode[3] & tx_tvalid & tx_tready & tx_tlast )
                                                nopCnt<= tx_nop ;
else if( clk_en & mode[3] & (|nopCnt) )         nopCnt<= nopCnt -1  ;
else if( clk_en  )                              nopCnt<= 0;

assign  nopEn = nopCnt == 0 ;

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