// Copyright is at the end of module
// Authors: Kejie Ma

module gjAxisUartTop(
     input              rst     
    ,input              clk     

    ,input              bram_en	    
    ,input      [3:0]   bram_addr   	    
    ,input      [3:0]   bram_we     	    
    ,input      [31:0]  bram_wdata  	    
    ,output     [31:0]  bram_rdata  	

    ,input              tx_tvalid
    ,output             tx_tready
    ,input      [ 7:0]  tx_tdata
    ,input              tx_tlast

    ,output             rx_tvalid
    ,output     [ 7:0]  rx_tdata
    ,output             rx_tuser            //1:crc error
    ,output             rx_tlast

    ,output             tx
    ,input              rx
);                  

wire                    powerDown      ;
wire                    softRst        ;

wire                    clk_enX16   ;
wire                    clk_en      ;

wire            [15:0]  clkDivX16   ;
wire            [3:0]   mode        ;       //[0] 0:2 stopbit ; 1:1 stopbit
                                            //[1] 0:no check  ; 1: check
                                            //[2] 0:no check  ; 1: check

wire            [15:0]  tx_nop      ;           //nop No. of bits time for one frame
wire                    startError  ;       //1:start error


gjAxisBaudrate gjAxisBaudrate(
     .rst           (    softRst       )
    ,.clk           (    clk       )
    ,.clkDivX16     (    clkDivX16 )
    ,.clk_en        (    clk_en    )
    ,.clk_enX16     (    clk_enX16 )
);


gjAxisUartTx gjAxisUartTx(
     .rst           (    softRst       )
    ,.clk           (    clk       )

    ,.clk_en        (    clk_en    )
    ,.mode          (    mode      )

    ,.tx_nop        (    tx_nop    )
    ,.tx_tvalid     (    tx_tvalid )
    ,.tx_tready     (    tx_tready )
    ,.tx_tdata      (    tx_tdata  )
    ,.tx_tlast      (    tx_tlast  )

    ,.tx            (    tx        )
);

 wire             rxNpkt_tvalid ;
 wire     [ 7:0]  rxNpkt_tdata  ;    
 wire             rxNpkt_tuser  ;              


gjAxisUartRx gjAxisUartRx(
     .rst           (    softRst    ) 
    ,.clk           (    clk        ) 
    ,.clk_enX16     (    clk_enX16  ) 
    ,.mode          (    mode       ) 
    ,.rx_tvalid     (    rxNpkt_tvalid  ) 
    ,.rx_tdata      (    rxNpkt_tdata   ) 
    ,.rx_tuser      (    rxNpkt_tuser   ) 
    ,.startError    (    startError ) 
    ,.rx            (    rx         ) 
);




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