 //================================================================================================
 // Engineer        : lucas li (bin)
 // E-mail          : libin.lucas@foxmail.com
 // Date            : 2023-12-30
 // Project         : Joi_SoC
 // Description     : 
 // Parameter       :
 //     
 //================================================================================================
 module uart_regs_interface #(
  parameter   ADDR_WD  = 12
 )(
  input   logic                 pclk          ,
  input   logic                 preset_n      ,
  input   logic                 psel          ,
  input   logic[ADDR_WD-1:0]    paddr         ,
  input   logic                 penable       ,
  input   logic                 pwrite        ,
  input   logic[31:0]           pwdata        ,
  output  logic[31:0]           prdata        ,

  input   logic[31:0]           apb_rdata     ,             // apb 2 internal interface
  output  logic[ADDR_WD-1:0]    apb_addr      ,
  output  logic                 apb_read_en   ,
  output  logic                 apb_write_en  ,
  output  logic[31:0]           apb_wdata
 );

  assign  apb_addr      = paddr;
  assign  apb_read_en   = psel & (~pwrite);
  assign  apb_write_en  = psel & (~penable) & pwrite;
  assign  apb_wdata     = pwdata;
  assign  rdata         = apb_rdata;

endmodule

