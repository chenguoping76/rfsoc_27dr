
################################################################
# This is a generated script based on design: rfsoc_qpsk
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2020.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source rfsoc_qpsk_script.tcl

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:smartconnect:1.0\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:axi_dma:7.1\
UoS:RFSoC:axi_qpsk_tx:5.3\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:axis_data_fifo:2.0\
xilinx.com:user:axis_signal_join:1.0\
xilinx.com:user:axis_signal_splitter:1.0\
xilinx.com:ip:fir_compiler:7.2\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: interpolate_logic
proc create_hier_cell_interpolate_logic { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_interpolate_logic() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS


  # Create pins
  create_bd_pin -dir I -type clk clk_128
  create_bd_pin -dir I -type clk clk_25_6
  create_bd_pin -dir I -type rst s_axis_aresetn

  # Create instance: axis_data_fifo_0, and set properties
  set axis_data_fifo_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_0 ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {16} \
   CONFIG.HAS_RD_DATA_COUNT {1} \
   CONFIG.HAS_WR_DATA_COUNT {1} \
   CONFIG.IS_ACLK_ASYNC {1} \
   CONFIG.SYNCHRONIZATION_STAGES {2} \
   CONFIG.TDATA_NUM_BYTES {2} \
 ] $axis_data_fifo_0

  # Create instance: axis_data_fifo_1, and set properties
  set axis_data_fifo_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_1 ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {16} \
   CONFIG.HAS_RD_DATA_COUNT {1} \
   CONFIG.HAS_WR_DATA_COUNT {1} \
   CONFIG.IS_ACLK_ASYNC {1} \
   CONFIG.SYNCHRONIZATION_STAGES {2} \
   CONFIG.TDATA_NUM_BYTES {2} \
 ] $axis_data_fifo_1

  # Create instance: axis_signal_join_0, and set properties
  set axis_signal_join_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:axis_signal_join:1.0 axis_signal_join_0 ]

  # Create instance: axis_signal_splitter_1, and set properties
  set axis_signal_splitter_1 [ create_bd_cell -type ip -vlnv xilinx.com:user:axis_signal_splitter:1.0 axis_signal_splitter_1 ]

  # Create instance: fir_compiler_0, and set properties
  set fir_compiler_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fir_compiler:7.2 fir_compiler_0 ]
  set_property -dict [ list \
   CONFIG.BestPrecision {true} \
   CONFIG.Clock_Frequency {128} \
   CONFIG.CoefficientVector {-0.022406403381708004,-0.04601348505451235,-0.04571148260226924,-0.00894199371574465,0.030576596828620555,0.026616656511643785,-0.01525599274205929,-0.03372569851901567,0.006989917525156605,0.05391609472090984,0.025731835161325215,-0.061194110212675575,-0.07627482901512517,0.0759512321930129,0.31171064206024807,0.426500837477317,0.31171064206024807,0.0759512321930129,-0.07627482901512517,-0.061194110212675575,0.025731835161325215,0.05391609472090984,0.006989917525156605,-0.03372569851901567,-0.01525599274205929,0.026616656511643785,0.030576596828620555,-0.00894199371574465,-0.04571148260226924,-0.04601348505451235,-0.022406403381708004} \
   CONFIG.Coefficient_Fractional_Bits {16} \
   CONFIG.Coefficient_Sets {1} \
   CONFIG.Coefficient_Sign {Signed} \
   CONFIG.Coefficient_Structure {Inferred} \
   CONFIG.Coefficient_Width {16} \
   CONFIG.ColumnConfig {4} \
   CONFIG.DATA_Has_TLAST {Not_Required} \
   CONFIG.Decimation_Rate {1} \
   CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
   CONFIG.Filter_Type {Interpolation} \
   CONFIG.Interpolation_Rate {5} \
   CONFIG.M_DATA_Has_TUSER {Not_Required} \
   CONFIG.Number_Channels {1} \
   CONFIG.Output_Rounding_Mode {Truncate_LSBs} \
   CONFIG.Output_Width {16} \
   CONFIG.Quantization {Quantize_Only} \
   CONFIG.RateSpecification {Frequency_Specification} \
   CONFIG.S_DATA_Has_FIFO {false} \
   CONFIG.S_DATA_Has_TUSER {Not_Required} \
   CONFIG.Sample_Frequency {25.6} \
   CONFIG.Select_Pattern {All} \
   CONFIG.Zero_Pack_Factor {1} \
 ] $fir_compiler_0

  # Create instance: fir_compiler_1, and set properties
  set fir_compiler_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fir_compiler:7.2 fir_compiler_1 ]
  set_property -dict [ list \
   CONFIG.BestPrecision {true} \
   CONFIG.Channel_Sequence {Basic} \
   CONFIG.Clock_Frequency {128} \
   CONFIG.CoefficientVector {-0.022406403381708004,-0.04601348505451235,-0.04571148260226924,-0.00894199371574465,0.030576596828620555,0.026616656511643785,-0.01525599274205929,-0.03372569851901567,0.006989917525156605,0.05391609472090984,0.025731835161325215,-0.061194110212675575,-0.07627482901512517,0.0759512321930129,0.31171064206024807,0.426500837477317,0.31171064206024807,0.0759512321930129,-0.07627482901512517,-0.061194110212675575,0.025731835161325215,0.05391609472090984,0.006989917525156605,-0.03372569851901567,-0.01525599274205929,0.026616656511643785,0.030576596828620555,-0.00894199371574465,-0.04571148260226924,-0.04601348505451235,-0.022406403381708004} \
   CONFIG.Coefficient_Fractional_Bits {16} \
   CONFIG.Coefficient_Sets {1} \
   CONFIG.Coefficient_Sign {Signed} \
   CONFIG.Coefficient_Structure {Inferred} \
   CONFIG.Coefficient_Width {16} \
   CONFIG.ColumnConfig {4} \
   CONFIG.DATA_Has_TLAST {Not_Required} \
   CONFIG.Decimation_Rate {1} \
   CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
   CONFIG.Filter_Type {Interpolation} \
   CONFIG.Interpolation_Rate {5} \
   CONFIG.M_DATA_Has_TUSER {Not_Required} \
   CONFIG.Number_Channels {1} \
   CONFIG.Number_Paths {1} \
   CONFIG.Output_Rounding_Mode {Truncate_LSBs} \
   CONFIG.Output_Width {16} \
   CONFIG.Quantization {Quantize_Only} \
   CONFIG.RateSpecification {Frequency_Specification} \
   CONFIG.S_DATA_Has_FIFO {false} \
   CONFIG.S_DATA_Has_TUSER {Not_Required} \
   CONFIG.Sample_Frequency {25.6} \
   CONFIG.Select_Pattern {All} \
   CONFIG.Zero_Pack_Factor {1} \
 ] $fir_compiler_1

  # Create interface connections
  connect_bd_intf_net -intf_net S_AXIS_1 [get_bd_intf_pins S_AXIS] [get_bd_intf_pins axis_signal_splitter_1/s_axis]
  connect_bd_intf_net -intf_net axis_data_fifo_0_M_AXIS [get_bd_intf_pins axis_data_fifo_0/M_AXIS] [get_bd_intf_pins fir_compiler_1/S_AXIS_DATA]
  connect_bd_intf_net -intf_net axis_data_fifo_1_M_AXIS [get_bd_intf_pins axis_data_fifo_1/M_AXIS] [get_bd_intf_pins fir_compiler_0/S_AXIS_DATA]
  connect_bd_intf_net -intf_net axis_signal_join_0_m_axis [get_bd_intf_pins M_AXIS] [get_bd_intf_pins axis_signal_join_0/m_axis]
  connect_bd_intf_net -intf_net axis_signal_splitter_1_m_axis_l [get_bd_intf_pins axis_data_fifo_0/S_AXIS] [get_bd_intf_pins axis_signal_splitter_1/m_axis_l]
  connect_bd_intf_net -intf_net axis_signal_splitter_1_m_axis_u [get_bd_intf_pins axis_data_fifo_1/S_AXIS] [get_bd_intf_pins axis_signal_splitter_1/m_axis_u]
  connect_bd_intf_net -intf_net fir_compiler_0_M_AXIS_DATA [get_bd_intf_pins axis_signal_join_0/s_axis_u] [get_bd_intf_pins fir_compiler_0/M_AXIS_DATA]
  connect_bd_intf_net -intf_net fir_compiler_1_M_AXIS_DATA [get_bd_intf_pins axis_signal_join_0/s_axis_l] [get_bd_intf_pins fir_compiler_1/M_AXIS_DATA]

  # Create port connections
  connect_bd_net -net clk_25_6_1 [get_bd_pins clk_25_6] [get_bd_pins axis_data_fifo_0/s_axis_aclk] [get_bd_pins axis_data_fifo_1/s_axis_aclk] [get_bd_pins axis_signal_splitter_1/clk]
  connect_bd_net -net m_axis_aclk_1 [get_bd_pins clk_128] [get_bd_pins axis_data_fifo_0/m_axis_aclk] [get_bd_pins axis_data_fifo_1/m_axis_aclk] [get_bd_pins axis_signal_join_0/clk] [get_bd_pins fir_compiler_0/aclk] [get_bd_pins fir_compiler_1/aclk]
  connect_bd_net -net s_axis_aresetn_1 [get_bd_pins s_axis_aresetn] [get_bd_pins axis_data_fifo_0/s_axis_aresetn] [get_bd_pins axis_data_fifo_1/s_axis_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: qpsk_tx
proc create_hier_cell_qpsk_tx { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_qpsk_tx() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M00_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M01_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M05_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI


  # Create pins
  create_bd_pin -dir I -type clk PL_clk_100
  create_bd_pin -dir O -type clk clk_out_128
  create_bd_pin -dir O -type clk clk_out_25_6
  create_bd_pin -dir I -type clk dac_clk_128
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn
  create_bd_pin -dir I -type rst pl_reset
  create_bd_pin -dir I -type rst ps_periph_reset
  create_bd_pin -dir I -type rst reset
  create_bd_pin -dir O -from 0 -to 0 -type rst reset_128
  create_bd_pin -dir O -from 2 -to 0 -type intr s2mm_introut

  # Create instance: axi_smc_1, and set properties
  set axi_smc_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 axi_smc_1 ]
  set_property -dict [ list \
   CONFIG.NUM_SI {3} \
 ] $axi_smc_1

  # Create instance: clk_tx, and set properties
  set clk_tx [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_tx ]
  set_property -dict [ list \
   CONFIG.CLKIN1_JITTER_PS {78.12} \
   CONFIG.CLKOUT1_DRIVES {Buffer} \
   CONFIG.CLKOUT1_JITTER {175.497} \
   CONFIG.CLKOUT1_PHASE_ERROR {110.529} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {25.6} \
   CONFIG.CLKOUT2_DRIVES {Buffer} \
   CONFIG.CLKOUT2_JITTER {175.497} \
   CONFIG.CLKOUT2_PHASE_ERROR {110.529} \
   CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {100.000} \
   CONFIG.CLKOUT2_USED {false} \
   CONFIG.CLKOUT3_DRIVES {Buffer} \
   CONFIG.CLKOUT4_DRIVES {Buffer} \
   CONFIG.CLKOUT5_DRIVES {Buffer} \
   CONFIG.CLKOUT6_DRIVES {Buffer} \
   CONFIG.CLKOUT7_DRIVES {Buffer} \
   CONFIG.CLK_OUT1_PORT {clk_25_6} \
   CONFIG.CLK_OUT2_PORT {clk_out2} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {6} \
   CONFIG.MMCM_CLKIN1_PERIOD {7.812} \
   CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {30} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {1} \
   CONFIG.MMCM_COMPENSATION {AUTO} \
   CONFIG.MMCM_DIVCLK_DIVIDE {1} \
   CONFIG.NUM_OUT_CLKS {1} \
   CONFIG.PLL_CLKIN_PERIOD {7.812} \
   CONFIG.PRIMITIVE {PLL} \
   CONFIG.PRIM_IN_FREQ {128} \
   CONFIG.RESET_BOARD_INTERFACE {reset} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $clk_tx

  # Create instance: dma_tx_fft, and set properties
  set dma_tx_fft [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_tx_fft ]
  set_property -dict [ list \
   CONFIG.c_include_mm2s {0} \
   CONFIG.c_include_s2mm {1} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axi_s2mm_data_width {128} \
   CONFIG.c_s2mm_burst_size {256} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_tx_fft

  # Create instance: dma_tx_symbol, and set properties
  set dma_tx_symbol [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_tx_symbol ]
  set_property -dict [ list \
   CONFIG.c_include_mm2s {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axi_s2mm_data_width {128} \
   CONFIG.c_s2mm_burst_size {256} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_tx_symbol

  # Create instance: dma_tx_time, and set properties
  set dma_tx_time [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_tx_time ]
  set_property -dict [ list \
   CONFIG.c_include_mm2s {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axi_s2mm_data_width {128} \
   CONFIG.c_s2mm_burst_size {256} \
 ] $dma_tx_time

  # Create instance: interpolate_logic
  create_hier_cell_interpolate_logic $hier_obj interpolate_logic

  # Create instance: ps8_0_axi_periph, and set properties
  set ps8_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 ps8_0_axi_periph ]
  set_property -dict [ list \
   CONFIG.NUM_MI {6} \
   CONFIG.NUM_SI {1} \
 ] $ps8_0_axi_periph

  # Create instance: qpsk_tx, and set properties
  set qpsk_tx [ create_bd_cell -type ip -vlnv UoS:RFSoC:axi_qpsk_tx:5.3 qpsk_tx ]

  # Create instance: reset_128, and set properties
  set reset_128 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 reset_128 ]

  # Create instance: reset_25_6, and set properties
  set reset_25_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 reset_25_6 ]

  # Create instance: reset_pl, and set properties
  set reset_pl [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 reset_pl ]

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {3} \
 ] $xlconcat_0

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins M01_AXI] [get_bd_intf_pins ps8_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net axi_dma_fft_M_AXI_S2MM [get_bd_intf_pins axi_smc_1/S00_AXI] [get_bd_intf_pins dma_tx_fft/M_AXI_S2MM]
  connect_bd_intf_net -intf_net axi_dma_symbol_M_AXI_S2MM [get_bd_intf_pins axi_smc_1/S01_AXI] [get_bd_intf_pins dma_tx_symbol/M_AXI_S2MM]
  connect_bd_intf_net -intf_net axi_dma_time_M_AXI_S2MM [get_bd_intf_pins axi_smc_1/S02_AXI] [get_bd_intf_pins dma_tx_time/M_AXI_S2MM]
  connect_bd_intf_net -intf_net axi_qpsk_tx_m_fft_axis [get_bd_intf_pins dma_tx_fft/S_AXIS_S2MM] [get_bd_intf_pins qpsk_tx/m_fft_axis]
  connect_bd_intf_net -intf_net axi_smc_1_M00_AXI [get_bd_intf_pins M00_AXI] [get_bd_intf_pins axi_smc_1/M00_AXI]
  connect_bd_intf_net -intf_net axis_combiner_0_M_AXIS [get_bd_intf_pins M_AXIS] [get_bd_intf_pins interpolate_logic/M_AXIS]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M00_AXI [get_bd_intf_pins dma_tx_time/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M02_AXI [get_bd_intf_pins dma_tx_fft/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph/M02_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M03_AXI [get_bd_intf_pins ps8_0_axi_periph/M03_AXI] [get_bd_intf_pins qpsk_tx/axi_qpsk_tx_s_axi]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M04_AXI [get_bd_intf_pins dma_tx_symbol/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph/M04_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M05_AXI [get_bd_intf_pins M05_AXI] [get_bd_intf_pins ps8_0_axi_periph/M05_AXI]
  connect_bd_intf_net -intf_net qpsk_tx_m_rf_axis [get_bd_intf_pins interpolate_logic/S_AXIS] [get_bd_intf_pins qpsk_tx/m_rf_axis]
  connect_bd_intf_net -intf_net qpsk_tx_m_symbol_axis [get_bd_intf_pins dma_tx_symbol/S_AXIS_S2MM] [get_bd_intf_pins qpsk_tx/m_symbol_axis]
  connect_bd_intf_net -intf_net qpsk_tx_m_time_axis [get_bd_intf_pins dma_tx_time/S_AXIS_S2MM] [get_bd_intf_pins qpsk_tx/m_time_axis]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_M_AXI_HPM0_LPD [get_bd_intf_pins S00_AXI] [get_bd_intf_pins ps8_0_axi_periph/S00_AXI]

  # Create port connections
  connect_bd_net -net axi_dma_fft_s2mm_introut_1 [get_bd_pins dma_tx_fft/s2mm_introut] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net axi_dma_symbol_s2mm_introut [get_bd_pins dma_tx_symbol/s2mm_introut] [get_bd_pins xlconcat_0/In2]
  connect_bd_net -net axi_dma_time_s2mm_introut [get_bd_pins dma_tx_time/s2mm_introut] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net clk_dac0_rst_interconnect_aresetn [get_bd_pins axi_smc_1/aresetn] [get_bd_pins interpolate_logic/s_axis_aresetn] [get_bd_pins reset_25_6/interconnect_aresetn]
  connect_bd_net -net clk_dac_1 [get_bd_pins clk_out_128] [get_bd_pins dac_clk_128] [get_bd_pins clk_tx/clk_in1] [get_bd_pins interpolate_logic/clk_128] [get_bd_pins reset_128/slowest_sync_clk]
  connect_bd_net -net clk_tx_locked [get_bd_pins clk_tx/locked] [get_bd_pins reset_25_6/dcm_locked]
  connect_bd_net -net dac0_bufg_BUFG_O [get_bd_pins clk_out_25_6] [get_bd_pins axi_smc_1/aclk] [get_bd_pins clk_tx/clk_25_6] [get_bd_pins dma_tx_fft/m_axi_s2mm_aclk] [get_bd_pins dma_tx_fft/s_axi_lite_aclk] [get_bd_pins dma_tx_symbol/m_axi_s2mm_aclk] [get_bd_pins dma_tx_symbol/s_axi_lite_aclk] [get_bd_pins dma_tx_time/m_axi_s2mm_aclk] [get_bd_pins dma_tx_time/s_axi_lite_aclk] [get_bd_pins interpolate_logic/clk_25_6] [get_bd_pins ps8_0_axi_periph/M00_ACLK] [get_bd_pins ps8_0_axi_periph/M02_ACLK] [get_bd_pins ps8_0_axi_periph/M03_ACLK] [get_bd_pins ps8_0_axi_periph/M04_ACLK] [get_bd_pins qpsk_tx/clk] [get_bd_pins reset_25_6/slowest_sync_clk]
  connect_bd_net -net reset_1 [get_bd_pins reset] [get_bd_pins clk_tx/reset]
  connect_bd_net -net reset_128_peripheral_aresetn [get_bd_pins reset_128] [get_bd_pins reset_128/peripheral_aresetn]
  connect_bd_net -net reset_pl_interconnect_aresetn [get_bd_pins ps8_0_axi_periph/ARESETN] [get_bd_pins reset_pl/interconnect_aresetn]
  connect_bd_net -net reset_pl_peripheral_aresetn [get_bd_pins ps8_0_axi_periph/S00_ARESETN] [get_bd_pins reset_pl/peripheral_aresetn]
  connect_bd_net -net rst_dac0_bufg_0M_peripheral_aresetn [get_bd_pins peripheral_aresetn] [get_bd_pins dma_tx_fft/axi_resetn] [get_bd_pins dma_tx_symbol/axi_resetn] [get_bd_pins dma_tx_time/axi_resetn] [get_bd_pins ps8_0_axi_periph/M00_ARESETN] [get_bd_pins ps8_0_axi_periph/M02_ARESETN] [get_bd_pins ps8_0_axi_periph/M03_ARESETN] [get_bd_pins ps8_0_axi_periph/M04_ARESETN] [get_bd_pins qpsk_tx/axi_qpsk_tx_aresetn] [get_bd_pins reset_25_6/peripheral_aresetn]
  connect_bd_net -net rst_ps8_0_99M_peripheral_aresetn [get_bd_pins ps_periph_reset] [get_bd_pins ps8_0_axi_periph/M01_ARESETN] [get_bd_pins ps8_0_axi_periph/M05_ARESETN]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins s2mm_introut] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk0 [get_bd_pins PL_clk_100] [get_bd_pins ps8_0_axi_periph/ACLK] [get_bd_pins ps8_0_axi_periph/M01_ACLK] [get_bd_pins ps8_0_axi_periph/M05_ACLK] [get_bd_pins ps8_0_axi_periph/S00_ACLK] [get_bd_pins reset_pl/slowest_sync_clk]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_resetn0 [get_bd_pins pl_reset] [get_bd_pins reset_128/ext_reset_in] [get_bd_pins reset_25_6/ext_reset_in] [get_bd_pins reset_pl/ext_reset_in]

  # Restore current instance
  current_bd_instance $oldCurInst
}


proc available_tcl_procs { } {
   puts "##################################################################"
   puts "# Available Tcl procedures to recreate hierarchical blocks:"
   puts "#"
   puts "#    create_hier_cell_qpsk_tx parentCell nameHier"
   puts "#    create_hier_cell_interpolate_logic parentCell nameHier"
   puts "#"
   puts "##################################################################"
}

available_tcl_procs
