package require ::quartus::project
set project_name tempproject
if [catch {project_open $project_name}] {
        project_new $project_name
}
export_assignments
set_global_assignment -name "VERILOG_FILE" "E:/Git_FPGA/DDR2/iptb_altmemphy_temp4731722069312669908/ddr2_controller_phy_alt_mem_phy_seq_wrapper.v";
set_global_assignment -name "VHDL_FILE" "E:/Git_FPGA/DDR2/iptb_altmemphy_temp4731722069312669908/ddr2_controller_phy_alt_mem_phy_seq.vhd";
set_global_assignment -name "VERILOG_FILE" "E:/Git_FPGA/DDR2/iptb_altmemphy_temp4731722069312669908/ddr2_controller_phy.v";
set_global_assignment -name "VERILOG_FILE" "E:/Git_FPGA/DDR2/iptb_altmemphy_temp4731722069312669908/ddr2_controller_phy_alt_mem_phy.v";
set_global_assignment -name "VERILOG_FILE" "E:/Git_FPGA/DDR2/iptb_altmemphy_temp4731722069312669908/ddr2_controller_phy_alt_mem_phy_pll.v";
set_global_assignment -name USER_LIBRARIES "F:/intelFPGA/17.0/ip/altera/ddr2_high_perf/lib"
set_global_assignment -name "DEVICE" "AUTO";
project_close
