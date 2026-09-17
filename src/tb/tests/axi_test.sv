`ifndef AXI_TEST
`define AXI_TEST

class axi_base_test extends uvm_test;
  `uvm_component_utils(axi_base_test)

  axi_env env;

  function new(string name = "axi_base_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    set_type_override_by_type(axi_driver::get_type(), axi_override_driver::get_type());
    env = axi_env::type_id::create("env", this);
  endfunction

  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info("AXI_TEST", $sformatf("Running test: %s", get_type_name()), UVM_LOW)
    phase.drop_objection(this);
  endtask

  function void report_phase(uvm_phase phase);
    uvm_report_server svr;
    super.report_phase(phase);
    svr = uvm_report_server::get_server();
    if(svr.get_severity_count(UVM_ERROR) > 0 || svr.get_severity_count(UVM_FATAL) > 0)
      `uvm_info("AXI_TEST", "\n*** TEST FAILED ***", UVM_NONE)
    else
      `uvm_info("AXI_TEST", "\n*** TEST PASSED ***", UVM_NONE)
  endfunction

endclass


// 1. Sanity Test (Basic R/W across standard registers)
class axi_sanity_test extends axi_base_test;
  `uvm_component_utils(axi_sanity_test)

  function new(string name = "axi_sanity_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    axi_sanity_wr_seq wr_seq;
    axi_sanity_rd_seq rd_seq;
    phase.raise_objection(this);
    wr_seq = axi_sanity_wr_seq::type_id::create("wr_seq");
    rd_seq = axi_sanity_rd_seq::type_id::create("rd_seq");
    wr_seq.start(env.agt.wr_sqr);  
    rd_seq.start(env.agt.rd_sqr); 
    phase.drop_objection(this);
  endtask
endclass


// 2. Back-to-back Write Test
class axi_b2b_write_test extends axi_base_test;
  `uvm_component_utils(axi_b2b_write_test)

  function new(string name = "axi_b2b_write_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    axi_b2b_seq seq;
    phase.raise_objection(this);
    seq = axi_b2b_seq::type_id::create("seq");
    seq.start(env.agt.wr_sqr);
    phase.drop_objection(this);
  endtask
endclass




class axi_slv_err_test extends axi_base_test;
  `uvm_component_utils(axi_slv_err_test)
    axi_slv_err wr_seq;
    axi_slv_err rd_seq;
  function new(string name = "axi_slv_err_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    wr_seq = axi_slv_err::type_id::create("wr_seq");
    rd_seq = axi_slv_err::type_id::create("rd_seq");
    fork
      wr_seq.start(env.agt.wr_sqr);
      rd_seq.start(env.agt.rd_sqr);
    join
    phase.drop_objection(this);
  endtask
endclass


// 5. Decode Error Test (Out-of-range addresses >= 64)
class axi_dec_err_test extends axi_base_test;
  `uvm_component_utils(axi_dec_err_test)

  function new(string name = "axi_dec_err_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    axi_dec_err wr_seq;
    axi_dec_err rd_seq;
    phase.raise_objection(this);
    wr_seq = axi_dec_err::type_id::create("wr_seq");
    rd_seq = axi_dec_err::type_id::create("rd_seq");
    fork
      wr_seq.start(env.agt.wr_sqr);
      rd_seq.start(env.agt.rd_sqr);
    join
    phase.drop_objection(this);
  endtask
endclass


// 6. Unaligned Address Access Test (ADDR[1:0] != 00)
class axi_unaligned_test extends axi_base_test;
  `uvm_component_utils(axi_unaligned_test)

  function new(string name = "axi_unaligned_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    axi_unaligned_wr_seq wr_seq;
    axi_unaligned_rd_seq rd_seq;
    phase.raise_objection(this);
    wr_seq = axi_unaligned_wr_seq::type_id::create("wr_seq");
    rd_seq = axi_unaligned_rd_seq::type_id::create("rd_seq");
    fork
      wr_seq.start(env.agt.wr_sqr);
      rd_seq.start(env.agt.rd_sqr);
    join
    phase.drop_objection(this);
  endtask
endclass


// 7. Byte-Strobe Test (All 16 strobe patterns 0x0 to 0xF)
class axi_wstrb_test extends axi_base_test;
  `uvm_component_utils(axi_wstrb_test)

  function new(string name = "axi_wstrb_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    axi_wstrb_wr_seq wr_seq;
    axi_wstrb_rd_seq rd_seq;
    phase.raise_objection(this);
    wr_seq = axi_wstrb_wr_seq::type_id::create("wr_seq");
    rd_seq = axi_wstrb_rd_seq::type_id::create("rd_seq");
    wr_seq.start(env.agt.wr_sqr);
    rd_seq.start(env.agt.rd_sqr);
    phase.drop_objection(this);
  endtask
endclass


// 8. Corner Data Patterns Test (All 0s, All 1s, alternating patterns for toggle coverage)
class axi_corner_data_test extends axi_base_test;
  `uvm_component_utils(axi_corner_data_test)

  function new(string name = "axi_corner_data_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    axi_corner_data_wr_seq wr_seq;
    axi_corner_data_rd_seq rd_seq;
    phase.raise_objection(this);
    wr_seq = axi_corner_data_wr_seq::type_id::create("wr_seq");
    rd_seq = axi_corner_data_rd_seq::type_id::create("rd_seq");
    wr_seq.start(env.agt.wr_sqr);
    rd_seq.start(env.agt.rd_sqr);
    phase.drop_objection(this);
  endtask
endclass


// 9. Comprehensive Negative Test
class axi_negative_test extends axi_base_test;
  `uvm_component_utils(axi_negative_test)

  function new(string name = "axi_negative_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    axi_negative_seq wr_seq;
    axi_negative_seq rd_seq;
    phase.raise_objection(this);
    wr_seq = axi_negative_seq::type_id::create("wr_seq");
    rd_seq = axi_negative_seq::type_id::create("rd_seq");
    fork
      wr_seq.start(env.agt.wr_sqr);
      rd_seq.start(env.agt.rd_sqr);
    join
    phase.drop_objection(this);
  endtask
endclass
`endif
