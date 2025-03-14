// Copyright is at the end of module
// Authors: Kejie Ma

module gjAxisUartRegs(
     input              rst     
    ,input              clk     

    ,input              bram_en	    
    ,input      [2:0]   bram_addr   	    
    ,input      [3:0]   bram_we     	    
    ,input      [31:0]  bram_wdata  	    
    ,output reg [31:0]  bram_rdata  	

    ,output reg         powerDown     
    ,input              softRst   

    ,output  reg[3:0]   mode                //[0] 0:2 stopbit ; 1:1 stopbit
                                            //[1] 0:no check  ; 1: check
                                            //[2] 0:no check  ; 1: check
                                            //[3] 0:no tx nop ; 1: enable tx nop
    ,output reg [15:0]  clkDivX16    

    ,output  reg[15:0]  txByte_nop               //nop No. of bits time for one byte
    ,output  reg[15:0]  txFrame_nop              //nop No. of bits time for one frame

    ,input              txBytesInt
    ,input              startError          //1:start error
    ,input              rxBytesInt
    ,input              rxBytesError

    ,output  reg[23:0]  maxBytesPerFrame            
    ,output  reg[15:0]  maxRcvGap           
);                  

always@(posedge clk)            
if( rst )                                           powerDown<= 'h0;
else if(  bram_en & bram_addr==0 & bram_we[0]   )   powerDown<= bram_wdata[0];


always@(posedge clk)            
if( rst )                                           mode<= 'h0;
else if(  bram_en & bram_addr==0 & bram_we[1]   )   mode<= bram_wdata[8 +:4];

always@(posedge clk)            
if( rst )                   clkDivX16<= 54253;
else if(  bram_en & bram_addr==0    )
    begin
        if( bram_we[3] )    clkDivX16[8 +:8] <= bram_wdata[24 +:8];
        if( bram_we[2] )    clkDivX16[0 +:8] <= bram_wdata[16 +:8];
    end   


always@(posedge clk)            
if( rst )                   txByte_nop<= 'h0;
else if(  bram_en & bram_addr==1    )
    begin
        if( bram_we[1] )    txByte_nop[8 +:8] <= bram_wdata[8  +:8];
        if( bram_we[0] )    txByte_nop[0 +:8] <= bram_wdata[0  +:8];
    end   

always@(posedge clk)            
if( rst )                   txFrame_nop<= 'h0;
else if(  bram_en & bram_addr==1    )
    begin
        if( bram_we[3] )    txFrame_nop[8 +:8] <= bram_wdata[23 +:8];
        if( bram_we[2] )    txFrame_nop[0 +:8] <= bram_wdata[16 +:8];
    end   

always@(posedge clk)            
if( rst )                   maxRcvGap<= 'h0;
else if(  bram_en & bram_addr==2    )
    begin
        if( bram_we[1] )    maxRcvGap[8 +:8] <= bram_wdata[8  +:8];
        if( bram_we[0] )    maxRcvGap[0 +:8] <= bram_wdata[0  +:8];
    end   
 
always@(posedge clk)            
if( rst )                   maxBytesPerFrame<= 'h0;
else if(  bram_en & bram_addr==3    )
    begin
        if( bram_we[2] )    maxBytesPerFrame[16+:8] <= bram_wdata[16 +:8];
        if( bram_we[1] )    maxBytesPerFrame[8 +:8] <= bram_wdata[8  +:8];
        if( bram_we[0] )    maxBytesPerFrame[0 +:8] <= bram_wdata[0  +:8];
    end   
//____________________________________________________________________  status
reg [31:0]  txBytes ;
reg [31:0]  rxBytes ;
reg [31:0]  rxErrorBytes ;
reg [31:0]  rxStartErrorCnt ;

always@(posedge clk)            
if( rst )                   txBytes<= 'h0;
else if( softRst )          txBytes<= 'h0;
else if( txBytesInt )       txBytes<= txBytes + 1;

always@(posedge clk)            
if( rst )                   rxBytes<= 'h0;
else if( softRst )          rxBytes<= 'h0;
else if( rxBytesInt )       rxBytes<= rxBytes + 1;

always@(posedge clk)            
if( rst )                   rxErrorBytes<= 'h0;
else if( softRst )          rxErrorBytes<= 'h0;
else if( rxBytesInt & rxBytesError )       rxErrorBytes<= rxErrorBytes + 1;

always@(posedge clk)            
if( rst )                   rxStartErrorCnt<= 'h0;
else if( softRst )          rxStartErrorCnt<= 'h0;
else if( startError )       rxStartErrorCnt<= rxStartErrorCnt + 1;



//____________________________________________________________________
always@(posedge clk)            
if( rst )                   bram_rdata<= 'h0;
else if(  bram_en  )
    case( bram_addr )
        0:  bram_rdata<={  clkDivX16,  4'h0, mode, 6'h0, softRst ,  powerDown};
        1:  bram_rdata<={  txFrame_nop   ,  txByte_nop };
        2:  bram_rdata<={  16'h0    ,  maxRcvGap };
        3:  bram_rdata<={   8'h0    ,  maxBytesPerFrame };

        4:  bram_rdata<=    txBytes ;
        5:  bram_rdata<=    rxBytes ;
        6:  bram_rdata<=    rxErrorBytes ;
        7:  bram_rdata<=    rxStartErrorCnt ;

        default :   bram_rdata<= 'h0 ;
    endcase
        


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