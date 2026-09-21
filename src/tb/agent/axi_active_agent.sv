`ifndef AXI_ACT_AGT
`define AXI_ACT_AGT

class axi_act_agent extends uvm_agent;
  `uvm_component_utils(axi_act_agent)
  
  axi_sequencer     wr_sqr;
  axi_sequencer     rd_sqr;
  axi_driver        drv;
  axi_input_monitor inp_mon;
  axi_out_monitor   out_mon;

  function new(string name = "axi_act_agent", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    wr_sqr  = axi_sequencer::type_id::create("wr_sqr", this);
    rd_sqr  = axi_sequencer::type_id::create("rd_sqr", this);
    drv     = axi_driver::type_id::create("drv", this);
    inp_mon = axi_input_monitor::type_id::create("inp_mon", this);
    out_mon = axi_out_monitor::type_id::create("out_mon", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    drv.seq_item_port.connect(wr_sqr.seq_item_export);
    drv.rd_item_port.connect(rd_sqr.seq_item_export);
  endfunction
  
endclass

`endif

