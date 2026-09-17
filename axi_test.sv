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


// class axi_b2b_write_test extends axi_base_test;
//   `uvm_component_utils(axi_b2b_write_test)

//   function new(string name = "axi_b2b_write_test", uvm_component parent);
//     super.new(name, parent);
//   endfunction

//   task run_phase(uvm_phase phase);
//     axi_b2b_seq seq;
//     phase.raise_objection(this);
//     seq = axi_b2b_seq::type_id::create("seq");
//     seq.start(env.agt.wr_sqr);
//     phase.drop_objection(this);
//   endtask
// endclass


// class axi_b2b_read_test extends axi_base_test;
//   `uvm_component_utils(axi_b2b_read_test)

//   function new(string name = "axi_b2b_read_test", uvm_component parent);
//     super.new(name, parent);
//   endfunction

//   task run_phase(uvm_phase phase);
//     axi_b2b_read_seed_seq seed_seq;
//     axi_b2b_read_seq      rd_seq;
//     phase.raise_objection(this);
//     seed_seq = axi_b2b_read_seed_seq::type_id::create("seed_seq");
//     rd_seq   = axi_b2b_read_seq::type_id::create("rd_seq");
//     seed_seq.start(env.agt.wr_sqr);  // seed data via write channel
//     rd_seq.start(env.agt.rd_sqr);    // then read back
//     phase.drop_objection(this);
//   endtask
// endclass


// class axi_write_read_test extends axi_base_test;
//   `uvm_component_utils(axi_write_read_test)

//   function new(string name = "axi_write_read_test", uvm_component parent);
//     super.new(name, parent);
//   endfunction

//   task run_phase(uvm_phase phase);
//     axi_wr_phase_seq wr_seq;
//     axi_rd_phase_seq rd_seq;
//     phase.raise_objection(this);
//     wr_seq = axi_wr_phase_seq::type_id::create("wr_seq");
//     rd_seq = axi_rd_phase_seq::type_id::create("rd_seq");
//     // Write phase: writes random addresses, stores them
//     wr_seq.start(env.agt.wr_sqr);
//     // Read phase: reads back the same addresses
//     rd_seq.read_addrs = wr_seq.written_addrs;
//     rd_seq.start(env.agt.rd_sqr);
//     phase.drop_objection(this);
//   endtask
// endclass


// class axi_sim_rw_test extends axi_base_test;
//   `uvm_component_utils(axi_sim_rw_test)
//     axi_sim_rw wr_seq;
//     axi_sim_rw rd_seq;
//   function new(string name = "axi_sim_rw_test", uvm_component parent);
//     super.new(name, parent);
//   endfunction

//   task run_phase(uvm_phase phase);
   
//     phase.raise_objection(this);
//     wr_seq = axi_sim_rw::type_id::create("wr_seq");
//     rd_seq = axi_sim_rw::type_id::create("rd_seq");
//     fork
//       wr_seq.start(env.agt.wr_sqr);
//       rd_seq.start(env.agt.rd_sqr);
//     join
//     phase.drop_objection(this);
//   endtask
// endclass


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


// class axi_dec_err_test extends axi_base_test;
//   `uvm_component_utils(axi_dec_err_test)

//   function new(string name = "axi_dec_err_test", uvm_component parent);
//     super.new(name, parent);
//   endfunction

//   task run_phase(uvm_phase phase);
//     axi_dec_err_wr_seq wr_seq;
//     axi_dec_err_rd_seq rd_seq;
//     phase.raise_objection(this);
//     wr_seq = axi_dec_err_wr_seq::type_id::create("wr_seq");
//     rd_seq = axi_dec_err_rd_seq::type_id::create("rd_seq");
//     fork
//       wr_seq.start(env.agt.wr_sqr);
//       rd_seq.start(env.agt.rd_sqr);
//     join
//     phase.drop_objection(this);
//   endtask
// endclass


// class axi_wstrb_test extends axi_base_test;
//   `uvm_component_utils(axi_wstrb_test)

//   function new(string name = "axi_wstrb_test", uvm_component parent);
//     super.new(name, parent);
//   endfunction

//   task run_phase(uvm_phase phase);
//     axi_wstrb_wr_seq wr_seq;
//     axi_wstrb_rd_seq rd_seq;
//     phase.raise_objection(this);

//     `uvm_info("AXI_TEST", "Starting WSTRB Test: 16 strobe patterns", UVM_LOW)
//     for(int s = 0; s < 16; s++) begin
//       // Write: clear register + write with strobe pattern s
//       wr_seq = axi_wstrb_wr_seq::type_id::create("wr_seq");
//       wr_seq.strb_pattern = s;
//       wr_seq.start(env.agt.wr_sqr);
//       // Read: verify byte-lane updates
//       rd_seq = axi_wstrb_rd_seq::type_id::create("rd_seq");
//       rd_seq.start(env.agt.rd_sqr);
//     end

//     phase.drop_objection(this);
//   endtask
// endclass


// class axi_negative_test extends axi_base_test;
//   `uvm_component_utils(axi_negative_test)

//   function new(string name = "axi_negative_test", uvm_component parent);
//     super.new(name, parent);
//   endfunction

//   task run_phase(uvm_phase phase);
//     axi_neg_wr_seq wr_seq;
//     axi_neg_rd_seq rd_seq;
//     phase.raise_objection(this);
//     wr_seq = axi_neg_wr_seq::type_id::create("wr_seq");
//     rd_seq = axi_neg_rd_seq::type_id::create("rd_seq");
//     fork
//       wr_seq.start(env.agt.wr_sqr);
//       rd_seq.start(env.agt.rd_sqr);
//     join
//     phase.drop_objection(this);
//   endtask
// endclass


// class axi_random_test extends axi_base_test;
//   `uvm_component_utils(axi_random_test)

//   function new(string name = "axi_random_test", uvm_component parent);
//     super.new(name, parent);
//   endfunction

//   task run_phase(uvm_phase phase);
//     axi_random_wr_seq wr_seq;
//     axi_random_rd_seq rd_seq;
//     phase.raise_objection(this);
//     wr_seq = axi_random_wr_seq::type_id::create("wr_seq");
//     rd_seq = axi_random_rd_seq::type_id::create("rd_seq");
//     fork
//       wr_seq.start(env.agt.wr_sqr);
//       rd_seq.start(env.agt.rd_sqr);
//     join
//     phase.drop_objection(this);
//   endtask
// endclass

`endif
