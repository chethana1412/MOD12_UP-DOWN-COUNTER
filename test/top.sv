module top();

import counter_pkg::*;

parameter cycle=10;
reg clock;

//Instantiation of the interface
c_if DUV_IF(clock);

//Declaration of an handle for the test class
test test_h;

//Instantion of DUV
counter DUV(.clk(clock),.rst(DUV_IF.reset),.load(DUV_IF.load),
	   .mode(DUV_IF.mode),.data_in(DUV_IF.data_in),
	   .count(DUV_IF.count));

//Generating the clock signal
initial
begin
	clock=1'b0;
	forever #(cycle/2) clock=~clock;
end

//Create the instance for test class and pass the static interface instance as the arguments
initial
begin

test_h=new(DUV_IF,DUV_IF,DUV_IF);
no_of_transactions=500;

//Call the tasks build and run from test class
test_h.build();
test_h.run();
$finish;

end

endmodule:top
