`ifndef AXI_NEGATIVE_SEQ
`define AXI_NEGATIVE_SEQ

class axi_negative_seq extends axi_base_sequence;
  `uvm_object_utils(axi_negative_seq)

  function new(string name = "axi_negative_seq");
    super.new(name);
  endfunction

  task body();
    axi_trans pkt;
    `uvm_info("AXI_NEGATIVE", "Starting Negative Test Sequence", UVM_LOW)

    for(int i = 10; i <= 12; i++) begin
      pkt = axi_trans::type_id::create("pkt");
      start_item(pkt);
      pkt.valid_address_range.constraint_mode(0);
      pkt.slv_err_address.constraint_mode(0);
      pkt.dec_err_address.constraint_mode(0);
      assert(pkt.randomize() with {
        operation == single_w;
        AWADDR == (i * 4);
      });
      finish_item(pkt);
      `uvm_info("AXI_NEGATIVE", $sformatf("WRITE to RO[%0d] addr=0x%08h resp=%0d", i, pkt.AWADDR, pkt.BRESP), UVM_MEDIUM)
    end

    for(int i = 13; i <= 14; i++) begin
      pkt = axi_trans::type_id::create("pkt");
      start_item(pkt);
      pkt.valid_address_range.constraint_mode(0);
      pkt.slv_err_address.constraint_mode(0);
      pkt.dec_err_address.constraint_mode(0);
      assert(pkt.randomize() with {
        operation == single_r;
        ARADDR == (i * 4);
      });
      finish_item(pkt);
      `uvm_info("AXI_NEGATIVE", $sformatf("READ from WO[%0d] addr=0x%08h resp=%0d", i, pkt.ARADDR, pkt.RRESP), UVM_MEDIUM)
    end

    for(int i = 16; i <= 20; i++) begin
      pkt = axi_trans::type_id::create("pkt");
      start_item(pkt);
      pkt.valid_address_range.constraint_mode(0);
      pkt.slv_err_address.constraint_mode(0);
      pkt.dec_err_address.constraint_mode(0);
      assert(pkt.randomize() with {
        operation == single_w;
        AWADDR == (i * 4);
      });
      finish_item(pkt);
      `uvm_info("AXI_NEGATIVE", $sformatf("WRITE OOR[%0d] addr=0x%08h resp=%0d", i, pkt.AWADDR, pkt.BRESP), UVM_MEDIUM)
    end

    for(int i = 16; i <= 20; i++) begin
      pkt = axi_trans::type_id::create("pkt");
      start_item(pkt);
      pkt.valid_address_range.constraint_mode(0);
      pkt.slv_err_address.constraint_mode(0);
      pkt.dec_err_address.constraint_mode(0);
      assert(pkt.randomize() with {
        operation == single_r;
        ARADDR == (i * 4);
      });
      finish_item(pkt);
      `uvm_info("AXI_NEGATIVE", $sformatf("READ OOR[%0d] addr=0x%08h resp=%0d", i, pkt.ARADDR, pkt.RRESP), UVM_MEDIUM)
    end

    `uvm_info("AXI_NEGATIVE", "Negative Test Sequence Complete", UVM_LOW)
  endtask

endclass

`endif
