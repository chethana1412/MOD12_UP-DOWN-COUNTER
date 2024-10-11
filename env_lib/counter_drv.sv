class counter_drv;

virtual c_if.WR_DRV_MP drv_if; //Virtual interface instance of write driver
counter_trans data2duv; //Transaction handle to send the data to DUV
mailbox #(counter_trans) gen2drv; //mbx handle-generator to driver

function new(virtual c_if.WR_DRV_MP drv_if,
	     mailbox #(counter_trans) gen2drv);
this.drv_if=drv_if;
this.gen2drv=gen2drv;
endfunction:new

virtual task drive();
begin
@(drv_if.drv_cb);
drv_if.drv_cb.reset <= data2duv.reset;
drv_if.drv_cb.load <= data2duv.load;
drv_if.drv_cb.mode <= data2duv.mode;
drv_if.drv_cb.data_in <= data2duv.data_in;
$display("\nDATA DRIVEN TO DUT FROM THE DRIVER");
end
endtask:drive

virtual task start();
fork
	forever
		begin
			gen2drv.get(data2duv);
			drive();
		end
join_none
endtask:start

endclass:counter_drv
