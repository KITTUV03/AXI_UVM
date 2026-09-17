`ifndef AXI_SANITY_SEQ
`define AXI_SANITY_SEQ

class axi_sanity_wr_seq extends axi_base_sequence;
  `uvm_object_utils(axi_sanity_wr_seq)

  function new(string name = "axi_sanity_wr_seq");
    super.new(name);
  endfunction

  task body();
    axi_trans wr_pkt;

    `uvm_info("AXI_SANITY_WR", "Starting Sanity Write Sequence", UVM_LOW)

    repeat(`NUM_OF_TRANS) begin
      wr_pkt = axi_trans::type_id::create("wr_pkt");
      start_item(wr_pkt);
      wr_pkt.slv_err_address.constraint_mode(0);
      wr_pkt.dec_err_address.constraint_mode(0);
      assert(wr_pkt.randomize() with {operation == single_w;});
      finish_item(wr_pkt);
      `uvm_info("AXI_SANITY_WR", $sformatf("WRITE addr=0x%08h data=0x%08h resp=%0d",
                wr_pkt.AWADDR, wr_pkt.WDATA, wr_pkt.BRESP), UVM_MEDIUM)
    end

    `uvm_info("AXI_SANITY_WR", "Sanity Write Sequence Complete", UVM_LOW)
  endtask

endclass


class axi_sanity_rd_seq extends axi_base_sequence;
  `uvm_object_utils(axi_sanity_rd_seq)

  function new(string name = "axi_sanity_rd_seq");
    super.new(name);
  endfunction

  task body();
    axi_trans rd_pkt;

    `uvm_info("AXI_SANITY_RD", "Starting Sanity Read Sequence", UVM_LOW)

    repeat(`NUM_OF_TRANS) begin
      rd_pkt = axi_trans::type_id::create("rd_pkt");
      start_item(rd_pkt);
      rd_pkt.slv_err_address.constraint_mode(0);
      rd_pkt.dec_err_address.constraint_mode(0);
      assert(rd_pkt.randomize() with {operation == single_r;});
      finish_item(rd_pkt);
      `uvm_info("AXI_SANITY_RD", $sformatf("READ addr=0x%08h data=0x%08h resp=%0d",
                rd_pkt.ARADDR, rd_pkt.RDATA, rd_pkt.RRESP), UVM_MEDIUM)
    end

    `uvm_info("AXI_SANITY_RD", "Sanity Read Sequence Complete", UVM_LOW)
  endtask

endclass

`endif
