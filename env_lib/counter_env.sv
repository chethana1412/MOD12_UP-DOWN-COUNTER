class counter_env;

//Declaring the virtual interface handles of write driver, write and read monitors
virtual c_if.WR_DRV_MP drv_if;
virtual c_if.WR_MON_MP wr_mon_if;
virtual c_if.RD_MON_MP rd_mon_if;

//Mailbox creation of all tb components(Method 2)
mailbox #(counter_trans) gen2drv=new();
mailbox #(counter_trans) wrmon2rm=new();
mailbox #(counter_trans) rdmon2sb=new();
mailbox #(counter_trans) rm2sb=new();

//Declaring the handles of all tb components to establish the connections bw them
counter_gen gen_h;
counter_drv drv_h;
counter_wr_mon wr_mon_h;
counter_rd_mon rd_mon_h;
counter_model ref_mod_h;
counter_sb sb_h;

function new(virtual c_if.WR_DRV_MP drv_if,
	     virtual c_if.WR_MON_MP wr_mon_if,
	     virtual c_if.RD_MON_MP rd_mon_if);
this.drv_if=drv_if;
this.wr_mon_if=wr_mon_if;
this.rd_mon_if=rd_mon_if;
endfunction:new

virtual task build();
gen_h=new(gen2drv);
drv_h=new(drv_if,gen2drv);
wr_mon_h=new(wr_mon_if,wrmon2rm);
rd_mon_h=new(rd_mon_if,rdmon2sb);
ref_mod_h=new(wrmon2rm,rm2sb);
sb_h=new(rm2sb,rdmon2sb);
endtask:build

virtual task reset_dut();
@(drv_if.drv_cb)
drv_if.drv_cb.reset <= 1'b1;
repeat(2)
@(drv_if.drv_cb)
drv_if.drv_cb.reset <= 1'b0;
endtask:reset_dut

virtual task start();
gen_h.start();
drv_h.start();
wr_mon_h.start();
rd_mon_h.start();
ref_mod_h.start();
sb_h.start();
endtask:start

virtual task stop();
$display("\nENVIRONMENT: waiting for DONE event");
@(sb_h.DONE.triggered);
$display("\nENVIRONMENT: DONE event triggered");
endtask:stop

virtual task run();
reset_dut();
start();
stop();
sb_h.report();
endtask:run

endclass:counter_env
