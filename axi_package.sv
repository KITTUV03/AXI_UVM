`include "define.svh"
//`include "axi_interface.sv"

package axi_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  `include "axi_trans.sv"
  `include "axi_base_sequence.sv"
  `include "axi_sanity_test.sv"
  `include "axi_b2b_write.sv"
  `include "axi_b2b_read.sv"
  `include "axi_write_read_seq.sv"
//   `include "axi_sim_rw.sv"
  `include "axi_slv_err.sv"
  `include "axi_dec_err.sv"
  `include "axi_negative_test.sv"
//   `include "axi_reset_test.sv"
  `include "axi_wstrb_seq.sv"
//   `include "axi_random_seq.sv"
  `include "axi_sequencer.sv"
  `include "axi_driver.sv"
  `include "axi_input_monitor.sv"
  `include "axi_active_agent.sv"
  `include "axi_scoreboard.sv"
  `include "axi_subscriber.sv"
  `include "axi_env.sv"
  `include "axi_test.sv"
  //`include "axi_regression_test.sv"
endpackage

