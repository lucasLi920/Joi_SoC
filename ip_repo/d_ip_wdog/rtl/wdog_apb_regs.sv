//================================================================================================
// Engineer        : lucas li (bin)
// E-mail          : libin.lucas@foxmail.com
// Date            : 2023-12-31
// Description     : wdog internal registers refer to STM32 MCU and modify
//================================================================================================
module wdog_apb_regs #(
  parameter   ADDR_WD       = 12  ,                         // memeory slot size
  parameter   WDOG_CNT      = 16                            // wdog timer bits 8-30
) (
  input   logic                     pclk                ,
  input   logic                     preset_n            ,
  input   logic[ADDR_WD-1:0]        apb_addr            ,
  input   logic                     apb_read_en         ,
  input   logic                     apb_write_en        ,
  input   logic[31:0]               apb_wdata           ,
  output  logic[31:0]               apb_rdata           ,

  input   logic                     wdog_rst_n          ,   // cold reset from system controller
  output  logic                     cr_reg_wdga         ,   // wdog activation bit
  output  logic[WDOG_CNT-1:0]       cr_reg_time         ,   // wdog timer value
  output  logic                     cr_reg_ie           ,   // interrupt enable
  output  logic[WDOG_CNT-1:0]       cfg_reg_window      ,   // feed dog window value
  output  logic[1:0]                cfg_reg_presc       ,   // prescaler value
  input   logic[WDOG_CNT-1:0]       sr_reg_timer        ,   // "current" timer value sync from wdog timer
  input   logic                     sr_reg_rstflag      ,   // reset flag W1C or cold rst can clear
  output  logic[7:0]                fd_reg_feed             // feed dog
);
// ----------------------------------------------------------------------------
// WDOG APB registers OFFSET
// ----------------------------------------------------------------------------
localparam  WDOG_CR_ADDR    = 32'h0000_0000;    // control reg
localparam  WDOG_CFG_ADDR   = 32'h0000_0004;    // config reg
localparam  WDOG_SR_ADDR    = 32'h0000_0008;    // status reg
localparam  WDOG_FD_ADDR    = 32'h0000_000C;    // feed reg

logic[31:0] cr_reg      ;
logic[31:0] cfg_reg     ;
logic[31:0] sr_reg      ;
logic[31:0] fd_reg      ;

logic       cr_reg_addressed  ;
logic       cfg_reg_addressed ;
logic       sr_reg_addressed  ;
logic       fd_reg_addressed  ;
logic       cr_reg_wr         ;
logic       cr_reg_rd         ;
logic       cfg_reg_wr        ;
logic       cfg_reg_rd        ;
logic       sr_reg_rd         ;
logic       fd_reg_wr         ;
logic       fd_reg_rd         ;

assign cr_reg_addressed = (apb_addr[ADDR_WD-1:2] == WDOG_CR_ADDR[ADDR_WD-1:2])  ;
assign cfg_reg_addressed= (apb_addr[ADDR_WD-1:2] == WDOG_CFG_ADDR[ADDR_WD-1:2]) ;
assign sr_reg_addressed = (apb_addr[ADDR_WD-1:2] == WDOG_SR_ADDR[ADDR_WD-1:2])  ;
assign fd_reg_addressed = (apb_addr[ADDR_WD-1:2] == WDOG_FD_ADDR[ADDR_WD-1:2])  ;

assign cr_reg_wr  = cr_reg_addressed  & apb_write_en  ;
assign cr_reg_rd  = cr_reg_addressed  & apb_read_en   ;
assign cfg_reg_wr = cfg_reg_addressed & apb_write_en  ;
assign cfg_reg_rd = cfg_reg_addressed & apb_read_en   ;
assign sr_reg_rd  = sr_reg_addressed  & apb_read_en   ;
assign fd_reg_wr  = fd_reg_addressed  & apb_write_en  ;
assign fd_reg_rd  = fd_reg_addressed  & apb_read_en   ;
//-----------------------------------------------------------------------------
// APB bus write
//-----------------------------------------------------------------------------
always_ff @(posedge pclk, negedge preset_n) begin
  if(~preset_n)
    cr_reg <= 32'b0;
  else if(cr_reg_wr)
    cr_reg <= {(32-WDOG_CNT-2){1'b0}, apb_wdata[WDOG_CNT+1],
                apb_wdata[WDOG_CNT], apb_wdata[WDOG_CNT-1:0]};
  // else keep
end

always_ff @(posedge pclk, negedge preset_n) begin
  if(~preset_n)
    cfg_reg <= 32'b0;
  else if(cfg_reg_wr)
    cfg_reg <= {(32-WDOG_CNT-2){1'b0}, apb_wdata[WDOG_CNT+:2], apb_wdata[WDOG_CNT-1:0]};
  // else keep
end
assign  cfg_reg_presc   = cfg_reg[WDOG_CNT+:2]  ;
assign  cfg_reg_window  = cfg_reg[WDOG_CNT-1:0] ;

always_ff @(posedge pclk, negedge preset_n) begin
  if(~preset_n)
    fd_reg <= 32'b0;
  else
    fd_reg <= {24'b0, apb_wdata[7:0]};
end
assign  fd_reg_feed = fd_reg[7:0];
//-----------------------------------------------------------------------------
// APB bus read
//-----------------------------------------------------------------------------

endmodule