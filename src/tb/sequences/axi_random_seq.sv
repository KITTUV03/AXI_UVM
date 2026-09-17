`ifndef AXI_RANDOM_SEQ
`define AXI_RANDOM_SEQ

class axi_random_seq extends axi_base_sequence;
  `uvm_object_utils(axi_random_seq)

  function new(string name = "axi_random_seq");
    super.new(name);
  endfunction

  task body();
    axi_trans pkt;
    `uvm_info("AXI_RANDOM", "Starting Random Sequence", UVM_LOW)

    repeat(`NUM_OF_TRANS * 3) begin
      pkt = axi_trans::type_id::create("pkt");
      start_item(pkt);
      pkt.slv_err_address.constraint_mode(0);
      pkt.dec_err_address.constraint_mode(0);
      pkt.default_wstrb.constraint_mode(0);
      assert(pkt.randomize() with {
        operation inside {single_w, single_r, b2b_w, b2b_r, sim_rw};
      });
      finish_item(pkt);
      `uvm_info("AXI_RANDOM", $sformatf("OP=%s wr_addr=0x%08h rd_addr=0x%08h",
                pkt.operation.name(), pkt.AWADDR, pkt.ARADDR), UVM_HIGH)
    end

    `uvm_info("AXI_RANDOM", "Random Sequence Complete", UVM_LOW)
  endtask

endclass

`endif

