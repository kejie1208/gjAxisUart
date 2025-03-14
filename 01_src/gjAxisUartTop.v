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
    ,output             rx_tlast

    ,output             tx
    ,input              rx
);                  

wire                    powerDown      ;
wire                    softRst        ;

wire                    clk_enX16   ;
wire                    clk_en      ;

wire            [3:0]   mode        ;       //[0] 0:2 stopbit ; 1:1 stopbit
                                            //[1] 0:no check  ; 1: check
                                            //[2] 0:no check  ; 1: check
                                            //[3] 0:no tx nop ; 1: enable tx nop

wire            [15:0]  clkDivX16   ;
wire            [15:0]  txByte_nop      ;           //nop No. of bits time for one frame
wire            [15:0]  txFrame_nop      ;           //nop No. of bits time for one frame

wire                    txBytesInt    ;
wire                    startError    ;
wire                    rxBytesInt    ;
wire                    rxBytesError  ;

wire            [23:0]  maxBytesPerFrame   ;         
wire            [15:0]  maxRcvGap          ;  

gjAxisUartRegs gjAxisUartRegs(
     .rst              (    rst              )
    ,.clk              (    clk              )

    ,.bram_en          (    bram_en          )
    ,.bram_addr        (    bram_addr        )
    ,.bram_we          (    bram_we          )
    ,.bram_wdata       (    bram_wdata       )
    ,.bram_rdata       (    bram_rdata       )

    ,.powerDown        (    powerDown        )
    ,.softRst          (    softRst          )
    ,.mode             (    mode             )
    ,.clkDivX16        (    clkDivX16        )
    ,.txByte_nop       (    tx_ntxByte_nopop )
    ,.txFrame_nop      (    txFrame_nop      )
    
    ,.txBytesInt       (    txBytesInt       )
    ,.startError       (    startError       )
    ,.rxBytesInt       (    rxBytesInt       )
    ,.rxBytesError     (    rxBytesError     )

    ,.maxBytesPerFrame (    maxBytesPerFrame )
    ,.maxRcvGap        (    maxRcvGap        )
);



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

    ,.txByte_nop    (    tx_ntxByte_nopop )
    ,.txFrame_nop   (    txFrame_nop      )

    ,.tx_tvalid     (    tx_tvalid )
    ,.tx_tready     (    tx_tready )
    ,.tx_tdata      (    tx_tdata  )
    ,.tx_tlast      (    tx_tlast  )

    ,.tx            (    tx        )
);

assign           txBytesInt   =   tx_tvalid & tx_tready ;

 wire             rxNotPkt_tvalid ;
 wire     [ 7:0]  rxNotPkt_tdata  ;    
 wire             rxNotPkt_tuser  ;              


gjAxisUartRx gjAxisUartRx(
     .rst           (    softRst    ) 
    ,.clk           (    clk        ) 
    ,.clk_enX16     (    clk_enX16  ) 
    ,.mode          (    mode       ) 
    ,.rx_tvalid     (    rxNotPkt_tvalid  ) 
    ,.rx_tdata      (    rxNotPkt_tdata   ) 
    ,.rx_tuser      (    rxNotPkt_tuser   ) 
    ,.startError    (    startError ) 
    ,.rx            (    rx         ) 
);

gjAxisRcvPkt gjAxisRcvPkt(
     .rst              (      rst              )
    ,.clk              (      clk              )

    ,.maxBytesPerFrame (      maxBytesPerFrame )
    ,.maxRcvGap        (      maxRcvGap        )

    ,.clk_en           (      clk_en           )
    ,.rx_tvalid        (      rxNotPkt_tvalid        )
    ,.rx_tdata         (      rxNotPkt_tdata         )
    ,.rx_tuser         (      rxNotPkt_tuser         )

    ,.rx_axis_tvalid   (      rx_tvalid   )
    ,.rx_axis_tdata    (      rx_tdata    )
    ,.rx_axis_tlast    (      rx_tlast    )
);

assign                   rxBytesInt     = rxNotPkt_tvalid  ;
assign                   rxBytesError   = rxNotPkt_tuser  ;

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