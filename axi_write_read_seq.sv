`ifndef AXI_WRITE_READ_SEQ
`define AXI_WRITE_READ_SEQ

class axi_write_read_seq extends axi_base_sequence;
  `uvm_object_utils(axi_write_read_seq)

  function new(string name = "axi_write_read_seq");
    super.new(name);
  endfunction

  task body();
    axi_trans wr_pkt, rd_pkt;
    bit [`ADDR_WIDTH-1:0] addr;
    `uvm_info("AXI_WR_RD", "Starting Write-then-Read Sequence", UVM_LOW)

    repeat(`NUM_OF_TRANS) begin
      // Write
      wr_pkt = axi_trans::type_id::create("wr_pkt");
      start_item(wr_pkt);
      wr_pkt.slv_err_address.constraint_mode(0);
      wr_pkt.dec_err_address.constraint_mode(0);
      assert(wr_pkt.randomize() with {operation == single_w;});
      finish_item(wr_pkt);
      addr = wr_pkt.AWADDR;
      `uvm_info("AXI_WR_RD", $sformatf("WRITE addr=0x%08h data=0x%08h", wr_pkt.AWADDR, wr_pkt.WDATA), UVM_MEDIUM)

      // Immediate read-back from same address
      rd_pkt = axi_trans::type_id::create("rd_pkt");
      start_item(rd_pkt);
      rd_pkt.slv_err_address.constraint_mode(0);
      rd_pkt.dec_err_address.constraint_mode(0);
      assert(rd_pkt.randomize() with {
        operation == single_r;
        ARADDR == local::addr;
      });
      finish_item(rd_pkt);
      `uvm_info("AXI_WR_RD", $sformatf("READ  addr=0x%08h data=0x%08h (expected 0x%08h)",
                rd_pkt.ARADDR, rd_pkt.RDATA, wr_pkt.WDATA), UVM_MEDIUM)
    end

    `uvm_info("AXI_WR_RD", "Write-then-Read Sequence Complete", UVM_LOW)
  endtask

endclass

`endif

