`ifndef AXI_SQR
`define AXI_SQR

class axi_sequencer extends uvm_sequencer#(axi_trans);
  `uvm_component_utils(axi_sequencer)
  `COMP_CNSTR(axi_sequencer)
endclass

`endif
