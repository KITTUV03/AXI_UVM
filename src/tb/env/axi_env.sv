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

    agt.inp_mon.write_ap.connect(scb.wr_inp_fifo.analysis_export);
    agt.inp_mon.read_ap.connect(scb.rd_inp_fifo.analysis_export);
    agt.inp_mon.write_ap.connect(cov.wr_inp_fifo.analysis_export);
    agt.inp_mon.read_ap.connect(cov.rd_inp_fifo.analysis_export);

    agt.out_mon.write_ap.connect(scb.wr_out_fifo.analysis_export);
    agt.out_mon.read_ap.connect(scb.rd_out_fifo.analysis_export);
    agt.out_mon.write_ap.connect(cov.wr_out_fifo.analysis_export);
    agt.out_mon.read_ap.connect(cov.rd_out_fifo.analysis_export);

    `uvm_info("AXI_ENV", "Input & Output Monitors -> Scoreboard & Coverage FIFOs connected successfully", UVM_HIGH)
  endfunction

endclass

`endif

