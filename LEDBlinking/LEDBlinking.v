module LEDBlinking(
		input 	extClock,
		input 	ext_rst_n,
		output 	led
);

wire	sys_rst_n;
wire	clk25m;
wire	clk33m;
wire	clk50m;
wire	clk65m;
wire	clk100m;

sysControl		u1SysCtrl(
		.extClock	(extClock),
		.ext_rst_n	(ext_rst_n),
		.sys_rst_n	(sys_rst_n),
		.clk25m		(clk25m),
		.clk33m		(clk33m),
		.clk50m		(clk50m),
		.clk65m		(clk65m),
		.clk100m		(clk100m)
		);

ledController		u2LedController(
		.clk		(clk25m),
		.rst_n	(sys_rst_n),
		.led		(led)		
		);
		
endmodule


		