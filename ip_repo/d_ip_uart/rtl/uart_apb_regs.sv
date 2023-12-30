module moduleName #(
  parameter   ADDR_WD       = 12  ,                 // uart memeory slot size
  parameter   TX_FIFO_DPL2  = 3   ,                 // tx fifo depth log2
  parameter   RX_FIFO_DPL2  = 3                     // rx fifo depth log2
) (
  input   logic[ADDR_WD-1:0]        apb_addr            ,
  input   logic                     apb_read_en         ,
  input   logic                     apb_write_en        ,
  input   logic[31:0]               apb_wdata           ,
  output  logic[31:0]               apb_rdata           ,

  input   logic                     sr_reg_pe           ,   // parity error
  input   logic                     sr_reg_fe           ,   // frame error
  input   logic                     sr_reg_ne           ,   // noise error
  input   logic                     sr_reg_ore          ,   // overrrun error'
  input   logic                     sr_reg_idle         ,   // idle
  input   logic                     sr_reg_rxne         ,   // read data reg not empty
  input   logic                     sr_reg_tc           ,   // TX complete
  input   logic                     sr_reg_txe          ,   // TX data reg empty
    
  output  logic[8:0]                txd_reg_txd         ,   // TX data for transmit
  input   logic[8:0]                rxd_reg_rxd         ,   // RX data from RX
  output  logic[11:0]               br_reg_mentissa     ,   // baud rate mentissa part
  output  logic[3:0]                br_reg_fraction     ,   // baud rate fraction part
  
  output  logic                     cr0_reg_rxwk_en     ,   // RX wakeup enable
  output  logic                     cr0_reg_re          ,   // RX enable
  output  logic                     cr0_reg_te          ,   // TX enable
  output  logic                     cr0_reg_idle_ie     ,   // when idle in status valid enable intrrupt
  output  logic                     cr0_reg_rxne_ie     ,   //
  output  logic                     cr0_reg_tc_ie       ,   //
  output  logic                     cr0_reg_txe_ie      ,   //
  output  logic                     cr0_reg_pe_ie       ,   //
  output  logic                     cr0_reg_errie       ,   // fe/ore/ne
  output  logic                     cr0_reg_ps          ,   // parity select 0: even 1: odd
  output  logic                     cr0_reg_pce         ,   // parity enable 0: disable 1: enable
  output  logic                     cr0_reg_wdlen       ,   // data word length 0: 8b 1: 9b
  output  logic[1:0]                cr0_reg_stoplen     ,   // length of stop bit 00: 1b
  
  output  logic                     cr1_reg_dmate       ,   // enable DMA trans for TX
  output  logic                     cr1_reg_dmare       ,   // enable DMA trans for RX
  output  logic                     cr1_reg_tfwk_ie     ,   // TX FIFO water mark hit ie
  output  logic                     cr1_reg_rfwk_ie     ,   // RX FIFO water mark hit ie
  output  logic                     cr1_reg_tfov_ie     ,   // TX FIFO overflow ie
  output  logic                     cr1_reg_rfud_ie     ,   // RX fifo underflow ie 

  output  logic[TX_FIFO_DPL2-1:0]   tfifo_reg_wk        ,   // TX FIFO water mark
  output  logic[TX_FIFO_DPL2-1:0]   rfifo_reg_wk            // RX FIFO water mark
);
// ----------------------------------------------------------------------------
// UART APB registers OFFSET
// ----------------------------------------------------------------------------
localparam  VERID_ADDR      = 32'h0000_0000;
localparam  SR_ADDR         = 32'h0000_0004;    // status reg
localparam  TDR_ADDR        = 32'h0000_0008;    // TX data reg
localparam  RDR_ADDR        = 32'h0000_000C;    // RX data reg
localparam  BRR_ADDR        = 32'h0000_0010;    // baud rate reg
localparam  CR0_ADDR        = 32'h0000_0014;    // control reg0
localparam  CR1_ADDR        = 32'h0000_0018;    // control reg1
localparam  TFIFO_ADDR      = 32'h0000_0020;    // TX FIFO control reg
localparam  RFIFO_ADDR      = 32'h0000_0024;    // RX FIFO control reg

logic[31:0] uart_status_reg;


endmodule