module data_source(
	input				clk,
	input				rst_n,
	output [22:0]	local_address,
	output			local_read_req,
	output			local_write_req,
	output [63:0]	local_wdata,
	
	input  			local_ready,
	input  [63:0]	local_rdata,
	input 			local_rdata_valid,
	input				local_init_done
	
	);
	

//1s1s定时计数逻辑    时钟为75MHz(13.3333ns)  
reg [26:0] scnt;
reg [7:0]  times;

always  @(posedge clk or negedge rst_n)
		if(!rst_n) scnt <= 27'd0;
		else if (local_init_done) scnt <= scnt+1'b1;
		
wire timer_wrreq = (scnt == 27'h00_001_000);
wire timer_rdreq = (scnt == 27'h00_005_000);

always @(posedge clk or negedge rst_n)
		if(!rst_n) times <= 8'd0;
		else if(timer_rdreq) times <= times + 1'b1;
// 产生读写DDR操作的状态
parameter SIDLE = 4'd0;
parameter SWRDB = 4'd1;
parameter SRDDB = 4'd2;
parameter SSTOP = 4'd3;

reg [3:0] cstate;
reg [8:0] num;

always @(posedge clk or negedge rst_n)
		if(!rst_n) cstate <= SIDLE;
		else begin
			case(cstate)
				SIDLE: begin
					if(timer_wrreq) cstate <= SWRDB;
					else if(timer_rdreq) cstate <= SRDDB;
					else cstate <= SIDLE;
					end
				SWRDB: begin
					if((num == 9'd255) && local_ready) cstate <= SSTOP;
					else cstate <= SWRDB;
					end
				SRDDB: begin
					if((num == 9'd255) && local_ready) cstate <= SSTOP;
					else cstate <= SRDDB;
					end
				SSTOP: cstate <= SIDLE;
			default: cstate <= SIDLE;
			endcase
		end

//(1024/4) 256次的数据读写请求计数器

always @(posedge clk or negedge rst_n)
		if(!rst_n) num <= 9'd0;
		else if((cstate == SWRDB) || (cstate == SRDDB)) begin
					if(local_ready) num <= num+1'b1;
					else;
					end
				else num <= 9'd0;
assign local_address = (cstate == SWRDB) ? {13'h0a55,2'd1,num[7:0]}:{13'h0a55,2'd1,num[7:0]};
assign local_wdata = {times,{num[5:0],2'b00},times,{num[5:0],2'b01},times,{num[5:0],2'b10},times,{num[5:0],2'b11}};
assign local_write_req = (cstate == SWRDB);
assign local_read_req = (cstate == SRDDB);
			
//片内RAM例化，写入当前DDR读出的256*64bit数据
reg [7:0] ram_addr;

always @(posedge clk or negedge rst_n)
		if(!rst_n) ram_addr <= 8'd0;
	else if(timer_rdreq) ram_addr <= 8'd0;
	else if(local_rdata_valid) ram_addr <= ram_addr+1'b1;
	else ;
onchipram_for_ddr		onchipram_for_ddr_inst(
		.address(ram_addr),
		.clock(clk),
		.data(local_rdata),
		.wren ( local_rdata_valid ),
		.q()
		);
		
endmodule

		
		


					
		