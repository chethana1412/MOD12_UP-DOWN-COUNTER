class counter_sb;

event DONE; //triggers the event to stop the simulation once all data is verified form SB

counter_trans cov_data; //to perform shallow copy for coverage
counter_trans rm_data; //to get the data from the reference model
counter_trans mon_data; //to get the data from the read monitor
mailbox #(counter_trans) rm2sb; //mbx handle-reference model to scoreboard
mailbox #(counter_trans) mon2sb; //mbx handle-read monitor to scoreboard

int data_verified=0; //count of total data verified
int rm_data_count=0; //count of data received from reference model
int mon_data_count=0; //count of data received frm read monitor

covergroup counter_coverage;
RST: coverpoint cov_data.reset{
	bins r0={0};
	bins r1={1};}
LOAD: coverpoint cov_data.load{
	bins l0={0};
	bins l1={1};}
MODE: coverpoint cov_data.mode{
	bins m0={0};
	bins m1={1};}
COUNT: coverpoint cov_data.count{
	bins c0={[0:5]};
	bins c1={[6:11]};}
RSTXLOADXMODE: cross RST,LOAD,MODE;
LOADXMODEXCOUNT: cross LOAD,MODE,COUNT;
endgroup:counter_coverage

function new(mailbox #(counter_trans) rm2sb,
	     mailbox #(counter_trans) mon2sb);
this.rm2sb=rm2sb;
this.mon2sb=mon2sb;
counter_coverage=new();
endfunction:new

virtual task start();
fork
	while(1)
	begin
		rm2sb.get(rm_data);
		rm_data_count++;
		mon2sb.get(mon_data);
		mon_data_count++;
		
		check(mon_data);
	end
join_none
endtask:start

virtual task check(counter_trans rdmon_data);
begin
	if(rm_data.count == rdmon_data.count)
	$display("\nCount value from Reference model and Read monitor is matched");
	else
	$display("Count value from Reference model and Read monitor is mismatched");
end
cov_data=new rm_data;
counter_coverage.sample();
data_verified++;

if(data_verified >= no_of_transactions)
->DONE;

endtask:check

function void report();
$display("\n=====================SCOREBOARD REPORT=====================\n");
$display("\tData generated from Reference Model = %0d",rm_data_count);
$display("\tData generated from Read Monitor = %0d",mon_data_count);
$display("\tData verified from Scoreboard = %0d",data_verified);
$display("\n===========================================================\n");
endfunction:report

endclass:counter_sb
