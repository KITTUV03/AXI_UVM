`ifndef AXI_RESET_SEQ
`define AXI_RESET_SEQ

class axi_reset_seq extends axi_base_sequence;
  `uvm_object_utils(axi_reset_seq)

  virtual intf axi_inf;

  function new(string name = "axi_reset_seq");
    super.new(name);
  endfunction

  task body();
    axi_trans pkt;

    if(!uvm_config_db #(virtual intf)::get(null, "*", "axi_inf", axi_inf))
      `uvm_fatal("AXI_RESET_SEQ", "Interface Not Received")

    `uvm_info("AXI_RESET_SEQ", "Starting Reset Sequence", UVM_LOW)

    for(int i = 0; i < 5; i++) begin
      pkt = axi_trans::type_id::create("pkt");
      start_item(pkt);
      pkt.slv_err_address.constraint_mode(0);
      pkt.dec_err_address.constraint_mode(0);
      assert(pkt.randomize() with {
        operation == single_w;
        AWADDR == (i * 4); 
        WSTRB == 4'hF;
      });
      finish_item(pkt);
      `uvm_info("AXI_RESET_SEQ", $sformatf("PRE-RESET WRITE addr=0x%08h data=0x%08h",
                pkt.AWADDR, pkt.WDATA), UVM_MEDIUM)
    end

    `uvm_info("AXI_RESET_SEQ", "Asserting reset (ARESETn = 0)", UVM_LOW)
    axi_inf.ARESETn = 1'b0;
    repeat(3) @(posedge axi_inf.ACLK);
    axi_inf.ARESETn = 1'b1;
    repeat(2) @(posedge axi_inf.ACLK);
    `uvm_info("AXI_RESET_SEQ", "Reset released (ARESETn = 1)", UVM_LOW)

    for(int i = 0; i < 5; i++) begin
      pkt = axi_trans::type_id::create("pkt");
      start_item(pkt);
      pkt.slv_err_address.constraint_mode(0);
      pkt.dec_err_address.constraint_mode(0);
      assert(pkt.randomize() with {
        operation == single_r;
        ARADDR == (i * 4);
      });
      finish_item(pkt);
      `uvm_info("AXI_RESET_SEQ", $sformatf("POST-RESET READ addr=0x%08h data=0x%08h (expected 0x00000000)",
                pkt.ARADDR, pkt.RDATA), UVM_MEDIUM)
    end

    `uvm_info("AXI_RESET_SEQ", "Reset Sequence Complete", UVM_LOW)
  endtask

endclass

`endif
