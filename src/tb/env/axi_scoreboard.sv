`ifndef AXI_SCB
`define AXI_SCB

`uvm_analysis_imp_decl(_write_txn)
`uvm_analysis_imp_decl(_read_txn)

class axi_scb extends uvm_scoreboard;
  `uvm_component_utils(axi_scb)

  uvm_analysis_imp_write_txn #(axi_trans, axi_scb) write_export;
  uvm_analysis_imp_read_txn  #(axi_trans, axi_scb) read_export;

  bit [`DATA_WIDTH-1:0] ref_mem [0:`MEM_DEPTH-1];

  int write_count, read_count, pass_count, fail_count;

  function new(string name = "axi_scb", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    write_export = new("write_export", this);
    read_export  = new("read_export",  this);
    foreach(ref_mem[i]) ref_mem[i] = 0;
  endfunction



  function bit [3:0] wrd_index(bit [`ADDR_WIDTH-1:0] addr);
    return addr[5:2];
  endfunction

  function bit check_addr_alignment(bit [`ADDR_WIDTH-1:0] addr);
    return (addr[1:0] == 2'b00);
  endfunction

  function bit is_addr_in_range(bit [`ADDR_WIDTH-1:0] addr);
    return (addr < (`MEM_DEPTH * 4));
  endfunction

  function bit read_only(bit [3:0] word_idx);
    return (word_idx >= 10 && word_idx <= 12);
  endfunction

  function bit write_only(bit [3:0] word_idx);
    return (word_idx >= 13 && word_idx <= 14);
  endfunction

  function bit [1:0] predict_bresp(bit [`ADDR_WIDTH-1:0] addr);
    bit [3:0] idx = wrd_index(addr);
    if (!is_addr_in_range(addr))
      return 2'b11; // DECERR
    else if (!check_addr_alignment(addr) || read_only(idx))
      return 2'b10; // SLVERR
    else
      return 2'b00; // OKAY
  endfunction

  function bit [1:0] predict_rresp(bit [`ADDR_WIDTH-1:0] addr);
    bit [3:0] idx = wrd_index(addr);
    if (!is_addr_in_range(addr))
      return 2'b11; // DECERR
    else if (!check_addr_alignment(addr) || write_only(idx))
      return 2'b10; // SLVERR
    else
      return 2'b00; // OKAY
  endfunction


  function void write_write_txn(axi_trans t);
    bit [3:0] idx = wrd_index(t.AWADDR);
    bit [1:0] exp_resp;

    write_count++;
    exp_resp = predict_bresp(t.AWADDR);

    if (t.BRESP !== exp_resp) begin
      `uvm_error("AXI_SCOREBOARD",
        $sformatf("[WRITE RESP MISMATCH] addr=0x%08h exp_resp=2'b%02b act_resp=2'b%02b time=%0t",
                  t.AWADDR, exp_resp, t.BRESP, $time))
      fail_count++;
    end else begin
      pass_count++;
      `uvm_info("AXI_SCOREBOARD",
        $sformatf("[WRITE RESP PASS] addr=0x%08h resp=2'b%02b", t.AWADDR, t.BRESP), UVM_MEDIUM)
    end

    if (exp_resp == 2'b00) begin
      if (t.WSTRB[0]) ref_mem[idx][ 7: 0] = t.WDATA[ 7: 0];
      if (t.WSTRB[1]) ref_mem[idx][15: 8] = t.WDATA[15: 8];
      if (t.WSTRB[2]) ref_mem[idx][23:16] = t.WDATA[23:16];
      if (t.WSTRB[3]) ref_mem[idx][31:24] = t.WDATA[31:24];
      `uvm_info("AXI_SCOREBOARD",
        $sformatf("[REF MODEL UPDATE] ref_mem[%0d] = 0x%08h (strb=4'b%04b)",
                  idx, ref_mem[idx], t.WSTRB), UVM_HIGH)
    end
  endfunction


  function void write_read_txn(axi_trans t);
    bit [3:0] idx = wrd_index(t.ARADDR);
    bit [1:0] exp_resp;
    bit [`DATA_WIDTH-1:0] exp_data;

    read_count++;
    exp_resp = predict_rresp(t.ARADDR);

    if (t.RRESP !== exp_resp) begin
      `uvm_error("AXI_SCOREBOARD",
        $sformatf("[READ RESP MISMATCH] addr=0x%08h exp_resp=2'b%02b act_resp=2'b%02b time=%0t",
                  t.ARADDR, exp_resp, t.RRESP, $time))
      fail_count++;
      return;
    end

    if (exp_resp == 2'b00) begin
      exp_data = ref_mem[idx];
      if (t.RDATA !== exp_data) begin
        `uvm_error("AXI_SCOREBOARD",
          $sformatf("[READ DATA MISMATCH] addr=0x%08h (reg[%0d]) exp=0x%08h act=0x%08h time=%0t",
                    t.ARADDR, idx, exp_data, t.RDATA, $time))
        fail_count++;
      end else begin
        `uvm_info("AXI_SCOREBOARD",
          $sformatf("[READ DATA PASS] addr=0x%08h data=0x%08h", t.ARADDR, t.RDATA), UVM_MEDIUM)
        pass_count++;
      end
    end else begin
      if (t.RDATA !== {`DATA_WIDTH{1'b0}}) begin
        `uvm_error("AXI_SCOREBOARD",
          $sformatf("[READ ERR DATA MISMATCH] addr=0x%08h exp_data=0x00000000 act_data=0x%08h resp=2'b%02b",
                    t.ARADDR, t.RDATA, t.RRESP))
        fail_count++;
      end else begin
        `uvm_info("AXI_SCOREBOARD",
          $sformatf("[READ ERR PASS] addr=0x%08h resp=2'b%02b data=0x00000000", t.ARADDR, t.RRESP), UVM_MEDIUM)
        pass_count++;
      end
    end
  endfunction

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
