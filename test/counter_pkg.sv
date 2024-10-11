package counter_pkg;

int no_of_transactions=1;

`include "counter_trans.sv"
`include "counter_gen.sv"
`include "counter_drv.sv"
`include "counter_wr_mon.sv"
`include "counter_rd_mon.sv"
`include "counter_model.sv"
`include "counter_sb.sv"
`include "counter_env.sv"
`include "test.sv"

endpackage:counter_pkg
