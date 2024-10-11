interface c_if(input bit clock);

logic reset;
logic mode;
logic load;
logic [3:0] data_in;
logic [3:0] count;

//Clocking block for Write Driver
clocking drv_cb@(posedge clock);
default input #1 output #1;
output reset;
output mode;
output load;
output data_in;
endclocking:drv_cb

//Clocking block for Write Monitor
clocking wr_mon_cb@(posedge clock);
default input #1 output #1;
input reset;
input load;
input mode;
input data_in;
endclocking:wr_mon_cb

//Clocking block for Read Monitor
clocking rd_mon_cb@(posedge clock);
default input #1 output #1;
input count;
endclocking:rd_mon_cb

//Modport for Write Driver
modport WR_DRV_MP(clocking drv_cb);

//Modport for Write Monitor
modport WR_MON_MP(clocking wr_mon_cb);

//Modport for Read Monitor
modport RD_MON_MP(clocking rd_mon_cb);

endinterface:c_if
