class counter_trans;

rand bit reset;
rand bit load;
rand bit mode;
rand logic [3:0] data_in;

logic [3:0] count;

constraint valid_reset{reset dist{0:=10,1:=1};}
constraint valid_load{load dist{0:=4,1:=1};}
constraint valid_mode{mode dist{0:=10,1:=10};}
constraint valid_data{data_in inside{[1:11]};}

virtual function void display(input string s);
begin
$display("\n=========================%s=========================",s);
$display("\tReset=%0d",reset);
$display("\tLoad=%0d",load);
$display("\tMode=%0d",mode);
$display("\tData=%0d",data_in);
$display("\tCount=%0d",count);
end
$display("========================================================================\n");
endfunction:display


endclass:counter_trans
