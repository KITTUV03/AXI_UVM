`ifndef AXI_NEGATIVE_SEQ
`define AXI_NEGATIVE_SEQ

class axi_negative_seq extends axi_base_sequence;
  `uvm_object_utils(axi_negative_seq)

  function new(string name = "axi_negative_seq");
    super.new(name);
  endfunction

  task body();
    axi_trans wr_pkt;
    axi_trans rd_pkt;
    `uvm_info("AXI_NEGATIVE", "Starting Negative Test Sequence", UVM_LOW)
     
     repeat(2) begin
      wr_pkt = axi_trans::type_id::create("wr_pkt");
      start_item(wr_pkt);
      wr_pkt.slv_err_address.constraint_mode(0);
      wr_pkt.dec_err_address.constraint_mode(0);
      assert(wr_pkt.randomize() with {operation == single_w;AWADDR==32'h00000000;});
      finish_item(wr_pkt);
      `uvm_info("AXI_Negative_WR", $sformatf("WRITE addr=0x%08h data=0x%08h resp=%0d",
                wr_pkt.AWADDR, wr_pkt.WDATA, wr_pkt.BRESP), UVM_MEDIUM)
    end


     repeat(2) begin
      rd_pkt = axi_trans::type_id::create("rd_pkt");
      start_item(rd_pkt);
      rd_pkt.slv_err_address.constraint_mode(0);
      rd_pkt.dec_err_address.constraint_mode(0);
      assert(rd_pkt.randomize() with {operation == single_r;ARADDR==32'h00000000;});
      finish_item(rd_pkt);
      
    end


   repeat(2) begin
   wr_pkt = axi_trans::type_id::create("wr_pkt");
      start_item(wr_pkt);
      wr_pkt.slv_err_address.constraint_mode(0);
      wr_pkt.dec_err_address.constraint_mode(0);
      assert(wr_pkt.randomize() with {operation == single_w;AWADDR==32'hFFFFFFFF;});
      finish_item(wr_pkt);
      `uvm_info("AXI_Negative_WR", $sformatf("WRITE addr=0x%08h data=0x%08h resp=%0d",
                wr_pkt.AWADDR, wr_pkt.WDATA, wr_pkt.BRESP), UVM_MEDIUM)
    end


     repeat(2) begin
      rd_pkt = axi_trans::type_id::create("rd_pkt");
      start_item(rd_pkt);
      rd_pkt.slv_err_address.constraint_mode(0);
      rd_pkt.dec_err_address.constraint_mode(0);
      assert(rd_pkt.randomize() with {operation == single_r;ARADDR==32'hFFFFFFFF;});
      finish_item(rd_pkt);

    end

  endtask

endclass

`endif
