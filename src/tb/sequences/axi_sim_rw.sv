`ifndef AXI_SIM_RW_SEQ
`define AXI_SIM_RW_SEQ

class axi_sim_rw extends axi_base_sequence;
  `uvm_object_utils(axi_sim_rw)

  function new(string name = "axi_sim_rw");
    super.new(name);
  endfunction

  task body();
    axi_trans pkt;
    `uvm_info("AXI_SIM_RW", "Starting Simultaneous Read+Write Sequence", UVM_LOW)

    
    repeat(5) begin
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
      assert(pkt.randomize() with {operation == sim_rw;});
      finish_item(pkt);
      `uvm_info("AXI_SIM_RW", $sformatf("SIM_RW wr_addr=0x%08h wr_data=0x%08h bresp=%0d rd_addr=0x%08h rd_data=0x%08h rresp=%0d",
                pkt.AWADDR, pkt.WDATA, pkt.BRESP, pkt.ARADDR, pkt.RDATA, pkt.RRESP), UVM_MEDIUM)
    end

    `uvm_info("AXI_SIM_RW", "Simultaneous Read+Write Sequence Complete", UVM_LOW)
  endtask

endclass

`endif
