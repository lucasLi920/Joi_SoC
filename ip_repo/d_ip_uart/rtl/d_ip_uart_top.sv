//================================================================================================
// Engineer        : lucas li (bin)
// E-mail          : libin.lucas@foxmail.com
// Date            : 2023-12-30
// Description     : top level of uart with APB interface
//================================================================================================
module d_ip_uart_top #(
  parameter     ADDR_WD       = 12  ,
  parameter     TX_FIFO_DPL2  = 3   ,
  parameter     RX_FIFO_DPL2  = 3
) (
  input   logic                 PCLK          ,
  input   logic                 PRESETn       ,
  input   logic                 PSEL          ,
  input   logic[ADDR_WD-1:0]    PADDR         ,
  input   logic                 PENABLE       ,
  input   logic                 PWRITE        ,
  input   logic[31:0]           PWDATA        ,
  output  logic[31:0]           PRDATA        ,

  output  logic                 uart_irq      ,
  output  logic                 uart_dma_req  
);
  
endmodule