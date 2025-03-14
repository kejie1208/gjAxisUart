# gjAxisUart

<p align="center">
    <a href="./README-zh.md">中文</a> |
    English
</p>

---

[![GitHub Stars](https://img.shields.io/github/stars/kejie1208/Plugcat.svg?style=social)](https://github.com/kejie1208/gjAxisUart/stargazers)
[![GitHub License](https://img.shields.io/github/license/SuperSodaSea/Plugcat)](https://github.com/kejie1208/gjAxisUart/blob/main/LICENSE)

a UART with an AXIS interSace。

The work is still ongoing; just two modules have been done.

<link rel="stylesheet" type="text/css" href="mkAutoNumber.css" />

## Features

- Configurable baud rate
- Parity check
- Configurable stop bits (1 or 2 bits)
- AXI interface, CPU uses DMA for reception and transmission
- Automatic packet assembly configuration for reception
  - Configure the maximum frame length, submit a frame
  - Submit a frame upon reaching the configured timeout duration

## Architecture
啊啊

## Interface


| signal            | IO | discription                              |
|:---------         |:-----     | :----------------------------------- |
| rst               | I  | Synchronous reset with clk                           |
| clk               | I  | the clock                               |
|___________________|___|___________________|
| tx_axis_tvalid    | I  | AXI transmit section                    |
| tx_axis_tready    | O  |                                  |
| tx_axis_tdata[7:0]| I  |                                  |
| tx_axis_tlast     | I  | Used to control the inter-frame gap      |
|___________________|___|___________________|
| rx_axis_tvalid    | O  | AXI receive section                    |
| rx_axis_tready    | I  |                                  |
| rx_axis_tdata[7:0]| O  |                                  |
| rx_axis_tlast     | O  |                                  |
|___________________|____|___________________|
| bram_en           | I  | bram interface for configuration                       |
| bram_addr[3:0]    | I  | the same as the Xilinx BRAM interface             |
| bram_we[3:0]      | I  | may connect to Xilinx Axi2bram ip               |
| bram_wdata[31:0]  | I  |                                  |
| bram_rdata[31:0]  | O  | rdata becomes valid one clock cycle after en is active.         |
|___________________|____|___________________|

no interrupt interface, if necessary, please use DMA interrupts，or：
  - tx int: tx_axis_tvalid& tx_axis_tready & tx_axis_tlast  
  - rx_int: rx_axis_tvalid& rx_axis_tready & rx_axis_tlast 



## Code

Verilog HDL。

### Tools

- [iverilog](https://bleyer.org/icarus/)（for simulation）
- [Vivado](https://www.amd.com/en/products/software/adaptive-socs-and-fpgas/vivado.html)（gen Xilinx FPGA bit）

## Simulation

execute make to run the simulation in the 02_tb directory：
```bash
cd 02_tb
make
```

## run in FPGA board


### build bit


```bash


```


## pictures

![Module Photo 2](./02_doc/Module-Photo-2.jpg)
![Module Photo 3](./02_doc/Module-Photo-3.jpg)
