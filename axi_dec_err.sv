`ifndef AXI_DEC_ERR_SEQ
`define AXI_DEC_ERR_SEQ

class axi_dec_err extends axi_base_sequence;
  `uvm_object_utils(axi_dec_err)

  function new(string name = "axi_dec_err");
    super.new(name);
  endfunction

  task body();
    axi_trans pkt;
    `uvm_info("AXI_DEC_ERR", "Starting Decode Error Sequence", UVM_LOW)

    repeat(5) begin
      pkt = axi_trans::type_id::create("pkt");
      start_item(pkt);
      pkt.valid_address_range.constraint_mode(0);
      pkt.slv_err_address.constraint_mode(0);
      pkt.aligned_address.constraint_mode(0);
      assert(pkt.randomize() with {
        operation == single_w;
        AWADDR >= (`MEM_DEPTH * 4);
        AWADDR[1:0] == 2'b00;
        AWADDR <= 32'h0000_00FF;
      });
      finish_item(pkt);
      `uvm_info("AXI_DEC_ERR", $sformatf("WRITE out-of-range addr=0x%08h resp=%0d (expected DECERR=3)",
                pkt.AWADDR, pkt.BRESP), UVM_MEDIUM)
    end

    repeat(5) begin
      pkt = axi_trans::type_id::create("pkt");
      start_item(pkt);
      pkt.valid_address_range.constraint_mode(0);
      pkt.slv_err_address.constraint_mode(0);
      pkt.aligned_address.constraint_mode(0);
      assert(pkt.randomize() with {
        operation == single_r;
        ARADDR >= (`MEM_DEPTH * 4);
        ARADDR[1:0] == 2'b00;
        ARADDR <= 32'h0000_00FF;
      });
      finish_item(pkt);
      `uvm_info("AXI_DEC_ERR", $sformatf("READ out-of-range addr=0x%08h resp=%0d (expected DECERR=3)",
                pkt.ARADDR, pkt.RRESP), UVM_MEDIUM)
    end

    `uvm_info("AXI_DEC_ERR", "Decode Error Sequence Complete", UVM_LOW)
  endtask

endclass

`endif
