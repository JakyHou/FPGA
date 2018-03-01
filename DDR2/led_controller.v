module led_controller(
	input 	clk_25m,
	input 	rst_n,
	output 	led
	);
	
reg[23:0] cnt;

always @(posedge clk_25m or negedge rst_n)
		if(!rst_n) cnt <= 24'd0;
		else cnt <= cnt + 1'b1;
		
assign led = cnt[23];

endmodule
