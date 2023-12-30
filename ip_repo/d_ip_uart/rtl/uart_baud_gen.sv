//================================================================================================
// Engineer        : lucas li (bin)
// E-mail          : libin.lucas@foxmail.com
// Date            : 2023-12-30
// Description     : uart tx/rx baud rate generation logic
//================================================================================================
module uart_baud_gen
(
  input   logic         clk             ,   // clock
  input   logic         rst_n           ,   // reset
  input   logic         baud_req        ,   // UART enable TX/RX
  input   logic[11:0]   br_reg_mantissa ,   // baud rate generation div
  input   logic[3:0]    br_reg_fraction ,   // baud rate generation div
  output  logic         baud_sample         // output sample pulse for baud rate
);

// fraction part is bit-value * (2^4)
// ----------------------------------------------------------------------------
// baud_rate = fclk/(16*div)
// for example: mantissa = 27 fraciton=12/16=0.75  i.e. br_reg = 0x1BC
// then div is 27.75
// or you want div=25.62, then fraction=0.62*16=9.92->10=0x0A
// ----------------------------------------------------------------------------
logic[11:0] mant_cnt;
logic[3:0]  frac_cnt;
logic       mant_done;
logic       frac_done;
always_ff @(posedge clk, negedge rst_n) begin
  if(!rst_n)
    mant_cnt <= 12'b0;
  else if(baud_req) begin
    if(frac_done)
      mant_cnt <= 12'b0;
    else if(mant_done)
      mant_cnt <= mant_cnt;
    else
      mant_cnt <= mant_cnt + 1'b1
  end
end
assign mant_done = (mant_cnt == br_reg_mantissa);

always_ff @(posedge clk, negedge rst_n) begin
  if(!rst_n)
    frac_cnt <= 4'b0;
  else if(baud_req) begin
    if(mant_done || frac_cnt == br_reg_fraction)
      frac_cnt <= 4'b0;
    else
      frac_cnt <= frac_cnt + 1'b1;
  end
end

always_ff @(posedge clk, negedge rst_n) begin
  if(!rst_n)
    baud_sample <= 1'b0;
  else if(mant_done & frac_done)
    baud_sample <= 1'b1;
end

endmodule