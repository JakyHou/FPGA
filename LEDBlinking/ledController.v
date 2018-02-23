module ledController(
	input		clk,
	input		rst_n,
	
	output 	led
	);
	
//计数产生LED闪烁频率
reg[23:0] cnt;

always @(posedge clk or negedge rst_n)
	if(!rst_n)	cnt <= 24'b0;
	else	cnt <= cnt+1'b1;
	
assign led = cnt[23];

endmodule 