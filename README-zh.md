# gjAxisUart

<p align="center">
    <a href="./README.md">English</a> |
    中文
</p>

---

[![GitHub Stars](https://img.shields.io/github/stars/kejie1208/Plugcat.svg?style=social)](https://github.com/kejie1208/gjAxisUart/stargazers)
[![GitHub License](https://img.shields.io/github/license/SuperSodaSea/Plugcat)](https://github.com/kejie1208/gjAxisUart/blob/main/LICENSE)

一个aixs接口的uart ip。

还未结束，刚做了3个模块。
gjAxisBaudrate
gjAxisUartTx
gjAxisUartRx

<link rel="stylesheet" type="text/css" href="mkAutoNumber.css" />

## 特性

- 波特率可配置
- 奇偶校验
- 停止位1、2bit可配
- axis接口，cpu使用dma接收发送
- 接收自动组包配置
  - 配置最大帧长，提交一帧
  - 配置的超时时间，提交一帧

## 结构

![Module Photo 2](./02_doc/Module-Photo-2.jpg)

## 接口描述


| 名称               | 输入输出 | 描述                              |
|:---------         |:-----     | :----------------------------------- |
| rst               | I  | 同步复位                           |
| clk               | I  | 时钟                               |
|___________________|___|___________________|
| tx_axis_tvalid    | I  | 发送axis  部份                    |
| tx_axis_tready    | O  |                                  |
| tx_axis_tdata[7:0]| I  |                                  |
| tx_axis_tlast     | I  | 用来控制帧间隔      |
|___________________|___|___________________|
| rx_axis_tvalid    | O  | 接收axis  部份                    |
| rx_axis_tready    | I  |                                  |
| rx_axis_tdata[7:0]| O  |                                  |
| rx_axis_tlast     | O  |                                  |
|___________________|____|___________________|
| bram_en           | I  | bram配置部份                       |
| bram_addr[3:0]    | I  | 时序同 Xilinx Bram                 |
| bram_we[3:0]      | I  | 可接Xilinx Axi2bram ip               |
| bram_wdata[31:0]  | I  |                                  |
| bram_rdata[31:0]  | O  | rdata在en有效下一周期有效           |
|___________________|____|___________________|

无中断产生，中断请使用dma中断，或者：
  - 发送使用tx_axis_tvalid& tx_axis_tready & tx_axis_tlast
  - 接收使用rx_axis_tvalid& rx_axis_tready & rx_axis_tlast



## 代码

示例代码在 Windows 与 Linux 下均可构建。<br>
Verilog HDL。

### 依赖工具

- [iverilog](https://bleyer.org/icarus/)（用于仿真）
- [Vivado](https://www.amd.com/en/products/software/adaptive-socs-and-fpgas/vivado.html)（用于构建 Xilinx FPGA 工程）

## 仿真

到tb目录下运行 make 进行仿真：
```bash
cd 02_tb
make
```

## 已验证 FPGA 板卡


### 构建示例代码

在对应示例代码目录下运行以下命令即可构建示例代码：

```bash

```


## 框图

![Module Photo 2](./images/Module-Photo-2.jpg)
