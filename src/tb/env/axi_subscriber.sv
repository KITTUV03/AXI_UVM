`ifndef AXI_SUB
`define AXI_SUB

class axi_sub extends uvm_component;
  `uvm_component_utils(axi_sub)

  virtual intf axi_inf;

  uvm_tlm_analysis_fifo #(axi_trans) wr_inp_fifo;
  uvm_tlm_analysis_fifo #(axi_trans) wr_out_fifo;
  uvm_tlm_analysis_fifo #(axi_trans) rd_inp_fifo;
  uvm_tlm_analysis_fifo #(axi_trans) rd_out_fifo;

  axi_trans wr_trans;
  axi_trans rd_trans;

  covergroup write_cg;
    option.per_instance = 1;

    wr_addr_cp: coverpoint wr_trans.AWADDR[5:2] {
      bins rw_addrs[]  = {[0:9], 15};
      bins ro_addrs[]  = {[10:12]};
      bins wo_addrs[]  = {[13:14]};
    }

    wr_addr_range_cp: coverpoint wr_trans.AWADDR[5:2] {
      bins valid_range   = {[0:15]};
//      bins invalid_range = {[64:$]};
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


  endgroup

  covergroup read_cg;
    option.per_instance = 1;

    rd_addr_cp: coverpoint rd_trans.ARADDR[5:2] {
      bins rw_addrs[]  = {[0:9], 15};
      bins ro_addrs[]  = {[10:12]};
      bins wo_addrs[]  = {[13:14]};
    }

    rd_addr_range_cp: coverpoint rd_trans.ARADDR[5:2] {
      bins valid_range   = {[0:15]};
     // bins invalid_range = {[64:$]};
    }

    rresp_cp: coverpoint rd_trans.RRESP {
      bins okay   = {2'b00};
      bins slverr = {2'b10};
      bins decerr = {2'b11};
    }

  endgroup

  function new(string name = "axi_sub", uvm_component parent);
    super.new(name, parent);
    write_cg = new();
    read_cg  = new();
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    wr_inp_fifo = new("wr_inp_fifo", this);
    wr_out_fifo = new("wr_out_fifo", this);
    rd_inp_fifo = new("rd_inp_fifo", this);
    rd_out_fifo = new("rd_out_fifo", this);
    void'(uvm_config_db #(virtual intf)::get(this, "", "axi_inf", axi_inf));
  endfunction

  task run_phase(uvm_phase phase);
    fork
      sample_write_coverage();
      sample_read_coverage();
      monitor_reset();
    join_none
  endtask

  task monitor_reset();
    if (axi_inf != null) begin
      forever begin
        @(negedge axi_inf.ARESETn);
        wr_inp_fifo.flush();
        wr_out_fifo.flush();
        rd_inp_fifo.flush();
        rd_out_fifo.flush();
      end
    end
  endtask

  task sample_write_coverage();
    axi_trans inp, out;
    forever begin
      wr_inp_fifo.get(inp);
      wr_out_fifo.get(out);
      wr_trans = axi_trans::type_id::create("wr_cov_trans");
      wr_trans.AWADDR = inp.AWADDR;
      wr_trans.AWPROT = inp.AWPROT;
      wr_trans.WDATA  = inp.WDATA;
      wr_trans.WSTRB  = inp.WSTRB;
      wr_trans.BRESP  = out.BRESP;
      write_cg.sample();
      `uvm_info("AXI_COVERAGE", $sformatf("[WRITE SAMPLED] addr=0x%08h strb=0x%01h resp=%0d",
                wr_trans.AWADDR, wr_trans.WSTRB, wr_trans.BRESP), UVM_HIGH)
    end
  endtask

  task sample_read_coverage();
    axi_trans inp, out;
    forever begin
      rd_inp_fifo.get(inp);
      rd_out_fifo.get(out);
      rd_trans = axi_trans::type_id::create("rd_cov_trans");
      rd_trans.ARADDR = inp.ARADDR;
      rd_trans.ARPROT = inp.ARPROT;
      rd_trans.RDATA  = out.RDATA;
      rd_trans.RRESP  = out.RRESP;
      read_cg.sample();
      `uvm_info("AXI_COVERAGE", $sformatf("[READ SAMPLED] addr=0x%08h resp=%0d",
                rd_trans.ARADDR, rd_trans.RRESP), UVM_HIGH)
    end
  endtask

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("AXI_COVERAGE",
      $sformatf("\n============ COVERAGE SUMMARY ============\n  Write Coverage : %.2f%%\n  Read  Coverage : %.2f%%\n=============================================",
                write_cg.get_coverage(), read_cg.get_coverage()), UVM_LOW)
  endfunction

endclass

`endif

