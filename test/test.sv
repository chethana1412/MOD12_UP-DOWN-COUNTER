class test;

//Declaration of virtual interface handles
virtual c_if.WR_DRV_MP drv_if;
virtual c_if.WR_MON_MP wr_mon_if;
virtual c_if.RD_MON_MP rd_mon_if;

counter_env env_h; //Environment class handle to build and run the environment

function new(virtual c_if.WR_DRV_MP drv_if,
	     virtual c_if.WR_MON_MP wr_mon_if,
	     virtual c_if.RD_MON_MP rd_mon_if);
this.drv_if=drv_if;
this.wr_mon_if=wr_mon_if;
this.rd_mon_if=rd_mon_if;
env_h=new(drv_if,wr_mon_if,rd_mon_if);
endfunction:new

virtual task build();
env_h.build(); //Build the environment
endtask:build

virtual task run();
env_h.run(); //Run the environment
endtask:run

endclass:test
