`ifndef AXI_ENV
`define AXI_ENV

class axi_env extends uvm_env;
  `uvm_component_utils(axi_env)

  axi_act_agent agt;
  axi_scb       scb;
  axi_sub       cov;

  function new(string name = "axi_env", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agt = axi_act_agent::type_id::create("agt", this);
    scb = axi_scb::type_id::create("scb", this);
    cov = axi_sub::type_id::create("cov", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agt.mon.write_ap.connect(scb.write_export);
    agt.mon.read_ap.connect(scb.read_export);
    agt.mon.write_ap.connect(cov.write_export);
    agt.mon.read_ap.connect(cov.read_export);
    `uvm_info("AXI_ENV", "Monitor->Scoreboard and Monitor->Coverage connected", UVM_HIGH)
  endfunction

endclass

`endif
