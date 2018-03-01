module	sys_ctrl(
	input	ext_clk,
	input ext_rst_n,
	
	output reg sys_rst_n,
	output clk_25m,
	output clk_33m,
	output clk_50m,
	output clk_65m,
	output clk_100m
	);
	
reg rst_r1,rst_r2;

always @(posedge ext_clk or negedge ext_rst_n)
		if(!ext_rst_n) rst_r1 <= 1'b0;
		else rst_r1 <= 1'b1;
		
always @(posedge ext_clk or negedge ext_rst_n)
		if(!ext_rst_n) rst_r2 <= 1'b0;
		else rst_r2 <= rst_r1;
		
wire locked;

pll_control	pll_control_inst (
	.areset ( !rst_r2 ),
	.inclk0 ( ext_clk ),
	.c0 ( clk_25m ),
	.c1 ( clk_33m ),
	.c2 ( clk_50m ),
	.c3 ( clk_65m ),
	.c4 ( clk_100m ),
	.locked ( locked )
	);

reg sys_rst_nr;

always @(posedge clk_100m)
	if(!locked) sys_rst_nr <= 1'b0;
	else sys_rst_nr <= 1'b1;

always @(posedge clk_100m or negedge sys_rst_nr)
	if(!sys_rst_nr) sys_rst_n <= 1'b0;
	else sys_rst_n <= sys_rst_nr;
	
endmodule
