
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
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:axi_dma:7.1\
UoS:SysGen:axi_qpsk_rx_csync:1.1\
UoS:SysGen:axi_qpsk_rx_dec:1.1\
UoS:SysGen:axi_qpsk_rx_rrc:1.1\
UoS:SysGen:axi_qpsk_rx_tsync:1.1\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:smartconnect:1.0\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:axis_data_fifo:2.0\
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


# Hierarchical cell: decimate_logic
proc create_hier_cell_decimate_logic { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_decimate_logic() - Empty argument(s)!"}
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

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_DATA

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_DATA1


  # Create pins
  create_bd_pin -dir I -type clk clk_128
  create_bd_pin -dir I -type clk clk_25_6
  create_bd_pin -dir I -type rst reset_128

  # Create instance: axis_data_fifo_0, and set properties
  set axis_data_fifo_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_0 ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {1024} \
   CONFIG.HAS_RD_DATA_COUNT {1} \
   CONFIG.HAS_WR_DATA_COUNT {1} \
   CONFIG.IS_ACLK_ASYNC {1} \
   CONFIG.SYNCHRONIZATION_STAGES {2} \
   CONFIG.TDATA_NUM_BYTES {2} \
 ] $axis_data_fifo_0

  # Create instance: axis_data_fifo_1, and set properties
  set axis_data_fifo_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_1 ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {1024} \
   CONFIG.HAS_RD_DATA_COUNT {1} \
   CONFIG.HAS_WR_DATA_COUNT {1} \
   CONFIG.IS_ACLK_ASYNC {1} \
   CONFIG.SYNCHRONIZATION_STAGES {2} \
   CONFIG.TDATA_NUM_BYTES {2} \
 ] $axis_data_fifo_1

  # Create instance: fir_compiler_0, and set properties
  set fir_compiler_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fir_compiler:7.2 fir_compiler_0 ]
  set_property -dict [ list \
   CONFIG.BestPrecision {true} \
   CONFIG.Clock_Frequency {128} \
   CONFIG.CoefficientVector {0.000000000000000,0.000334572125978,0.000544017123724,0.000522441431073,0.000240278267880,-0.000223779650047,-0.000685041173635,-0.000907841223530,-0.000709286416705,-0.000073807958764,0.000784067110132,0.001464985642156,0.001549220097694,0.000823458902944,-0.000541928350420,-0.001981104094791,-0.002738848576995,-0.002235766176576,-0.000428470470073,0.002036616111696,0.004009353651230,0.004337629320872,0.002482009521849,-0.001064117021164,-0.004814975617696,-0.006866276702417,-0.005805770430360,-0.001547801659521,0.004358928855801,0.009210184803343,0.010311512524452,0.006359034341166,-0.001628754335595,-0.010381454784459,-0.015594720754498,-0.013893872246607,-0.004704947021658,0.008900610930255,0.020980773482568,0.025035778148769,0.017043212478671,-0.002058969751056,-0.025653057844456,-0.043081361482323,-0.043287941093966,-0.019203945040852,0.028832362915462,0.092097819935811,0.155559990649596,0.202442440345737,0.219705082318609,0.202442440345737,0.155559990649596,0.092097819935811,0.028832362915462,-0.019203945040852,-0.043287941093966,-0.043081361482323,-0.025653057844456,-0.002058969751056,0.017043212478671,0.025035778148769,0.020980773482568,0.008900610930255,-0.004704947021658,-0.013893872246607,-0.015594720754498,-0.010381454784459,-0.001628754335595,0.006359034341166,0.010311512524452,0.009210184803343,0.004358928855801,-0.001547801659521,-0.005805770430360,-0.006866276702417,-0.004814975617696,-0.001064117021164,0.002482009521849,0.004337629320872,0.004009353651230,0.002036616111696,-0.000428470470073,-0.002235766176576,-0.002738848576995,-0.001981104094791,-0.000541928350420,0.000823458902944,0.001549220097694,0.001464985642156,0.000784067110132,-0.000073807958764,-0.000709286416705,-0.000907841223530,-0.000685041173635,-0.000223779650047,0.000240278267880,0.000522441431073,0.000544017123724,0.000334572125978,0.000000000000000} \
   CONFIG.Coefficient_Fractional_Bits {17} \
   CONFIG.Coefficient_Sets {1} \
   CONFIG.Coefficient_Sign {Signed} \
   CONFIG.Coefficient_Structure {Inferred} \
   CONFIG.Coefficient_Width {16} \
   CONFIG.ColumnConfig {11} \
   CONFIG.Decimation_Rate {5} \
   CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
   CONFIG.Filter_Type {Decimation} \
   CONFIG.Interpolation_Rate {1} \
   CONFIG.Number_Channels {1} \
   CONFIG.Output_Rounding_Mode {Truncate_LSBs} \
   CONFIG.Output_Width {16} \
   CONFIG.Quantization {Quantize_Only} \
   CONFIG.RateSpecification {Frequency_Specification} \
   CONFIG.S_DATA_Has_FIFO {false} \
   CONFIG.Sample_Frequency {128} \
   CONFIG.Zero_Pack_Factor {1} \
 ] $fir_compiler_0

  # Create instance: fir_compiler_1, and set properties
  set fir_compiler_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fir_compiler:7.2 fir_compiler_1 ]
  set_property -dict [ list \
   CONFIG.BestPrecision {true} \
   CONFIG.Clock_Frequency {128} \
   CONFIG.CoefficientVector {0.000000000000000,0.000334572125978,0.000544017123724,0.000522441431073,0.000240278267880,-0.000223779650047,-0.000685041173635,-0.000907841223530,-0.000709286416705,-0.000073807958764,0.000784067110132,0.001464985642156,0.001549220097694,0.000823458902944,-0.000541928350420,-0.001981104094791,-0.002738848576995,-0.002235766176576,-0.000428470470073,0.002036616111696,0.004009353651230,0.004337629320872,0.002482009521849,-0.001064117021164,-0.004814975617696,-0.006866276702417,-0.005805770430360,-0.001547801659521,0.004358928855801,0.009210184803343,0.010311512524452,0.006359034341166,-0.001628754335595,-0.010381454784459,-0.015594720754498,-0.013893872246607,-0.004704947021658,0.008900610930255,0.020980773482568,0.025035778148769,0.017043212478671,-0.002058969751056,-0.025653057844456,-0.043081361482323,-0.043287941093966,-0.019203945040852,0.028832362915462,0.092097819935811,0.155559990649596,0.202442440345737,0.219705082318609,0.202442440345737,0.155559990649596,0.092097819935811,0.028832362915462,-0.019203945040852,-0.043287941093966,-0.043081361482323,-0.025653057844456,-0.002058969751056,0.017043212478671,0.025035778148769,0.020980773482568,0.008900610930255,-0.004704947021658,-0.013893872246607,-0.015594720754498,-0.010381454784459,-0.001628754335595,0.006359034341166,0.010311512524452,0.009210184803343,0.004358928855801,-0.001547801659521,-0.005805770430360,-0.006866276702417,-0.004814975617696,-0.001064117021164,0.002482009521849,0.004337629320872,0.004009353651230,0.002036616111696,-0.000428470470073,-0.002235766176576,-0.002738848576995,-0.001981104094791,-0.000541928350420,0.000823458902944,0.001549220097694,0.001464985642156,0.000784067110132,-0.000073807958764,-0.000709286416705,-0.000907841223530,-0.000685041173635,-0.000223779650047,0.000240278267880,0.000522441431073,0.000544017123724,0.000334572125978,0.000000000000000} \
   CONFIG.Coefficient_Fractional_Bits {17} \
   CONFIG.Coefficient_Sets {1} \
   CONFIG.Coefficient_Sign {Signed} \
   CONFIG.Coefficient_Structure {Inferred} \
   CONFIG.Coefficient_Width {16} \
   CONFIG.ColumnConfig {11} \
   CONFIG.Decimation_Rate {5} \
   CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
   CONFIG.Filter_Type {Decimation} \
   CONFIG.Interpolation_Rate {1} \
   CONFIG.Number_Channels {1} \
   CONFIG.Output_Rounding_Mode {Truncate_LSBs} \
   CONFIG.Output_Width {16} \
   CONFIG.Quantization {Quantize_Only} \
   CONFIG.RateSpecification {Frequency_Specification} \
   CONFIG.S_DATA_Has_FIFO {false} \
   CONFIG.Sample_Frequency {128} \
   CONFIG.Zero_Pack_Factor {1} \
 ] $fir_compiler_1

  # Create interface connections
  connect_bd_intf_net -intf_net axis_data_fifo_0_M_AXIS [get_bd_intf_pins M_AXIS1] [get_bd_intf_pins axis_data_fifo_0/M_AXIS]
  connect_bd_intf_net -intf_net axis_data_fifo_1_M_AXIS [get_bd_intf_pins M_AXIS] [get_bd_intf_pins axis_data_fifo_1/M_AXIS]
  connect_bd_intf_net -intf_net fir_compiler_0_M_AXIS_DATA [get_bd_intf_pins axis_data_fifo_0/S_AXIS] [get_bd_intf_pins fir_compiler_0/M_AXIS_DATA]
  connect_bd_intf_net -intf_net fir_compiler_1_M_AXIS_DATA [get_bd_intf_pins axis_data_fifo_1/S_AXIS] [get_bd_intf_pins fir_compiler_1/M_AXIS_DATA]
  connect_bd_intf_net -intf_net s_i_axis_1 [get_bd_intf_pins S_AXIS_DATA] [get_bd_intf_pins fir_compiler_0/S_AXIS_DATA]
  connect_bd_intf_net -intf_net s_q_axis_1 [get_bd_intf_pins S_AXIS_DATA1] [get_bd_intf_pins fir_compiler_1/S_AXIS_DATA]

  # Create port connections
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins clk_128] [get_bd_pins axis_data_fifo_0/s_axis_aclk] [get_bd_pins axis_data_fifo_1/s_axis_aclk] [get_bd_pins fir_compiler_0/aclk] [get_bd_pins fir_compiler_1/aclk]
  connect_bd_net -net clk_wiz_1_clk_out1 [get_bd_pins clk_25_6] [get_bd_pins axis_data_fifo_0/m_axis_aclk] [get_bd_pins axis_data_fifo_1/m_axis_aclk]
  connect_bd_net -net reset_128_peripheral_aresetn [get_bd_pins reset_128] [get_bd_pins axis_data_fifo_0/s_axis_aresetn] [get_bd_pins axis_data_fifo_1/s_axis_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: qpsk_rx
proc create_hier_cell_qpsk_rx { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_qpsk_rx() - Empty argument(s)!"}
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

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_i_axis

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_q_axis


  # Create pins
  create_bd_pin -dir I -type clk adc_clk_64
  create_bd_pin -dir O -type clk clk_128
  create_bd_pin -dir O -type clk clk_25_6
  create_bd_pin -dir I -type clk pl_clk_100
  create_bd_pin -dir I -type rst pl_reset
  create_bd_pin -dir I -type rst reset
  create_bd_pin -dir O -from 0 -to 0 -type rst reset_128
  create_bd_pin -dir O -from 3 -to 0 -type intr s2mm_introut

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {8} \
 ] $axi_interconnect_0

  # Create instance: clk_rx, and set properties
  set clk_rx [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_rx ]
  set_property -dict [ list \
   CONFIG.CLKIN1_JITTER_PS {156.25} \
   CONFIG.CLKOUT1_JITTER {125.232} \
   CONFIG.CLKOUT1_PHASE_ERROR {126.718} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {128.0} \
   CONFIG.CLKOUT2_JITTER {183.627} \
   CONFIG.CLKOUT2_PHASE_ERROR {126.718} \
   CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {25.60} \
   CONFIG.CLKOUT2_USED {true} \
   CONFIG.CLK_OUT1_PORT {clk_128} \
   CONFIG.CLK_OUT2_PORT {clk_25_6} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {18.000} \
   CONFIG.MMCM_CLKIN1_PERIOD {15.625} \
   CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {9.000} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {45} \
   CONFIG.MMCM_DIVCLK_DIVIDE {1} \
   CONFIG.NUM_OUT_CLKS {2} \
   CONFIG.PRIM_IN_FREQ {64} \
   CONFIG.RESET_BOARD_INTERFACE {reset} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $clk_rx

  # Create instance: decimate_logic
  create_hier_cell_decimate_logic $hier_obj decimate_logic

  # Create instance: dma_rx_csync, and set properties
  set dma_rx_csync [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_rx_csync ]
  set_property -dict [ list \
   CONFIG.c_include_mm2s {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axi_s2mm_data_width {128} \
   CONFIG.c_s2mm_burst_size {128} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_rx_csync

  # Create instance: dma_rx_dec, and set properties
  set dma_rx_dec [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_rx_dec ]
  set_property -dict [ list \
   CONFIG.c_include_mm2s {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axi_s2mm_data_width {128} \
   CONFIG.c_s2mm_burst_size {128} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_rx_dec

  # Create instance: dma_rx_rrc, and set properties
  set dma_rx_rrc [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_rx_rrc ]
  set_property -dict [ list \
   CONFIG.c_include_mm2s {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axi_s2mm_data_width {128} \
   CONFIG.c_s2mm_burst_size {128} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_rx_rrc

  # Create instance: dma_rx_tsync, and set properties
  set dma_rx_tsync [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_rx_tsync ]
  set_property -dict [ list \
   CONFIG.c_include_mm2s {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axi_s2mm_data_width {128} \
   CONFIG.c_s2mm_burst_size {128} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_rx_tsync

  # Create instance: qpsk_rx_csync, and set properties
  set qpsk_rx_csync [ create_bd_cell -type ip -vlnv UoS:SysGen:axi_qpsk_rx_csync:1.1 qpsk_rx_csync ]

  # Create instance: qpsk_rx_dec, and set properties
  set qpsk_rx_dec [ create_bd_cell -type ip -vlnv UoS:SysGen:axi_qpsk_rx_dec:1.1 qpsk_rx_dec ]

  # Create instance: qpsk_rx_rrc, and set properties
  set qpsk_rx_rrc [ create_bd_cell -type ip -vlnv UoS:SysGen:axi_qpsk_rx_rrc:1.1 qpsk_rx_rrc ]

  # Create instance: qpsk_rx_tsync, and set properties
  set qpsk_rx_tsync [ create_bd_cell -type ip -vlnv UoS:SysGen:axi_qpsk_rx_tsync:1.1 qpsk_rx_tsync ]

  # Create instance: reset_128, and set properties
  set reset_128 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 reset_128 ]

  # Create instance: reset_256, and set properties
  set reset_256 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 reset_256 ]

  # Create instance: reset_pl, and set properties
  set reset_pl [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 reset_pl ]

  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_CLKS {2} \
   CONFIG.NUM_SI {4} \
 ] $smartconnect_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {4} \
 ] $xlconcat_0

  # Create interface connections
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins axi_interconnect_0/M00_AXI] [get_bd_intf_pins qpsk_rx_dec/axi_qpsk_rx_dec_s_axi]
  connect_bd_intf_net -intf_net axi_interconnect_0_M01_AXI [get_bd_intf_pins axi_interconnect_0/M01_AXI] [get_bd_intf_pins qpsk_rx_csync/axi_qpsk_rx_csync_s_axi]
  connect_bd_intf_net -intf_net axi_interconnect_0_M02_AXI [get_bd_intf_pins axi_interconnect_0/M02_AXI] [get_bd_intf_pins qpsk_rx_rrc/axi_qpsk_rx_rrc_s_axi]
  connect_bd_intf_net -intf_net axi_interconnect_0_M03_AXI [get_bd_intf_pins axi_interconnect_0/M03_AXI] [get_bd_intf_pins qpsk_rx_tsync/axi_qpsk_rx_tsync_s_axi]
  connect_bd_intf_net -intf_net axi_interconnect_0_M04_AXI [get_bd_intf_pins axi_interconnect_0/M04_AXI] [get_bd_intf_pins dma_rx_dec/S_AXI_LITE]
  connect_bd_intf_net -intf_net axi_interconnect_0_M05_AXI [get_bd_intf_pins axi_interconnect_0/M05_AXI] [get_bd_intf_pins dma_rx_csync/S_AXI_LITE]
  connect_bd_intf_net -intf_net axi_interconnect_0_M06_AXI [get_bd_intf_pins axi_interconnect_0/M06_AXI] [get_bd_intf_pins dma_rx_rrc/S_AXI_LITE]
  connect_bd_intf_net -intf_net axi_interconnect_0_M07_AXI [get_bd_intf_pins axi_interconnect_0/M07_AXI] [get_bd_intf_pins dma_rx_tsync/S_AXI_LITE]
  connect_bd_intf_net -intf_net axi_qpsk_rx_csync_m_axis [get_bd_intf_pins qpsk_rx_csync/m_axis] [get_bd_intf_pins qpsk_rx_rrc/s_axis]
  connect_bd_intf_net -intf_net axi_qpsk_rx_csync_m_axis_tap [get_bd_intf_pins dma_rx_csync/S_AXIS_S2MM] [get_bd_intf_pins qpsk_rx_csync/m_axis_tap]
  connect_bd_intf_net -intf_net axi_qpsk_rx_dec_0_m_axis_tap [get_bd_intf_pins dma_rx_dec/S_AXIS_S2MM] [get_bd_intf_pins qpsk_rx_dec/m_axis_tap]
  connect_bd_intf_net -intf_net axi_qpsk_rx_dec_m_axis [get_bd_intf_pins qpsk_rx_csync/s_axis] [get_bd_intf_pins qpsk_rx_dec/m_axis]
  connect_bd_intf_net -intf_net axi_qpsk_rx_rrc_0_m_axis_tap [get_bd_intf_pins dma_rx_rrc/S_AXIS_S2MM] [get_bd_intf_pins qpsk_rx_rrc/m_axis_tap]
  connect_bd_intf_net -intf_net axi_qpsk_rx_rrc_m_axis [get_bd_intf_pins qpsk_rx_rrc/m_axis] [get_bd_intf_pins qpsk_rx_tsync/s_axis]
  connect_bd_intf_net -intf_net axi_qpsk_rx_tsync_0_m_axis_tap [get_bd_intf_pins dma_rx_tsync/S_AXIS_S2MM] [get_bd_intf_pins qpsk_rx_tsync/m_axis_tap]
  connect_bd_intf_net -intf_net decimate_logic_M_AXIS [get_bd_intf_pins decimate_logic/M_AXIS] [get_bd_intf_pins qpsk_rx_dec/s_q_axis]
  connect_bd_intf_net -intf_net decimate_logic_M_AXIS1 [get_bd_intf_pins decimate_logic/M_AXIS1] [get_bd_intf_pins qpsk_rx_dec/s_i_axis]
  connect_bd_intf_net -intf_net dma_rx_csync_M_AXI_S2MM [get_bd_intf_pins dma_rx_csync/M_AXI_S2MM] [get_bd_intf_pins smartconnect_0/S01_AXI]
  connect_bd_intf_net -intf_net dma_rx_dec_M_AXI_S2MM [get_bd_intf_pins dma_rx_dec/M_AXI_S2MM] [get_bd_intf_pins smartconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net dma_rx_rrc_M_AXI_S2MM [get_bd_intf_pins dma_rx_rrc/M_AXI_S2MM] [get_bd_intf_pins smartconnect_0/S02_AXI]
  connect_bd_intf_net -intf_net dma_rx_tsync_M_AXI_S2MM [get_bd_intf_pins dma_rx_tsync/M_AXI_S2MM] [get_bd_intf_pins smartconnect_0/S03_AXI]
  connect_bd_intf_net -intf_net s_i_axis_1 [get_bd_intf_pins s_i_axis] [get_bd_intf_pins decimate_logic/S_AXIS_DATA]
  connect_bd_intf_net -intf_net s_q_axis_1 [get_bd_intf_pins s_q_axis] [get_bd_intf_pins decimate_logic/S_AXIS_DATA1]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins M00_AXI] [get_bd_intf_pins smartconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_M_AXI_HPM1_FPD [get_bd_intf_pins S00_AXI] [get_bd_intf_pins axi_interconnect_0/S00_AXI]

  # Create port connections
  connect_bd_net -net ARESETN_1 [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins reset_pl/interconnect_aresetn]
  connect_bd_net -net S00_ARESETN_1 [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins reset_pl/peripheral_aresetn]
  connect_bd_net -net axi_dma_rx_csync_s2mm_introut [get_bd_pins dma_rx_csync/s2mm_introut] [get_bd_pins xlconcat_0/In2]
  connect_bd_net -net axi_dma_rx_dec0_s2mm_introut [get_bd_pins dma_rx_dec/s2mm_introut] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net axi_dma_rx_rrc_0_s2mm_introut [get_bd_pins dma_rx_rrc/s2mm_introut] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net axi_dma_rx_tsync_s2mm_introut [get_bd_pins dma_rx_tsync/s2mm_introut] [get_bd_pins xlconcat_0/In3]
  connect_bd_net -net clk_rx_locked [get_bd_pins clk_rx/locked] [get_bd_pins reset_128/dcm_locked] [get_bd_pins reset_256/dcm_locked]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins clk_128] [get_bd_pins clk_rx/clk_128] [get_bd_pins decimate_logic/clk_128] [get_bd_pins reset_128/slowest_sync_clk] [get_bd_pins smartconnect_0/aclk1]
  connect_bd_net -net clk_wiz_1_clk_out1 [get_bd_pins clk_25_6] [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_0/M01_ACLK] [get_bd_pins axi_interconnect_0/M02_ACLK] [get_bd_pins axi_interconnect_0/M03_ACLK] [get_bd_pins axi_interconnect_0/M04_ACLK] [get_bd_pins axi_interconnect_0/M05_ACLK] [get_bd_pins axi_interconnect_0/M06_ACLK] [get_bd_pins axi_interconnect_0/M07_ACLK] [get_bd_pins clk_rx/clk_25_6] [get_bd_pins decimate_logic/clk_25_6] [get_bd_pins dma_rx_csync/m_axi_s2mm_aclk] [get_bd_pins dma_rx_csync/s_axi_lite_aclk] [get_bd_pins dma_rx_dec/m_axi_s2mm_aclk] [get_bd_pins dma_rx_dec/s_axi_lite_aclk] [get_bd_pins dma_rx_rrc/m_axi_s2mm_aclk] [get_bd_pins dma_rx_rrc/s_axi_lite_aclk] [get_bd_pins dma_rx_tsync/m_axi_s2mm_aclk] [get_bd_pins dma_rx_tsync/s_axi_lite_aclk] [get_bd_pins qpsk_rx_csync/clk] [get_bd_pins qpsk_rx_dec/clk] [get_bd_pins qpsk_rx_rrc/clk] [get_bd_pins qpsk_rx_tsync/clk] [get_bd_pins reset_256/slowest_sync_clk] [get_bd_pins smartconnect_0/aclk]
  connect_bd_net -net reset_1 [get_bd_pins reset] [get_bd_pins clk_rx/reset]
  connect_bd_net -net reset_128_peripheral_aresetn [get_bd_pins reset_128] [get_bd_pins decimate_logic/reset_128] [get_bd_pins reset_128/peripheral_aresetn]
  connect_bd_net -net reset_256_peripheral_aresetn [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins axi_interconnect_0/M01_ARESETN] [get_bd_pins axi_interconnect_0/M02_ARESETN] [get_bd_pins axi_interconnect_0/M03_ARESETN] [get_bd_pins axi_interconnect_0/M04_ARESETN] [get_bd_pins axi_interconnect_0/M05_ARESETN] [get_bd_pins axi_interconnect_0/M06_ARESETN] [get_bd_pins axi_interconnect_0/M07_ARESETN] [get_bd_pins dma_rx_csync/axi_resetn] [get_bd_pins dma_rx_dec/axi_resetn] [get_bd_pins dma_rx_rrc/axi_resetn] [get_bd_pins dma_rx_tsync/axi_resetn] [get_bd_pins qpsk_rx_csync/axi_qpsk_rx_csync_aresetn] [get_bd_pins qpsk_rx_dec/axi_qpsk_rx_dec_aresetn] [get_bd_pins qpsk_rx_rrc/axi_qpsk_rx_rrc_aresetn] [get_bd_pins qpsk_rx_tsync/axi_qpsk_rx_tsync_aresetn] [get_bd_pins reset_256/peripheral_aresetn] [get_bd_pins smartconnect_0/aresetn]
  connect_bd_net -net usp_rf_data_converter_0_clk_adc0 [get_bd_pins adc_clk_64] [get_bd_pins clk_rx/clk_in1]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins s2mm_introut] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk0 [get_bd_pins pl_clk_100] [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins reset_pl/slowest_sync_clk]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_resetn0 [get_bd_pins pl_reset] [get_bd_pins reset_128/ext_reset_in] [get_bd_pins reset_256/ext_reset_in] [get_bd_pins reset_pl/ext_reset_in]

  # Restore current instance
  current_bd_instance $oldCurInst
}


proc available_tcl_procs { } {
   puts "##################################################################"
   puts "# Available Tcl procedures to recreate hierarchical blocks:"
   puts "#"
   puts "#    create_hier_cell_qpsk_rx parentCell nameHier"
   puts "#    create_hier_cell_decimate_logic parentCell nameHier"
   puts "#"
   puts "##################################################################"
}

available_tcl_procs
