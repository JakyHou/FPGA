module DDR2_control(
	input	ext_clk,
	input	ext_rst_n,
	
	output led,
	
	output [1:0]	mem_ba, //The memery bank address bus.
	output [12:0]	mem_addr,//The memery row and colum address bus
	output [0:0]	mem_cke,//The memery clock enable
	output [0:0]	mem_cs_n,//The memery chip select signal.
	
	output 			mem_ras_n,//The memery row address strobe.
	output			mem_cas_n,//The memery column address strobe.
	
	output 			mem_we_n,//The memery chip write enable signal.
	
	output [1:0]	mem_dm,	//The optional memery data mask bus.
	output [0:0] 	mem_odt,//The memery on-die termination control signal.
	inout	 [0:0]	mem_clk,//The memery clock, positive edge clock. output is for memery device, and input path is fedback to ALTMEMPHY megafunction for VT tracking.
	inout  [0:0]	mem_clk_n,//The memery clock negative edge clock. output is for memery device, and input path is feback to ALTMEMPHY megafunction for VT tracking.
	inout  [15:0]	mem_dq,	//The memery bidirectional data bus.
	inout	 [1:0]	mem_dqs//The memery bidirectional data strobe bus.
	
	);
	
	//系统内部时钟和复位产生模块例化
	//PLL输出复位和时钟，用于FPGA内部系统
wire sys_rst_n;
wire clk_25m;
wire clk_33m;
wire clk_50m;
wire clk_65m;
wire clk_100m;

sys_ctrl 		u1_sys_ctrl(
		.ext_clk(ext_clk),
		.ext_rst_n(ext_rst_n),
		.sys_rst_n(sys_rst_n),
		.clk_25m(clk_25m),
		.clk_33m(clk_33m),
		.clk_50m(clk_50m),
		.clk_65m(clk_65m),
		.clk_100m(clk_100m)
	);

	//LED 闪烁逻辑例化
	
led_controller	u2_led_controller(
	.clk_25m(clk_25m),
	.rst_n(sys_rst_n),
	.led(led)
	);
//local DDR2 SDRAM interface
		//clock and reset signals for DDR2 SDRAM
wire		phy_clk;// The ALTMEMPHY megafunction half-rate clock provided to the user. All user inputs and outputs to the ALMEMPHY megafunction are synchronous to this clock in half-rate designs. However, this clock is not used in full-rate designs.
wire		reset_phy_clk_n;//A synchronous reset, that is de-asserted synchronously with respect to the associated phy_clock domain. Use this to reset any additional user logic on that clock domain.

//local interface signals for DDR2
wire	[22:0]	local_address;//The address corresponding to a write or read request.
wire				local_write_req;//The active-high signal specifying that a write command should be issued to the address on the ctrl_address signal.
wire 				local_read_req;//The active-high signal requesting a read command to the address on the ctrl_address bus.
wire 	[63:0]	local_wdata;//The write data from the user to the ALTMEMPHY megafunction.
wire 				local_ready;//The controller-ready signal which indicates that the currently asserted read or write request has been accepted. The address of the request is sampled when both the ready and request signals are high.
wire 	[63:0]	local_rdata;//When ctrl_usr_mode is high, this output passes through the read data from the controller to the local interface. Otherwise, it is tied low.
wire 				local_rdata_valid;//When ctrl_usr_mode is high, this output passesthough the read data valid signal(ctrl_rdata_valid) from the controller to the local interface. Otherwise, it is driven low.
wire 				local_init_done;//When ctl_usr_mode is high, this output passes though the controller's initialization done signal(ctl_init_done)from the controller to the local interfave. Otherwise, it is driven low.

//DDR2 controller and phy IP core
//工作于8*16Bits模式
ddr2_controller		u3_ddr2_controller_inst(
		.local_address(local_address),
		.local_write_req(local_write_req),
		.local_read_req(local_read_req),
		.local_burstbegin(local_read_req | local_write_req),
		.local_wdata(local_wdata),
		.local_be(8'hff),
		.local_size(3'd1),
		.global_reset_n(sys_rst_n),
		.pll_ref_clk(clk_100m),
		.soft_reset_n(1'b1),
		.local_ready(local_ready),
		.local_rdata(local_rdata),
		.local_rdata_valid(local_rdata_valid),
		.local_refresh_ack(),
		.local_init_done(local_init_done),
		.reset_phy_clk_n(reset_phy_clk_n),
		.mem_odt(mem_odt),
		.mem_cs_n(mem_cs_n),
		.mem_cke(mem_cke),
		.mem_addr(mem_addr),
		.mem_ba(mem_ba),
		.mem_ras_n(mem_ras_n),
		.mem_cas_n(mem_cas_n),
		.mem_we_n(mem_we_n),
		.mem_dm(mem_dm),
		.phy_clk(phy_clk),
		.aux_full_rate_clk(),
		.aux_half_rate_clk(),
		.reset_request_n(),
		.mem_clk(mem_clk),
		.mem_clk_n(mem_clk_n),
		.mem_dq(mem_dq),
		.mem_dqs(mem_dqs)
	);

	
	//产生数据源，用于测试DDR2的读写
data_source			u4_data_source(
		.clk(phy_clk),
		.rst_n(reset_phy_clk_n),//为什么用phy_clk 和 reset_phy_clk_n?
		.local_address(local_address),
		.local_write_req(local_write_req),
		.local_read_req(local_read_req),
		.local_wdata(local_wdata),
		.local_rdata(local_rdata),
		.local_ready(local_ready),
		.local_rdata_valid(local_rdata_valid),
		.local_init_done(local_init_done)
	);
	
endmodule
