class counter_model;

counter_trans wrmon_data; //trans handle-to get the data from write monitor
mailbox #(counter_trans) wrmon2rm; //mbx handle-write monitor to reference model
mailbox #(counter_trans) rm2sb; //mbx handle-Reference model to Scoreboard

logic [3:0] ref_count=0;

function new(mailbox #(counter_trans) wrmon2rm,
	     mailbox #(counter_trans) rm2sb);
this.wrmon2rm=wrmon2rm;
this.rm2sb=rm2sb;
endfunction:new

virtual task rm_counter(counter_trans refmod_data);
begin
	if(refmod_data.reset)
	ref_count <= 4'd0;

	else if(refmod_data.load)
	ref_count <= refmod_data.data_in;

	else if(refmod_data.load==0)
	begin
		if(refmod_data.mode==1)
		begin
			if(ref_count == 4'd11)
			ref_count <= 4'd0;
			else
			ref_count <= ref_count + 1'b1;
		end

		else if(refmod_data.mode==0)
		begin
			if(ref_count == 4'd0)
			ref_count <= 4'd11;
			else
			ref_count <= ref_count - 1'b1;
		end
	end
end
endtask:rm_counter

virtual task start();
	fork
		forever
			begin
				wrmon2rm.get(wrmon_data);
				rm_counter(wrmon_data);
				wrmon_data.count=ref_count;
				rm2sb.put(wrmon_data);
			end
	join_none
endtask:start

endclass:counter_model
