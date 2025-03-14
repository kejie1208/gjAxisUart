// Copyright is at the end of module
// Authors: Kejie Ma

module gjAxisRcvPkt(
     input              rst     
    ,input              clk     

    ,input      [15:0]  maxBytesPerFrame
    ,input      [15:0]  maxRcvGap
    ,input              clk_en

    ,input              rx_tvalid
    ,input      [ 7:0]  rx_tdata
    ,input              rx_tuser            //1:crc error

    ,output             rx_axis_tvalid
    ,output     [ 7:0]  rx_axis_tdata
    ,output             rx_axis_tlast

    ,output             startError         //1:start error

    ,input              rx
);                  

reg     [7:0]   storeData;

always@(posedge clk)            
if( rst )                           storeData<= 'h0;
else if( rx_tvalid & !rx_tuser   )  storeData<= rx_tdata;

reg     fstByte;
reg     timeOutByte;

assign  rx_axis_tvalid   =  !fstByte & rx_tvalid | timeOutByte ;      


assign  rx_axis_tdata   =    storeData ;    
assign  rx_axis_tlast   =    rx_tvalid & rx_tuser &  !fstByte;    


always@(posedge clk)            
if( rst )                                   fstByte<= 'h1;
else if( rx_axis_tvalid & rx_axis_tlast  )  fstByte<= 1;
else if( rx_tvalid    )                     fstByte<= 0;

//_________________________________________________________________

reg [15:0]  tCnt ;

always@(posedge clk)            
if( rst )                                   tCnt<= 'h0;
else if( rx_tvalid    )                     tCnt<= maxRcvGap;
else if( |tCnt & clk_en )                   tCnt<= tCnt -1 ;


always@(posedge clk)            
if( rst )                                   timeOutByte<= 'h0;
else if( tCnt==0     )                      timeOutByte<= 0;
else if( |tCnt & clk_en )                   timeOutByte<= tCnt -1 ;


timeOutByte


    ,output             rx_axis_tvalid
    ,output     [ 7:0]  rx_axis_tdata
    ,output             rx_axis_tlast

    ,output             startError         //1:start error





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