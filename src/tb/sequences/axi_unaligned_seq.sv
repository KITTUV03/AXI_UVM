`ifndef AXI_UNALIGNED_SEQ
`define AXI_UNALIGNED_SEQ

class axi_unaligned_wr_seq extends axi_base_sequence;
  `uvm_object_utils(axi_unaligned_wr_seq)

  function new(string name = "axi_unaligned_wr_seq");
    super.new(name);
  endfunction

  task body();
    axi_trans pkt;
    `uvm_info("AXI_UNALIGNED_WR", "Starting Unaligned Address Write Sequence", UVM_LOW)

    for(int i = 0; i < 8; i++) begin
      for(int offset = 1; offset <= 3; offset++) begin
        pkt = axi_trans::type_id::create("pkt");
        start_item(pkt);
        pkt.valid_address_range.constraint_mode(0);
        pkt.slv_err_address.constraint_mode(0);
        pkt.dec_err_address.constraint_mode(0);
        pkt.aligned_address.constraint_mode(0);
        assert(pkt.randomize() with {
          operation == single_w;
          AWADDR == ((i * 4) + offset);
        });
        finish_item(pkt);
        `uvm_info("AXI_UNALIGNED_WR", $sformatf("WRITE UNALIGNED addr=0x%08h (offset=%0d) resp=%0d (expected SLVERR)",
                  pkt.AWADDR, offset, pkt.BRESP), UVM_MEDIUM)
      end
    end

    `uvm_info("AXI_UNALIGNED_WR", "Unaligned Address Write Sequence Complete", UVM_LOW)
  endtask
endclass

class axi_unaligned_rd_seq extends axi_base_sequence;
  `uvm_object_utils(axi_unaligned_rd_seq)

  function new(string name = "axi_unaligned_rd_seq");
    super.new(name);
  endfunction

  task body();
    axi_trans pkt;
    `uvm_info("AXI_UNALIGNED_RD", "Starting Unaligned Address Read Sequence", UVM_LOW)

    for(int i = 0; i < 8; i++) begin
      for(int offset = 1; offset <= 3; offset++) begin
        pkt = axi_trans::type_id::create("pkt");
        start_item(pkt);
        pkt.valid_address_range.constraint_mode(0);
        pkt.slv_err_address.constraint_mode(0);
        pkt.dec_err_address.constraint_mode(0);
        pkt.aligned_address.constraint_mode(0);
        assert(pkt.randomize() with {
          operation == single_r;
          ARADDR == ((i * 4) + offset);
        });
        finish_item(pkt);
        `uvm_info("AXI_UNALIGNED_RD", $sformatf("READ UNALIGNED addr=0x%08h (offset=%0d) resp=%0d (expected SLVERR)",
                  pkt.ARADDR, offset, pkt.RRESP), UVM_MEDIUM)
      end
    end

    `uvm_info("AXI_UNALIGNED_RD", "Unaligned Address Read Sequence Complete", UVM_LOW)
  endtask
endclass

`endif
