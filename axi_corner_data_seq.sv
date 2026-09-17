`ifndef AXI_CORNER_DATA_SEQ
`define AXI_CORNER_DATA_SEQ

class axi_corner_data_wr_seq extends axi_base_sequence;
  `uvm_object_utils(axi_corner_data_wr_seq)

  function new(string name = "axi_corner_data_wr_seq");
    super.new(name);
  endfunction

  task body();
    axi_trans wr_pkt;
    bit [31:0] test_patterns[6] = '{
      32'h0000_0000,
      32'hFFFF_FFFF,
      32'h5555_5555,
      32'hAAAA_AAAA,
      32'h1234_5678,
      32'h8765_4321
    };

    `uvm_info("AXI_CORNER_WR", "Starting Corner Data Pattern Write Sequence", UVM_LOW)

    for(int reg_idx = 0; reg_idx < 10; reg_idx++) begin
      foreach(test_patterns[p]) begin
        wr_pkt = axi_trans::type_id::create("wr_pkt");
        start_item(wr_pkt);
        wr_pkt.slv_err_address.constraint_mode(0);
        wr_pkt.dec_err_address.constraint_mode(0);
        assert(wr_pkt.randomize() with {
          operation == single_w;
          AWADDR == (reg_idx * 4);
          WDATA  == test_patterns[p];
          WSTRB  == 4'hF;
        });
        finish_item(wr_pkt);
        `uvm_info("AXI_CORNER_WR", $sformatf("WRITE addr=0x%08h data=0x%08h", wr_pkt.AWADDR, wr_pkt.WDATA), UVM_HIGH)
      end
    end

    `uvm_info("AXI_CORNER_WR", "Corner Data Pattern Write Sequence Complete", UVM_LOW)
  endtask
endclass

class axi_corner_data_rd_seq extends axi_base_sequence;
  `uvm_object_utils(axi_corner_data_rd_seq)

  function new(string name = "axi_corner_data_rd_seq");
    super.new(name);
  endfunction

  task body();
    axi_trans rd_pkt;

    `uvm_info("AXI_CORNER_RD", "Starting Corner Data Pattern Read Sequence", UVM_LOW)

    for(int reg_idx = 0; reg_idx < 10; reg_idx++) begin
      repeat(6) begin
        rd_pkt = axi_trans::type_id::create("rd_pkt");
        start_item(rd_pkt);
        rd_pkt.slv_err_address.constraint_mode(0);
        rd_pkt.dec_err_address.constraint_mode(0);
        assert(rd_pkt.randomize() with {
          operation == single_r;
          ARADDR == (reg_idx * 4);
        });
        finish_item(rd_pkt);
        `uvm_info("AXI_CORNER_RD", $sformatf("READ addr=0x%08h data=0x%08h", rd_pkt.ARADDR, rd_pkt.RDATA), UVM_HIGH)
      end
    end

    `uvm_info("AXI_CORNER_RD", "Corner Data Pattern Read Sequence Complete", UVM_LOW)
  endtask
endclass

`endif
