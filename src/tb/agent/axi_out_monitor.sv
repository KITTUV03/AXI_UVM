`ifndef AXI_OUT_MON
`define AXI_OUT_MON

class axi_out_monitor extends uvm_monitor;
  `uvm_component_utils(axi_out_monitor)

  virtual intf axi_inf;
  uvm_analysis_port #(axi_trans) write_ap;
  uvm_analysis_port #(axi_trans) read_ap;

  function new(string name = "axi_out_monitor", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    write_ap = new("write_ap", this);
    read_ap  = new("read_ap",  this);
    if(!uvm_config_db #(virtual intf)::get(this, "", "axi_inf", axi_inf))
      `uvm_fatal("AXI_OUT_MON", "Interface Not Received in Output Monitor")
  endfunction

  task run_phase(uvm_phase phase);
    wait(axi_inf.ARESETn === 1'b1);
    @(axi_inf.mon_cb);

    fork
      monitor_write_channel();
      monitor_read_channel();
    join_none
  endtask

  task monitor_write_channel();
    axi_trans wr_resp;

    forever begin
      wr_resp = axi_trans::type_id::create("wr_out_trans");
      wr_resp.operation = single_w;

      forever begin
        @(axi_inf.mon_cb);
        if (!axi_inf.ARESETn) begin
          wait(axi_inf.ARESETn === 1'b1);
          @(axi_inf.mon_cb);
          continue;
        end
        if (axi_inf.mon_cb.BVALID && axi_inf.mon_cb.BREADY) begin
          wr_resp.BRESP = axi_inf.mon_cb.BRESP;
          `uvm_info("AXI_OUT_MON", $sformatf("[B CAPTURED] resp=%0d", wr_resp.BRESP), UVM_HIGH)
          break;
        end
      end

      `uvm_info("AXI_OUT_MON", $sformatf("[WRITE OUTPUT COMPLETE] resp=%0d", wr_resp.BRESP), UVM_MEDIUM)
      write_ap.write(wr_resp);
    end
  endtask

  task monitor_read_channel();
    axi_trans rd_resp;

    forever begin
      rd_resp = axi_trans::type_id::create("rd_out_trans");
      rd_resp.operation = single_r;

      forever begin
        @(axi_inf.mon_cb);
        if (!axi_inf.ARESETn) begin
          wait(axi_inf.ARESETn === 1'b1);
          @(axi_inf.mon_cb);
          continue;
        end
        if (axi_inf.mon_cb.RVALID && axi_inf.mon_cb.RREADY) begin
          rd_resp.RDATA = axi_inf.mon_cb.RDATA;
          rd_resp.RRESP = axi_inf.mon_cb.RRESP;
          `uvm_info("AXI_OUT_MON", $sformatf("[R CAPTURED] data=0x%08h resp=%0d", rd_resp.RDATA, rd_resp.RRESP), UVM_HIGH)
          break;
        end
      end

      `uvm_info("AXI_OUT_MON", $sformatf("[READ OUTPUT COMPLETE] data=0x%08h resp=%0d", rd_resp.RDATA, rd_resp.RRESP), UVM_MEDIUM)
      read_ap.write(rd_resp);
    end
  endtask

endclass


`endif
