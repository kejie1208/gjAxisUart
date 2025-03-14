// Copyright is at the end of module
// Authors: Kejie Ma

module gjAxisBaudrate(
     input              rst     
    ,input              clk     

    ,input      [15:0]  clkDivX16   

    ,output reg         clk_en
    ,output reg         clk_enX16
);                  

reg     [15:0]  cntX16 ;

always@(posedge clk)            
if( rst )                cntX16<= 'h1;
else if( cntX16==1   )   cntX16<= clkDivX16 ;
else                     cntX16<= cntX16 -1 ;

reg     [3:0]   pCnt    ;
always@(posedge clk)            
if( rst )                   pCnt<= 'hf;
else if( cntX16==1   )      pCnt<= pCnt -1  ;

always@(posedge clk)            
if( rst )                   clk_enX16<= 'h0;
else                        clk_enX16<= cntX16==1  ;

always@(posedge clk)            
if( rst )                   clk_enX16<= 'h0;
else                        clk_enX16<= cntX16==1 & pCnt==0  ;

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