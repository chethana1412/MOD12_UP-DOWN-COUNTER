class counter_rd_mon;

virtual c_if.RD_MON_MP rd_mon_if; //Virtual interface instance for Read Monitor
counter_trans rd_data; //for object creation
counter_trans data2sb; //to perform shallow copy to send the sampled data to scoreboard
mailbox #(counter_trans) mon2sb; //mbx handle-read monitor to scoreboard

function new(virtual c_if.RD_MON_MP rd_mon_if,
	     mailbox #(counter_trans) mon2sb);
this.rd_mon_if=rd_mon_if;
this.mon2sb=mon2sb;
this.rd_data=new();
endfunction:new

virtual task monitor();
begin
@(rd_mon_if.rd_mon_cb);
begin
rd_data.count=rd_mon_if.rd_mon_cb.count;
rd_data.display("DATA FROM READ MONITOR");
end
end
endtask:monitor

virtual task start();
fork
	forever
		begin
			monitor();
			data2sb=new rd_data;
			mon2sb.put(data2sb);
		end
join_none
endtask:start

endclass:counter_rd_mon
