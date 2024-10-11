module counter(clk,rst,load,mode,data_in,count);

//Declaration of input output ports
input clk,rst,load,mode;
input [3:0] data_in;
output reg [3:0] count;

//Counter logic
always @(posedge clk)
begin
    if(rst)
	count <= 4'd0;
    else if(load)
	count <= data_in;
    else if(mode)
    begin
	if(count == 4'd11)
	    count <= 4'd0;
	else
	    count <= count + 1'b1;
    end
    else
    begin
	if(count == 4'd0)
	    count <= 4'd11;
	else
	    count <= count - 1'b1;
    end
end

endmodule
