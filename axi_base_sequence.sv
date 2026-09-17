`ifndef AXI_BASE_SEQ
`define AXI_BASE_SEQ

class axi_base_sequence extends uvm_sequence#(axi_trans);
  `uvm_object_utils(axi_base_sequence)
  `OBJ_CNSTR(axi_base_sequence)
  axi_trans packet;
endclass


`endif
