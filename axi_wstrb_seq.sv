`ifndef AXI_WSTRB_SEQ
`define AXI_WSTRB_SEQ

class axi_wstrb_seq extends axi_base_sequence;
  `uvm_object_utils(axi_wstrb_seq)

  function new(string name = "axi_wstrb_seq");
    super.new(name);
  endfunction

  task body();
    axi_trans wr_pkt, rd_pkt;
    bit [3:0] strb;
    `uvm_info("AXI_WSTRB", "Starting WSTRB Test Sequence", UVM_LOW)

    for(int s = 0; s < 16; s++) begin
      strb = s[3:0];

      wr_pkt = axi_trans::type_id::create("wr_pkt");
      start_item(wr_pkt);
      wr_pkt.slv_err_address.constraint_mode(0);
      wr_pkt.dec_err_address.constraint_mode(0);
      wr_pkt.default_wstrb.constraint_mode(0);
      assert(wr_pkt.randomize() with {
        operation == single_w;
        AWADDR == 32'h0000_0000;
        WDATA == 32'h0000_0000;
        WSTRB == 4'hF;
      });
      finish_item(wr_pkt);

      wr_pkt = axi_trans::type_id::create("wr_pkt");
      start_item(wr_pkt);
      wr_pkt.slv_err_address.constraint_mode(0);
      wr_pkt.dec_err_address.constraint_mode(0);
      wr_pkt.default_wstrb.constraint_mode(0);
      assert(wr_pkt.randomize() with {
        operation == single_w;
        AWADDR == 32'h0000_0000;
        WDATA == 32'hDEAD_BEEF;
        WSTRB == local::strb;
      });
      finish_item(wr_pkt);
      `uvm_info("AXI_WSTRB", $sformatf("WRITE strb=4'b%04b data=0xDEADBEEF resp=%0d", strb, wr_pkt.BRESP), UVM_MEDIUM)

      rd_pkt = axi_trans::type_id::create("rd_pkt");
      start_item(rd_pkt);
      rd_pkt.slv_err_address.constraint_mode(0);
      rd_pkt.dec_err_address.constraint_mode(0);
      assert(rd_pkt.randomize() with {
        operation == single_r;
        ARADDR == 32'h0000_0000;
      });
      finish_item(rd_pkt);
      `uvm_info("AXI_WSTRB", $sformatf("READ  strb=4'b%04b data=0x%08h", strb, rd_pkt.RDATA), UVM_MEDIUM)
    end

    `uvm_info("AXI_WSTRB", "WSTRB Test Sequence Complete", UVM_LOW)
  endtask

endclass

`endif

