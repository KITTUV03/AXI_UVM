`ifndef AXI_B2B_READ_SEQ
`define AXI_B2B_READ_SEQ

class axi_b2b_read_seq extends axi_base_sequence;
  `uvm_object_utils(axi_b2b_read_seq)

  function new(string name = "axi_b2b_read_seq");
    super.new(name);
  endfunction

  task body();
    axi_trans pkt;
    `uvm_info("AXI_B2B_READ", "Starting Back-to-Back Read Sequence", UVM_LOW)

    repeat(`NUM_OF_TRANS) begin
      pkt = axi_trans::type_id::create("pkt");
      start_item(pkt);
      pkt.slv_err_address.constraint_mode(0);
      pkt.dec_err_address.constraint_mode(0);
      assert(pkt.randomize() with {operation == single_w;});
      finish_item(pkt);
    end

    repeat(`NUM_OF_TRANS) begin
      pkt = axi_trans::type_id::create("pkt");
      start_item(pkt);
      pkt.slv_err_address.constraint_mode(0);
      pkt.dec_err_address.constraint_mode(0);
      assert(pkt.randomize() with {operation == b2b_r;});
      finish_item(pkt);
      `uvm_info("AXI_B2B_READ", $sformatf("B2B READ addr=0x%08h data=0x%08h resp=%0d",
                pkt.ARADDR, pkt.RDATA, pkt.RRESP), UVM_MEDIUM)
    end

    `uvm_info("AXI_B2B_READ", "Back-to-Back Read Sequence Complete", UVM_LOW)
  endtask

endclass

`endif
