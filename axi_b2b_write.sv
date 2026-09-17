`ifndef AXI_B2B_SEQ
`define AXI_B2B_SEQ

class axi_b2b_seq extends axi_base_sequence;
  `uvm_object_utils(axi_b2b_seq)

  function new(string name = "axi_b2b_seq");
    super.new(name);
  endfunction

  task body();
    axi_trans pkt;
    `uvm_info("AXI_B2B_WRITE", "Starting Back-to-Back Write Sequence", UVM_LOW)

    repeat(`NUM_OF_TRANS) begin
      pkt = axi_trans::type_id::create("pkt");
      start_item(pkt);
      pkt.slv_err_address.constraint_mode(0);
      pkt.dec_err_address.constraint_mode(0);
      assert(pkt.randomize() with {operation == b2b_w;});
      finish_item(pkt);
      `uvm_info("AXI_B2B_WRITE", $sformatf("B2B WRITE addr=0x%08h data=0x%08h resp=%0d",
                pkt.AWADDR, pkt.WDATA, pkt.BRESP), UVM_MEDIUM)
    end

    `uvm_info("AXI_B2B_WRITE", "Back-to-Back Write Sequence Complete", UVM_LOW)
  endtask

endclass

`endif
