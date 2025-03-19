// Copyright is at the end of module
// Authors: Kejie Ma

module gjAxisRcvPkt(
     input              rst     
    ,input              clk     

    ,input              powerDown_tvalid 
    ,output             powerDown_tready 

    ,input      [23:0]  maxBytesPerFrame
    ,input      [15:0]  maxRcvGap
    ,input              clk_en

    ,input              rx_tvalid
    ,input      [ 7:0]  rx_tdata
    ,input              rx_tuser            //1:crc error

    ,output             rx_axis_tvalid
    ,output     [ 7:0]  rx_axis_tdata
    ,output             rx_axis_tlast

);                  

reg     [7:0]   storeData;

always@(posedge clk)            
if( rst )                           storeData<= 'h0;
else if( rx_tvalid & !rx_tuser   )  storeData<= rx_tdata;

reg     fstByte;
reg     timeOutByte;
reg     bytesOver;

assign  rx_axis_tvalid   =  !fstByte & rx_tvalid | timeOutByte | bytesOver;      


assign  rx_axis_tdata   =    storeData ;    
assign  rx_axis_tlast   =    rx_tvalid & rx_tuser &  !fstByte | timeOutByte | bytesOver;    


always@(posedge clk)            
if( rst )                                   fstByte<= 'h1;
else if( rx_axis_tvalid & rx_axis_tlast  )  fstByte<= 1;
else if( rx_tvalid    )                     fstByte<= 0;

//_________________________________________________________________ time over

reg [15:0]  tCnt ;

always@(posedge clk)            
if( rst )                                   tCnt<= 'h0;
else if( rx_tvalid    )                     tCnt<= maxRcvGap;
else if( |tCnt & clk_en )                   tCnt<= tCnt -1 ;


always@(posedge clk)            
if( rst )                                   timeOutByte<= 'h0;
else if( rx_axis_tvalid )                   timeOutByte<= 'h0;
else                                        timeOutByte<= tCnt==0 & !fstByte | powerDown_tvalid & !fstByte;  


//_________________________________________________________________ bytes over

reg [23:0]  bCnt ;

always@(posedge clk)            
if( rst )                                   bCnt<= 'hffffff;
else if( rx_tvalid & fstByte | bytesOver )  bCnt<= maxBytesPerFrame;
else if( rx_tvalid )                        bCnt<= bCnt -1 ;


always@(posedge clk)            
if( rst )                                   bytesOver<= 'h0;
else if( rx_axis_tvalid )                   bytesOver<= 'h0;
else                                        bytesOver<= bCnt==1 ;  



assign powerDown_tready = fstByte | rx_axis_tvalid & rx_axis_tlast ;



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