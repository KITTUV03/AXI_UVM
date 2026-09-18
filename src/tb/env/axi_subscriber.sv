`ifndef AXI_SUB
`define AXI_SUB

`uvm_analysis_imp_decl(_cov_write)
`uvm_analysis_imp_decl(_cov_read)

class axi_sub extends uvm_component;
  `uvm_component_utils(axi_sub)

  uvm_analysis_imp_cov_write #(axi_trans, axi_sub) write_export;
  uvm_analysis_imp_cov_read  #(axi_trans, axi_sub) read_export;

  axi_trans wr_trans;
  axi_trans rd_trans;

  covergroup write_cg;
    option.per_instance = 1;

    wr_addr_cp: coverpoint wr_trans.AWADDR[5:2] {
      bins rw_addrs[]  = {[0:9], 15};
      bins ro_addrs[]  = {[10:12]};
      bins wo_addrs[]  = {[13:14]};
    }

    wr_addr_range_cp: coverpoint wr_trans.AWADDR {
      bins valid_range   = {[0:63]};
      bins invalid_range = {[64:$]};
    }

    wstrb_cp: coverpoint wr_trans.WSTRB {
      bins all_bytes      = {4'hF};
      bins no_bytes       = {4'h0};
      bins single_byte[]  = {4'h1, 4'h2, 4'h4, 4'h8};
      bins two_bytes[]    = {4'h3, 4'h5, 4'h6, 4'h9, 4'hA, 4'hC};
      bins three_bytes[]  = {4'h7, 4'hB, 4'hD, 4'hE};
    }

    bresp_cp: coverpoint wr_trans.BRESP {
      bins okay   = {2'b00};
      bins slverr = {2'b10};
      bins decerr = {2'b11};
    }

    wdata_cp: coverpoint wr_trans.WDATA {
      bins zero     = {32'h0000_0000};
      bins all_ones = {32'hFFFF_FFFF};
      bins others   = default;
    }

  endgroup

  covergroup read_cg;
    option.per_instance = 1;

    rd_addr_cp: coverpoint rd_trans.ARADDR[5:2] {
      bins rw_addrs[]  = {[0:9], 15};
      bins ro_addrs[]  = {[10:12]};
      bins wo_addrs[]  = {[13:14]};
    }

    rd_addr_range_cp: coverpoint rd_trans.ARADDR {
      bins valid_range   = {[0:63]};
      bins invalid_range = {[64:$]};
    }

    rresp_cp: coverpoint rd_trans.RRESP {
      bins okay   = {2'b00};
      bins slverr = {2'b10};
      bins decerr = {2'b11};
    }

    rdata_cp: coverpoint rd_trans.RDATA {
      bins zero     = {32'h0000_0000};
      bins all_ones = {32'hFFFF_FFFF};
      bins others   = default;
    }

  endgroup


  function new(string name = "axi_sub", uvm_component parent);
    super.new(name, parent);
    write_cg = new();
    read_cg  = new();
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    write_export = new("write_export", this);
    read_export  = new("read_export",  this);
  endfunction


  function void write_cov_write(axi_trans t);
    wr_trans = t;
    write_cg.sample();
    `uvm_info("AXI_COVERAGE", $sformatf("[WRITE SAMPLED] addr=0x%08h strb=0x%01h resp=%0d",
              t.AWADDR, t.WSTRB, t.BRESP), UVM_HIGH)
  endfunction


  function void write_cov_read(axi_trans t);
    rd_trans = t;
    read_cg.sample();
    `uvm_info("AXI_COVERAGE", $sformatf("[READ SAMPLED] addr=0x%08h resp=%0d",
              t.ARADDR, t.RRESP), UVM_HIGH)
  endfunction


  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("AXI_COVERAGE",
      $sformatf("\n============ COVERAGE SUMMARY ============\n  Write Coverage : %.2f%%\n  Read  Coverage : %.2f%%\n=============================================",
                write_cg.get_coverage(), read_cg.get_coverage()), UVM_LOW)
  endfunction

endclass

`endif
