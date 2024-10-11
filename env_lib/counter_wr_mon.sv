class counter_wr_mon;

virtual c_if.WR_MON_MP wr_mon_if; //Virtual Interface instance for Write Monitor
counter_trans wr_data; //For object creation
counter_trans data2rm; //to perform shallow copy
mailbox #(counter_trans) mon2rm; //mbx handle-write monitor to reference model

function new(virtual c_if.WR_MON_MP wr_mon_if,
	     mailbox #(counter_trans) mon2rm);
this.wr_mon_if=wr_mon_if;
this.mon2rm=mon2rm;
this.wr_data=new();
endfunction:new

virtual task monitor();
begin
@(wr_mon_if.wr_mon_cb)
begin
wr_data.reset=wr_mon_if.wr_mon_cb.reset;
wr_data.load=wr_mon_if.wr_mon_cb.load;
wr_data.mode=wr_mon_if.wr_mon_cb.mode;
wr_data.data_in=wr_mon_if.wr_mon_cb.data_in;
wr_data.display("DATA FROM WRITE MONITOR");
end
end
endtask:monitor

virtual task start();
fork
	forever
		begin
			monitor();
			data2rm=new wr_data;
			mon2rm.put(data2rm);
		end
join_none
endtask:start

endclass:counter_wr_mon
