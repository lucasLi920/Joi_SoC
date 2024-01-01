module wdog_timer #(
  parameter WDOG_CNT  = 16
) (
  input   logic               fclk            ,
  input   logic               sys_rst_n       ,
  input   logic               wdog_act        ,       // wdog activation
  input   logic               wdog_relaod     ,       // feed dog then reload
  output  logic[WDOG_CNT-1:0] wdog_timer_cnt
);

always_ff @(posedge fclk, negedge sys_rst_n) begin
  if(~sys_rst_n)
    wdog_timer_cnt <= {WDOG_CNT{1'b0}};
  else if()
end

endmodule