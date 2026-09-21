`ifndef AXI_SCB
`define AXI_SCB

class axi_scb extends uvm_scoreboard;
  `uvm_component_utils(axi_scb)

  virtual intf axi_inf;

  uvm_tlm_analysis_fifo #(axi_trans) wr_inp_fifo;
  uvm_tlm_analysis_fifo #(axi_trans) wr_out_fifo;
  uvm_tlm_analysis_fifo #(axi_trans) rd_inp_fifo;
  uvm_tlm_analysis_fifo #(axi_trans) rd_out_fifo;

  bit [`DATA_WIDTH-1:0] ref_mem [bit [`ADDR_WIDTH-1:0]];

  int write_count, read_count, pass_count, fail_count;

  function new(string name = "axi_scb", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    wr_inp_fifo = new("wr_inp_fifo", this);
    wr_out_fifo = new("wr_out_fifo", this);
    rd_inp_fifo = new("rd_inp_fifo", this);
    rd_out_fifo = new("rd_out_fifo", this);
    
    ref_mem.delete(); 
    
    void'(uvm_config_db #(virtual intf)::get(this, "", "axi_inf", axi_inf));
  endfunction

  function bit [3:0] wrd_index(bit [`ADDR_WIDTH-1:0] addr);
    return addr[5:2];
  endfunction


  function bit [1:0] predict_bresp(bit [`ADDR_WIDTH-1:0] addr);
    bit [3:0] idx = wrd_index(addr);
    if (!address_range(addr))
      return 2'b11; // DECERR
    else if (!check_addr_alignment(addr) || read_only(idx))
      return 2'b10; // SLVERR
    else
      return 2'b00; // OKAY
  endfunction

  function bit [1:0] predict_rresp(bit [`ADDR_WIDTH-1:0] addr);
    bit [3:0] idx = wrd_index(addr);
    if (!address_range(addr))
      return 2'b11; // DECERR
    else if (!check_addr_alignment(addr) || write_only(idx))
      return 2'b10; // SLVERR
    else
      return 2'b00; // OKAY
  endfunction

  
  function bit check_addr_alignment(bit [`ADDR_WIDTH-1:0] addr);
    return (addr[1:0] == 2'b00);
  endfunction

 

  function bit write_only(bit [3:0] word_idx);
    return (word_idx >= 13 && word_idx <= 14);
  endfunction
  
  task run_phase(uvm_phase phase);
    fork
      write_ch();
      read_ch();
      monitor_reset();
    join_none
  endtask

  task clear_fifo(uvm_tlm_analysis_fifo #(axi_trans) fifo);
    axi_trans dummy;
    while (fifo.try_get(dummy));
  endtask

  task monitor_reset();
    if (axi_inf != null) begin
      forever begin
        @(negedge axi_inf.ARESETn);
        `uvm_info("AXI_SCOREBOARD", "[RESET DETECTED] Clearing ref_mem and draining in-flight FIFOs", UVM_MEDIUM)
        
        clear_fifo(wr_inp_fifo);
        clear_fifo(wr_out_fifo);
        clear_fifo(rd_inp_fifo);
        clear_fifo(rd_out_fifo);
                ref_mem.delete();
      end
    end
  endtask

  
   function bit address_range(bit [`ADDR_WIDTH-1:0] addr);
    return (addr < (`MEM_DEPTH * 4));
  endfunction

  function bit read_only(bit [3:0] word_idx);
    return (word_idx >= 10 && word_idx <= 12);
  endfunction
  
  
  task write_ch();
    axi_trans inp, out;
    bit [1:0] exp_resp;

    forever begin
      wr_inp_fifo.get(inp);
      wr_out_fifo.get(out);

      write_count++;
      exp_resp = predict_bresp(inp.AWADDR);

      if (out.BRESP !== exp_resp) begin
        `uvm_error("AXI_SCOREBOARD",
          $sformatf("[WRITE RESP MISMATCH] addr=0x%08h exp_resp=2'b%02b act_resp=2'b%02b time=%0t",
                    inp.AWADDR, exp_resp, out.BRESP, $time))
        fail_count++;
      end else begin
        pass_count++;
        `uvm_info("AXI_SCOREBOARD",
          $sformatf("[WRITE RESP PASS] addr=0x%08h resp=2'b%02b", inp.AWADDR, out.BRESP), UVM_MEDIUM)
      end


      if (exp_resp == 2'b00) begin
        for (int i = 0; i < (`DATA_WIDTH / 8); i++) begin
          if (inp.WSTRB[i]) begin
            ref_mem[inp.AWADDR][i*8 +: 8] = inp.WDATA[i*8 +: 8];
          end
        end
        `uvm_info("AXI_SCOREBOARD",
          $sformatf("[REF MODEL UPDATE] addr=0x%08h data=0x%08h (strb=4'b%04b)",
                    inp.AWADDR, ref_mem[inp.AWADDR], inp.WSTRB), UVM_HIGH)
      end
    end
  endtask

  task read_ch();
    axi_trans inp, out;
    bit [1:0] exp_resp;
    bit [`DATA_WIDTH-1:0] exp_data;

    forever begin
      rd_inp_fifo.get(inp);
      rd_out_fifo.get(out);

      read_count++;
      exp_resp = predict_rresp(inp.ARADDR);

      if (out.RRESP !== exp_resp) begin
        `uvm_error("AXI_SCOREBOARD",
          $sformatf("[READ RESP MISMATCH] addr=0x%08h exp_resp=2'b%02b act_resp=2'b%02b time=%0t",
                    inp.ARADDR, exp_resp, out.RRESP, $time))
        fail_count++;
        continue;
      end

      if (exp_resp == 2'b00) begin
        
        exp_data = ref_mem.exists(inp.ARADDR) ? ref_mem[inp.ARADDR] : '0;

        if (out.RDATA !== exp_data) begin
          `uvm_error("AXI_SCOREBOARD",
            $sformatf("[READ DATA MISMATCH] addr=0x%08h exp=0x%08h act=0x%08h time=%0t",
                      inp.ARADDR, exp_data, out.RDATA, $time))
          fail_count++;
        end else begin
          `uvm_info("AXI_SCOREBOARD",
            $sformatf("[READ DATA PASS] addr=0x%08h data=0x%08h", inp.ARADDR, out.RDATA), UVM_MEDIUM)
          pass_count++;
        end
      end else begin
        if (out.RDATA !== {`DATA_WIDTH{1'b0}}) begin
          `uvm_error("AXI_SCOREBOARD",
            $sformatf("[READ ERR DATA MISMATCH] addr=0x%08h exp_data=0x00000000 act_data=0x%08h resp=2'b%02b",
                      inp.ARADDR, out.RDATA, out.RRESP))
          fail_count++;
        end else begin
          `uvm_info("AXI_SCOREBOARD",
            $sformatf("[READ ERR PASS] addr=0x%08h resp=2'b%02b data=0x00000000", inp.ARADDR, out.RRESP), UVM_MEDIUM)
          pass_count++;
        end
      end
    end
  endtask

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("AXI_SCOREBOARD",
      $sformatf("\n============ SCOREBOARD SUMMARY ============\n  Total Writes  : %0d\n  Total Reads   : %0d\n  Total Pass    : %0d\n  Total Fail    : %0d\n=============================================",
                write_count, read_count, pass_count, fail_count), UVM_LOW)
    if (fail_count > 0)
      `uvm_error("AXI_SCOREBOARD", $sformatf("TEST FAILED with %0d mismatches!", fail_count))
    else
      `uvm_info("AXI_SCOREBOARD", "ALL CHECKS PASSED", UVM_LOW)
  endfunction

endclass

`endif
