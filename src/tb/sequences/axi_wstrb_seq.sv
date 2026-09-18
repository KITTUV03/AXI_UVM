`ifndef AXI_WSTRB_SEQ
`define AXI_WSTRB_SEQ

class axi_wstrb_wr_seq extends axi_base_sequence;
  `uvm_object_utils(axi_wstrb_wr_seq)

  rand bit [3:0] strb_pattern;

  function new(string name = "axi_wstrb_wr_seq");
    super.new(name);
  endfunction

  task body();
    axi_trans wr_pkt;
    `uvm_info("AXI_WSTRB_WR", "Starting WSTRB Write Sequence across all 16 strobe patterns", UVM_LOW)

    for(int s = 0; s < 16; s++) begin
      // 1. Clear register
      wr_pkt = axi_trans::type_id::create("wr_pkt");
      start_item(wr_pkt);
      wr_pkt.slv_err_address.constraint_mode(0);
      wr_pkt.dec_err_address.constraint_mode(0);
      wr_pkt.default_wstrb.constraint_mode(0);
      assert(wr_pkt.randomize() with {
        operation == single_w;
        WSTRB == s;
      });
      finish_item(wr_pkt);
     end

  endtask
endclass

class axi_wstrb_rd_seq extends axi_base_sequence;
  `uvm_object_utils(axi_wstrb_rd_seq)

  function new(string name = "axi_wstrb_rd_seq");
    super.new(name);
  endfunction

  task body();
    axi_trans rd_pkt;
    `uvm_info("AXI_WSTRB_RD", "Starting WSTRB Read Verification Sequence", UVM_LOW)

    repeat(16) begin
      rd_pkt = axi_trans::type_id::create("rd_pkt");
      start_item(rd_pkt);
      rd_pkt.slv_err_address.constraint_mode(0);
      rd_pkt.dec_err_address.constraint_mode(0);
      assert(rd_pkt.randomize() with {
        operation == single_r;
        ARADDR == 32'h0000_0000;
      });
      finish_item(rd_pkt);
      `uvm_info("AXI_WSTRB_RD", $sformatf("READ addr=0x0 data=0x%08h resp=%0d", rd_pkt.RDATA, rd_pkt.RRESP), UVM_MEDIUM)
    end

    `uvm_info("AXI_WSTRB_RD", "WSTRB Read Verification Sequence Complete", UVM_LOW)
  endtask
endclass

`endif
