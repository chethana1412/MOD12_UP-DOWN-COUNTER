class counter_gen;

counter_trans gen_trans; //To create the object
counter_trans data2send; //To perform shallow copy

mailbox #(counter_trans) gen2drv; //Mbx handle-Generator to Driver

function new(mailbox #(counter_trans) gen2drv);
this.gen2drv=gen2drv;
this.gen_trans=new();
endfunction:new

virtual task start();
	fork
		for(int i=0;i<no_of_transactions;i++)
		begin
			assert(gen_trans.randomize());
			gen_trans.display("RANDOMIZED DATA");
			data2send=new gen_trans;
			gen2drv.put(data2send);
		end
	join_none
endtask:start

endclass:counter_gen
