module sysControl(
		input		extClock,
		input 	ext_rst_n,
		
		output 	reg	sys_rst_n,
		output	clk25m,
		output	clk33m,
		output	clk50m,
		output	clk65m,
		output	clk100m
		);
		
reg rst_r1,rst_r2;

always @(posedge extClock or negedge ext_rst_n)
	if(!ext_rst_n)	rst_r1 <= 1'b0;
	else rst_r1 <= 1'b1;
	
always @(posedge extClock or negedge ext_rst_n)
	if (!ext_rst_n) rst_r2 <= 1'b0;
	else rst_r2 <= rst_r1;
	
//PLL模块例化	
wire locked;  //PLL 输出锁定状态，高电平有效
//IP核生成的例化参考文件
PLL_controll	PLL_controll_inst (
	.areset ( !rst_r2 ),
	.inclk0 ( extClock ),
	.c0 ( clk25m ),
	.c1 ( clk33m ),
	.c2 ( clk50m ),
	.c3 ( clk65m ),
	.c4 ( clk100m ),
	.locked ( locked )
	);
	
	//系统复位逻辑处理
reg sys_rst_nr;

always @(posedge clk100m)
	if(!locked) sys_rst_nr <= 1'b0;
	else sys_rst_nr <= 1'b1;
	
always @(posedge clk100m or negedge sys_rst_nr)
	if(!sys_rst_nr) sys_rst_n <= 1'b0;
	else sys_rst_n <= sys_rst_nr;
	
endmodule

	