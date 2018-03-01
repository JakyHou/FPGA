transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+E:/Git_FPGA/LEDBlinking {E:/Git_FPGA/LEDBlinking/PLL_controll.v}
vlog -vlog01compat -work work +incdir+E:/Git_FPGA/LEDBlinking {E:/Git_FPGA/LEDBlinking/LEDBlinking.v}
vlog -vlog01compat -work work +incdir+E:/Git_FPGA/LEDBlinking {E:/Git_FPGA/LEDBlinking/sysControl.v}
vlog -vlog01compat -work work +incdir+E:/Git_FPGA/LEDBlinking {E:/Git_FPGA/LEDBlinking/ledController.v}
vlog -vlog01compat -work work +incdir+E:/Git_FPGA/LEDBlinking/db {E:/Git_FPGA/LEDBlinking/db/pll_controll_altpll.v}

