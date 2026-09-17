`ifndef AXI_SLV_ERR_SEQ
`define AXI_SLV_ERR_SEQ


class axi_slv_err extends axi_base_sequence;
  `uvm_object_utils(axi_slv_err)

  function new(string name = "axi_slv_err");
    super.new(name);
  endfunction

  task body();
    axi_trans pkt;
    `uvm_info("AXI_SLV_ERR", "Starting Slave Error Sequence", UVM_LOW)

    repeat(5) begin
      pkt = axi_trans::type_id::create("pkt");
      start_item(pkt);
      pkt.valid_address_range.constraint_mode(0);
      pkt.dec_err_address.constraint_mode(0);
      assert(pkt.randomize() with {
        operation == single_w;
        AWADDR[31:6] == 0;
        AWADDR[5:2] inside {[10:12]};
        AWADDR[1:0] == 2'b00;
      });
      finish_item(pkt);
      `uvm_info("AXI_SLV_ERR", $sformatf("WRITE to RO addr=0x%08h resp=%0d (expected SLVERR=2)",
                pkt.AWADDR, pkt.BRESP), UVM_MEDIUM)
    end

    repeat(5) begin
      pkt = axi_trans::type_id::create("pkt");
      start_item(pkt);
      pkt.valid_address_range.constraint_mode(0);
      pkt.dec_err_address.constraint_mode(0);
      assert(pkt.randomize() with {
        operation == single_r;
        ARADDR[31:6] == 0;
        ARADDR[5:2] inside {[13:14]};
        ARADDR[1:0] == 2'b00;
      });
      finish_item(pkt);
      `uvm_info("AXI_SLV_ERR", $sformatf("READ from WO addr=0x%08h resp=%0d (expected SLVERR=2)",
                pkt.ARADDR, pkt.RRESP), UVM_MEDIUM)
    end

    `uvm_info("AXI_SLV_ERR", "Slave Error Sequence Complete", UVM_LOW)
  endtask

endclass

`endif
